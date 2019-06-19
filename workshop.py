#!/usr/bin/env python3
# This variable defines all the external programs that this module
# relies on.  lxbuildenv reads this variable in order to ensure
# the build will finish without exiting due to missing third-party
# programs.
LX_DEPENDENCIES = ["riscv", "icestorm"]

# Import lxbuildenv to integrate the deps/ directory
import lxbuildenv
    # "python.autoComplete.extraPaths": [
    #     "deps/litescope",
    #     "deps/litex",
    #     "deps/litex_boards",
    #     "deps/lxsocsupport",
    #     "deps/migen",
    #     "deps/valentyusb"
    # ]

# Disable pylint's E1101, which breaks completely on migen
#pylint:disable=E1101

from migen import Module, Signal, Instance, ClockDomain, If
from migen.genlib.resetsync import AsyncResetSynchronizer
from migen.fhdl.specials import TSTriple
from migen.fhdl.bitcontainer import bits_for
from migen.fhdl.structure import ClockSignal, ResetSignal, Replicate, Cat

from litex_boards.partner.platforms.fomu_evt import Platform
from litex.soc.integration import SoCCore
from litex.soc.integration.builder import Builder
from litex.soc.integration.soc_core import csr_map_update
from litex.soc.interconnect import wishbone
from litex.soc.interconnect.csr import AutoCSR, CSRStatus, CSRStorage
from lxsocsupport import up5kspram

class _CRG(Module):
    def __init__(self, platform, use_pll):
        clk48_raw = platform.request("clk48")
        clk12_raw = Signal()
        clk48 = Signal()
        clk12 = Signal()

        reset_delay = Signal(13, reset=4095)
        self.clock_domains.cd_por = ClockDomain()
        self.reset = Signal()

        self.clock_domains.cd_sys = ClockDomain()
        self.clock_domains.cd_usb_12 = ClockDomain()
        self.clock_domains.cd_usb_48 = ClockDomain()

        platform.add_period_constraint(self.cd_usb_48.clk, 1e9/48e6)
        platform.add_period_constraint(self.cd_sys.clk, 1e9/12e6)
        platform.add_period_constraint(self.cd_usb_12.clk, 1e9/12e6)
        platform.add_period_constraint(clk48, 1e9/48e6)
        platform.add_period_constraint(clk48_raw, 1e9/48e6)
        platform.add_period_constraint(clk12_raw, 1e9/12e6)

        # POR reset logic- POR generated from sys clk, POR logic feeds sys clk
        # reset.
        self.comb += [
            self.cd_por.clk.eq(self.cd_sys.clk),
            self.cd_sys.rst.eq(reset_delay != 0),
            self.cd_usb_12.rst.eq(reset_delay != 0),
        ]

        if use_pll:

            # Divide clk48 down to clk12, to ensure they're synchronized.
            # By doing this, we avoid needing clock-domain crossing.
            clk12_counter = Signal(2)

            self.clock_domains.cd_usb_48_raw = ClockDomain()

            platform.add_period_constraint(self.cd_usb_48_raw.clk, 1e9/48e6)

            # POR reset logic- POR generated from sys clk, POR logic feeds sys clk
            # reset.
            self.comb += [
                self.cd_usb_48.rst.eq(reset_delay != 0),
            ]

            self.comb += self.cd_usb_48_raw.clk.eq(clk48_raw)
            self.comb += self.cd_usb_48.clk.eq(clk48)

            self.sync.usb_48_raw += clk12_counter.eq(clk12_counter + 1)

            self.comb += clk12_raw.eq(clk12_counter[1])
            self.specials += Instance(
                "SB_GB",
                i_USER_SIGNAL_TO_GLOBAL_BUFFER=clk12_raw,
                o_GLOBAL_BUFFER_OUTPUT=clk12,
            )

            self.specials += Instance(
                "SB_PLL40_CORE",
                # Parameters
                p_DIVR = 0,
                p_DIVF = 3,
                p_DIVQ = 2,
                p_FILTER_RANGE = 1,
                p_FEEDBACK_PATH = "PHASE_AND_DELAY",
                p_DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED",
                p_FDA_FEEDBACK = 15,
                p_DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED",
                p_FDA_RELATIVE = 0,
                p_SHIFTREG_DIV_MODE = 1,
                p_PLLOUT_SELECT = "SHIFTREG_0deg",
                p_ENABLE_ICEGATE = 0,
                # IO
                i_REFERENCECLK = clk12,
                o_PLLOUTGLOBAL = clk48,
                i_BYPASS = 0,
                i_RESETB = 1,
            )
        else:
            self.specials += Instance(
                "SB_GB",
                i_USER_SIGNAL_TO_GLOBAL_BUFFER=clk48_raw,
                o_GLOBAL_BUFFER_OUTPUT=clk48,
            )
            self.comb += self.cd_usb_48.clk.eq(clk48)

            clk12_counter = Signal(2)
            self.sync.usb_48 += clk12_counter.eq(clk12_counter + 1)

            self.comb += clk12_raw.eq(clk12_counter[1])
            self.specials += Instance(
                "SB_GB",
                i_USER_SIGNAL_TO_GLOBAL_BUFFER=clk12_raw,
                o_GLOBAL_BUFFER_OUTPUT=clk12,
            )

        self.comb += self.cd_sys.clk.eq(clk12)
        self.comb += self.cd_usb_12.clk.eq(clk12)

        self.sync.por += \
            If(reset_delay != 0,
                reset_delay.eq(reset_delay - 1)
            )
        self.specials += AsyncResetSynchronizer(self.cd_por, self.reset)

