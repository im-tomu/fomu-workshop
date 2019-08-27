#!/usr/bin/env python3
# This variable defines all the external programs that this module
# relies on.  lxbuildenv reads this variable in order to ensure
# the build will finish without exiting due to missing third-party
# programs.
LX_DEPENDENCIES = ["icestorm", "yosys", "nextpnr-ice40"]
LX_CONFIG = "skip-git"

# Import lxbuildenv to integrate the deps/ directory
import os,os.path,shutil,sys,subprocess
sys.path.insert(0, os.path.dirname(__file__))
import lxbuildenv

# Disable pylint's E1101, which breaks completely on migen
#pylint:disable=E1101

from litex.soc.integration import SoCCore
from litex.soc.integration.builder import Builder

from migen.genlib.resetsync import AsyncResetSynchronizer

from lxsocsupport import up5kspram

from valentyusb.usbcore import io as usbio
from valentyusb.usbcore.cpu import dummyusb

from migen import *
from litex.soc.interconnect.csr import AutoCSR, CSRStatus, CSRStorage

import argparse

class _CRG(Module):
    def __init__(self, platform):
        clk48_raw = platform.request("clk48")
        clk12 = Signal()

        reset_delay = Signal(12, reset=4095)
        self.clock_domains.cd_por = ClockDomain()
        self.reset = Signal()

        self.clock_domains.cd_sys = ClockDomain()
        self.clock_domains.cd_usb_12 = ClockDomain()
        self.clock_domains.cd_usb_48 = ClockDomain()

        platform.add_period_constraint(self.cd_usb_48.clk, 1e9/48e6)
        platform.add_period_constraint(self.cd_sys.clk, 1e9/12e6)
        platform.add_period_constraint(self.cd_usb_12.clk, 1e9/12e6)
        platform.add_period_constraint(clk48_raw, 1e9/48e6)

        # POR reset logic- POR generated from sys clk, POR logic feeds sys clk
        # reset.
        self.comb += [
            self.cd_por.clk.eq(self.cd_sys.clk),
            self.cd_sys.rst.eq(reset_delay != 0),
            self.cd_usb_12.rst.eq(reset_delay != 0),
        ]

        # POR reset logic- POR generated from sys clk, POR logic feeds sys clk
        # reset.
        self.comb += [
            self.cd_usb_48.rst.eq(reset_delay != 0),
        ]

        self.comb += self.cd_usb_48.clk.eq(clk48_raw)

        self.specials += Instance(
            "SB_PLL40_CORE",
            # Parameters
            p_DIVR = 0,
            p_DIVF = 15,
            p_DIVQ = 5,
            p_FILTER_RANGE = 1,
            p_FEEDBACK_PATH = "SIMPLE",
            p_DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED",
            p_FDA_FEEDBACK = 15,
            p_DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED",
            p_FDA_RELATIVE = 0,
            p_SHIFTREG_DIV_MODE = 1,
            p_PLLOUT_SELECT = "GENCLK_HALF",
            p_ENABLE_ICEGATE = 0,
            # IO
            i_REFERENCECLK = clk48_raw,
            o_PLLOUTCORE = clk12,
            # o_PLLOUTGLOBAL = clk12,
            #i_EXTFEEDBACK,
            #i_DYNAMICDELAY,
            #o_LOCK,
            i_BYPASS = 0,
            i_RESETB = 1,
            #i_LATCHINPUTVALUE,
            #o_SDO,
            #i_SDI,
        )

        self.comb += self.cd_sys.clk.eq(clk12)
        self.comb += self.cd_usb_12.clk.eq(clk12)

        self.sync.por += \
            If(reset_delay != 0,
                reset_delay.eq(reset_delay - 1)
            )
        self.specials += AsyncResetSynchronizer(self.cd_por, self.reset)


