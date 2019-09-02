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

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.soc.integration import SoCCore
from litex.soc.integration.builder import Builder
from litex.soc.interconnect.csr import AutoCSR, CSRStatus, CSRStorage

from litex_boards.partner.targets.fomu import BaseSoC, add_dfu_suffix

from valentyusb.usbcore import io as usbio
from valentyusb.usbcore.cpu import dummyusb

import argparse

class FomuRGB(Module, AutoCSR):
    def __init__(self, pads):
        self.output = CSRStorage(3)
        self.specials += Instance("SB_RGBA_DRV",
            i_CURREN = 0b1,
            i_RGBLEDEN = 0b1,
            i_RGB0PWM = self.output.storage[0],
            i_RGB1PWM = self.output.storage[1],
            i_RGB2PWM = self.output.storage[2],
            o_RGB0 = pads.r,
            o_RGB1 = pads.g,
            o_RGB2 = pads.b,
            p_CURRENT_MODE = "0b1",
            p_RGB0_CURRENT = "0b000011",
            p_RGB1_CURRENT = "0b000011",
            p_RGB2_CURRENT = "0b000011",
        )

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
        "--board", choices=["evt", "pvt", "hacker"], required=True,
        help="build for a particular hardware board"
    )
    args = parser.parse_args()

    soc = BaseSoC(args.board, pnr_seed=args.seed, pnr_placer=args.placer, usb_bridge=True)

    # Add the LED driver block.  Get the `rgb_led` pins from the definition
    # file, then instantiate the module we defined above.
    led_pads = soc.platform.request("rgb_led")
    soc.submodules.fomu_rgb = FomuRGB(led_pads)

    # Indicate that `fomu_rgb` is a CSR, and should be added to the bus.
    # Otherwise we wouldn't be able to access `fomu_rgb` at all.
    # Note that the value here must match the value above, so if you did
    # `soc.submodules.frgb = FomuRGB(led_pads)` then you would need to
    # change this to `soc.add_csr("frgb")`.
    soc.add_csr("fomu_rgb")

    builder = Builder(soc,
                      output_dir="build", csr_csv="build/csr.csv",
                      compile_software=False)
    vns = builder.build()
    soc.do_exit(vns)
    add_dfu_suffix(os.path.join('build', 'gateware', 'top.bin'))


if __name__ == "__main__":
    main()
