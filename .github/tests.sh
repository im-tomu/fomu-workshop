#!/bin/bash

set -e

TOOLCHAIN_PATH="$(find fomu-toolchain-* -type d -maxdepth 0 2>/dev/null)"
echo "TOOLCHAIN_PATH: $TOOLCHAIN_PATH"

export PATH=$TOOLCHAIN_PATH/bin:$PATH

# Test the RISC-V C example
travis_fold start "RISC-V C Example"
travis_time_start
(
	set -x
	cd riscv-blink
	make
	file riscv-blink.dfu
)
travis_time_finish
travis_fold end "RISC-V C Example"

# Test the Verilog Blink (basic) example
travis_fold start "Verilog Blink (basic) example"
travis_time_start
(
	set -x
	cd verilog/blink-basic
	make
	file blink.dfu
)
travis_time_finish
travis_fold end "Verilog Blink (basic) example"

# Test the Verilog Blink (extended) example for Hacker
travis_fold start "Verilog Blink (extended) example for Hacker board"
travis_time_start
(
	set -x
	cd verilog/blink-extended
	make FOMU_DEV=hacker
	file blink.dfu
)
travis_time_finish
travis_fold end "Verilog Blink (extended) example for Hacker board"

# Test the Verilog Blink (extended) example for PVT
travis_fold start "Verilog Blink (extended) example for PVT board"
travis_time_start
(
	set -x
	cd verilog/blink-extended
	make FOMU_DEV=pvt
	file blink.dfu
)
travis_time_finish
travis_fold end "Verilog Blink (extended) example for PVT board"

# Test the LiteX example for Hacker
travis_fold start "LiteX example for Hacker"
travis_time_start
(
	set -x
	cd litex
	./workshop.py --board=hacker
	file build/gateware/top.dfu
)
travis_time_finish
travis_fold end "LiteX example for Hacker"

# Test the LiteX example for PVT
travis_fold start "LiteX example for PVT"
travis_time_start
(
	set -x
	cd litex
	./workshop.py --board=pvt
	file build/gateware/top.dfu
)
travis_time_finish
travis_fold end "LiteX example for PVT"