class BaseSoC(SoCCore):
    SoCCore.csr_map = {
        "ctrl":           0,  # provided by default (optional)
        "crg":            1,  # user
        "uart_phy":       2,  # provided by default (optional)
        "uart":           3,  # provided by default (optional)
        "identifier_mem": 4,  # provided by default (optional)
        "timer0":         5,  # provided by default (optional)
        "cpu_or_bridge":  8,
        "usb":            9,
        "picorvspi":      10,
        "touch":          11,
        "reboot":         12,
        "rgb":            13,
        "version":        14,
    }

    def __init__(self, platform, output_dir="build",  placer=None, pnr_seed=0, use_pll=True, **kwargs):
        clk_freq = int(12e6)
        self.submodules.crg = _CRG(platform)
        SoCCore.__init__(self, platform, clk_freq,
                cpu_type=None,
                cpu_variant=None,
                integrated_sram_size=0,
                with_uart=False,
                with_ctrl=False,
                **kwargs)

        # UP5K has single port RAM, which is a dedicated 128 kilobyte block.
        # Use this as CPU RAM.
        spram_size = 128*1024
        self.submodules.spram = up5kspram.Up5kSPRAM(size=spram_size)
        self.register_mem("sram", 0x10000000, self.spram.bus, spram_size)

        # Add USB pads.  We use DummyUsb, which simply enumerates as a USB
        # device.  Then all interaction is done via the wishbone bridge.
        usb_pads = platform.request("usb")
        usb_iobuf = usbio.IoBuf(usb_pads.d_p, usb_pads.d_n, usb_pads.pullup)
        self.submodules.usb = dummyusb.DummyUsb(usb_iobuf, debug=True)
        self.add_wb_master(self.usb.debug_bridge.wishbone)

        # Add "-relut -dffe_min_ce_use 4" to the synth_ice40 command.
        # "-reult" adds an additional LUT pass to pack more stuff in, and
        # "-dffe_min_ce_use 4" flag prevents Yosys from generating a
        # Clock Enable signal for a LUT that has fewer than 4 flip-flops.
        # This increases density, and lets us use the FPGA more efficiently.
        platform.toolchain.nextpnr_yosys_template[2] += " -relut -dffe_min_ce_use 4"

        # Allow us to set the nextpnr seed, because some values don't meet timing.
        platform.toolchain.nextpnr_build_template[1] += " --seed " + str(pnr_seed)

        # Different placers can improve packing efficiency, however not all placers
        # are enabled on all builds of nextpnr-ice40.  Let the user override which
        # placer they want to use.
        if placer is not None:
            platform.toolchain.nextpnr_build_template[1] += " --placer {}".format(placer)


def add_dfu_suffix(fn):
    fn_base, ext = os.path.splitext(fn)
    fn_dfu = fn_base + '.dfu'
    shutil.copyfile(fn, fn_dfu)
    subprocess.check_call(['dfu-suffix', '--pid', '1209', '--vid', '5bf0', '--add', fn_dfu])


def main():
    parser = argparse.ArgumentParser(
        description="Build Fomu Main Gateware")
    parser.add_argument(
        "--seed", default=0, help="seed to use in nextpnr"
    )
    parser.add_argument(
        "--placer", default="heap", choices=["sa", "heap"], help="which placer to use in nextpnr"
    )
    parser.add_argument(
        "--no-pll", help="disable pll -- this is easier to route, but may not work", action="store_true"
    )
    parser.add_argument(
        "--board", choices=["evt", "pvt", "hacker"], required=True,
        help="build for a particular hardware board"
    )
    args = parser.parse_args()

    if args.board == "pvt":
        from litex_boards.partner.platforms.fomu_pvt import Platform
    elif args.board == "hacker":
        from litex_boards.partner.platforms.fomu_hacker import Platform
    elif args.board == "evt":
        from litex_boards.partner.platforms.fomu_evt import Platform
    platform = Platform()
    soc = BaseSoC(platform, pnr_seed=args.seed, placer=args.placer, use_pll=not args.no_pll)
    builder = Builder(soc,
                      output_dir="build", csr_csv="test/csr.csv",
                      compile_software=False)
    vns = builder.build()
    soc.do_exit(vns)
    add_dfu_suffix(os.path.join('build', 'gateware', 'top.bin'))


if __name__ == "__main__":
    main()