class PicoRVSpi(Module, AutoCSR):
    def __init__(self, platform, pads, size=2*1024*1024):
        self.size = size

        self.bus = bus = wishbone.Interface()

        self.reset = Signal()

        self.cfg1 = CSRStorage(size=8)
        self.cfg2 = CSRStorage(size=8)
        self.cfg3 = CSRStorage(size=8)
        self.cfg4 = CSRStorage(size=8)

        self.stat1 = CSRStatus(size=8)
        self.stat2 = CSRStatus(size=8)
        self.stat3 = CSRStatus(size=8)
        self.stat4 = CSRStatus(size=8)

        cfg = Signal(32)
        cfg_we = Signal(4)
        cfg_out = Signal(32)
        self.comb += [
            cfg.eq(Cat(self.cfg1.storage, self.cfg2.storage, self.cfg3.storage, self.cfg4.storage)),
            cfg_we.eq(Cat(self.cfg1.re, self.cfg2.re, self.cfg3.re, self.cfg4.re)),
            self.stat1.status.eq(cfg_out[0:8]),
            self.stat2.status.eq(cfg_out[8:16]),
            self.stat3.status.eq(cfg_out[16:24]),
            self.stat4.status.eq(cfg_out[24:32]),
        ]

        mosi_pad = TSTriple()
        miso_pad = TSTriple()
        cs_n_pad = TSTriple()
        clk_pad  = TSTriple()
        wp_pad   = TSTriple()
        hold_pad = TSTriple()
        self.specials += mosi_pad.get_tristate(pads.mosi)
        self.specials += miso_pad.get_tristate(pads.miso)
        self.specials += cs_n_pad.get_tristate(pads.cs_n)
        self.specials += clk_pad.get_tristate(pads.clk)
        self.specials += wp_pad.get_tristate(pads.wp)
        self.specials += hold_pad.get_tristate(pads.hold)

        reset = Signal()
        self.comb += [
            reset.eq(ResetSignal() | self.reset),
            cs_n_pad.oe.eq(~reset),
            clk_pad.oe.eq(~reset),
        ]

        flash_addr = Signal(24)
        mem_bits = bits_for(size)
        self.comb += flash_addr.eq(bus.adr[0:mem_bits-2] << 2),

        read_active = Signal()
        spi_ready = Signal()
        self.sync += [
            If(bus.stb & bus.cyc & ~read_active,
                read_active.eq(1),
                bus.ack.eq(0),
            )
            .Elif(read_active & spi_ready,
                read_active.eq(0),
                bus.ack.eq(1),
            )
            .Else(
                bus.ack.eq(0),
                read_active.eq(0),
            )
        ]

        o_rdata = Signal(32)
        self.comb += bus.dat_r.eq(o_rdata)

        self.specials += Instance("spimemio",
            o_flash_io0_oe = mosi_pad.oe,
            o_flash_io1_oe = miso_pad.oe,
            o_flash_io2_oe = wp_pad.oe,
            o_flash_io3_oe = hold_pad.oe,

            o_flash_io0_do = mosi_pad.o,
            o_flash_io1_do = miso_pad.o,
            o_flash_io2_do = wp_pad.o,
            o_flash_io3_do = hold_pad.o,
            o_flash_csb    = cs_n_pad.o,
            o_flash_clk    = clk_pad.o,

            i_flash_io0_di = mosi_pad.i,
            i_flash_io1_di = miso_pad.i,
            i_flash_io2_di = wp_pad.i,
            i_flash_io3_di = hold_pad.i,

            i_resetn = ~reset,
            i_clk = ClockSignal(),

            i_valid = bus.stb & bus.cyc,
            o_ready = spi_ready,
            i_addr  = flash_addr,
            o_rdata = o_rdata,

	        i_cfgreg_we = cfg_we,
            i_cfgreg_di = cfg,
	        o_cfgreg_do = cfg_out,
        )
        platform.add_source("rtl/spimemio.v")

