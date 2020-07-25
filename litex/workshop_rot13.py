#!/usr/bin/env python3
# This variable defines all the external programs that this module
# relies on.  lxbuildenv reads this variable in order to ensure
# the build will finish without exiting due to missing third-party
# programs.
LX_DEPENDENCIES = ["icestorm", "yosys", "nextpnr-ice40"]
#LX_CONFIG = "skip-git" # This can be useful for workshops

# Import lxbuildenv to integrate the deps/ directory
import os,os.path,shutil,sys,subprocess
sys.path.insert(0, os.path.dirname(__file__))
import lxbuildenv

# Disable pylint's E1101, which breaks completely on migen
#pylint:disable=E1101

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.soc.integration.soc_core import SoCCore
from litex.soc.integration.builder import Builder
from litex.soc.interconnect.csr import AutoCSR, CSRStatus, CSRStorage, CSRField

from litex_boards.partner.targets.fomu import BaseSoC, add_dfu_suffix

from valentyusb.usbcore import io as usbio
from valentyusb.usbcore.cpu import dummyusb

import argparse

# ROT13 input CSR. Doesn't need to do anything special.
class FomuROT13In(Module, AutoCSR):
    def __init__(self):
        self.csr = CSRStorage(8)

# ROT13 output CSR, plus the wiring to automatically create the output from the input CSR.
class FomuROT13Out(Module, AutoCSR):
    def __init__(self, rot13_in):
        self.csr = CSRStorage(8)
        self.sync += If( # A-M, a-m
                (rot13_in.csr.storage >= ord('A')) & (rot13_in.csr.storage <= ord('M')) | (rot13_in.csr.storage >= ord('a')) & (rot13_in.csr.storage <= ord('m')),
                self.csr.storage.eq(rot13_in.csr.storage + 13)
            ).Elif( # N-Z, n-z
                (rot13_in.csr.storage >= ord('N')) & (rot13_in.csr.storage <= ord('Z')) | (rot13_in.csr.storage >= ord('n')) & (rot13_in.csr.storage <= ord('z')),
                self.csr.storage.eq(rot13_in.csr.storage - 13)
            ).Else(
                self.csr.storage.eq(rot13_in.csr.storage)
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

    # Create a CSR-based ROT13 input and output, export the CSRs
    rot13_in = FomuROT13In()
    soc.submodules.fomu_rot13_in = rot13_in
    soc.submodules.fomu_rot13_out = FomuROT13Out(rot13_in)
    soc.add_csr("fomu_rot13_in")
    soc.add_csr("fomu_rot13_out")

    builder = Builder(soc,
                      output_dir="build", csr_csv="build/csr.csv",
                      compile_software=False)
    vns = builder.build()
    soc.do_exit(vns)
    add_dfu_suffix(os.path.join('build', 'gateware', 'top.bin'))


if __name__ == "__main__":
    main()
