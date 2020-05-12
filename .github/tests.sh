#!/bin/bash

set -e

TOOLCHAIN_PATH="$PWD/$(find fomu-toolchain-* -type d -maxdepth 0 2>/dev/null)"
echo "TOOLCHAIN_PATH: $TOOLCHAIN_PATH"

export PATH=$TOOLCHAIN_PATH/bin:$PATH

# Test the RISC-V C example
travis_fold start riscv-c
echo "RISC-V C Example"
travis_time_start
(
	set -x
	cd riscv-blink
	make
	file riscv-blink.dfu
)
travis_time_finish
travis_fold end riscv-c

# Test the RISC-V zig example
travis_fold start riscv-zig
echo "RISC-V Zig Example"
travis_time_start
(
	set -x
	cd riscv-zig-blink
	zig build
	file riscv-zig-blink.bin
)
travis_time_finish
travis_fold end riscv-zig


# Test the Verilog Blink example
travis_fold start verilog-blink
echo "Verilog Blink example"
travis_time_start
(
	set -x
	cd verilog/blink
	make FOMU_REV=pvt
	file blink.dfu
)
travis_time_finish
travis_fold end verilog-blink

# Test the Verilog Blink (expanded) example for Hacker
travis_fold start verilog-blink-expanded-hacker
echo "Verilog Blink (expanded) example for Hacker board"
travis_time_start
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=hacker
	file blink.dfu
)
travis_time_finish
travis_fold end verilog-blink-expanded-hacker

# Test the Verilog Blink (expanded) example for PVT
travis_fold start verilog-blink-expanded-pvt
echo "Verilog Blink (expanded) example for PVT board"
travis_time_start
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=pvt
	file blink.dfu
)
travis_time_finish
travis_fold end verilog-blink-expanded-pvt

# Test the LiteX example for Hacker
travis_fold start litex-hacker
echo "LiteX example for Hacker"
travis_time_start
(
	set -x
	cd litex
	./workshop.py --board=hacker
	file build/gateware/top.dfu
)
travis_time_finish
travis_fold end litex-hacker

# Test the LiteX example for PVT
travis_fold start litex-pvt
echo "LiteX example for PVT"
travis_time_start
(
	set -x
	cd litex
	./workshop.py --board=pvt
	file build/gateware/top.dfu
)
travis_time_finish
travis_fold end litex-pvt