class BaseSoC(SoCCore):
    csr_peripherals = [
        "ddrphy",
#        "dna",
        "xadc",
        "cpu_or_bridge",
    ]
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

    mem_map = {
        "spiflash": 0x20000000,  # (default shadow @0xa0000000)
    }
    mem_map.update(SoCCore.mem_map)

    def __init__(self, platform, output_dir="build", use_pll=True, **kwargs):
        clk_freq = int(12e6)
        self.output_dir = output_dir
        self.submodules.crg = _CRG(platform, use_pll=use_pll)
        SoCCore.__init__(self, platform, clk_freq,
                integrated_sram_size=0, with_uart=False,
                **kwargs)

        # SPRAM- UP5K has single port RAM, might as well use it as SRAM to
        # free up scarce block RAM.
        spram_size = 128*1024
        self.submodules.spram = up5kspram.Up5kSPRAM(size=spram_size)
        self.register_mem("sram", 0x10000000, self.spram.bus, spram_size)

        # Add a simple bit-banged SPI Flash module based on PicoRVSpi
        spi_pads = platform.request("spiflash")
        self.submodules.picorvspi = PicoRVSpi(platform, spi_pads)
        self.register_mem("spiflash", self.mem_map["spiflash"],
            self.picorvspi.bus, size=self.picorvspi.size)

        bios_size = 0x8000
        kwargs['cpu_reset_address']=self.mem_map["spiflash"]+platform.gateware_size
        self.add_memory_region("rom", kwargs['cpu_reset_address'], bios_size)
        self.add_constant("ROM_DISABLE", 1)
        self.flash_boot_address = self.mem_map["spiflash"]+platform.gateware_size+bios_size
        self.add_memory_region("user_flash",
            self.flash_boot_address,
            # Leave a grace area- possible one-by-off bug in add_memory_region?
            # Possible fix: addr < origin + length - 1
            platform.spiflash_total_size - (self.flash_boot_address - self.mem_map["spiflash"]) - 0x100)

        if hasattr(self, "cpu"):
            self.cpu.use_external_variant("rtl/2-stage-1024-cache.v")
            self.copy_memory_file("2-stage-1024-cache.v_toplevel_RegFilePlugin_regFile.bin")

    def copy_memory_file(self, src):
        import os
        from shutil import copyfile
        if not os.path.exists(self.output_dir):
            os.mkdir(self.output_dir)
        if not os.path.exists(os.path.join(self.output_dir, "gateware")):
            os.mkdir(os.path.join(self.output_dir, "gateware"))
        copyfile(os.path.join("rtl", src), os.path.join(self.output_dir, "gateware", src))

def main():
    platform = Platform()
    soc = BaseSoC(platform)
    builder = Builder(soc,
                      output_dir="build", csr_csv="test/csr.csv",
                      compile_software=False)
    vns = builder.build()
    soc.do_exit(vns)

if __name__ == "__main__":
    main()
