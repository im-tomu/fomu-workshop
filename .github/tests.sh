#!/bin/bash

set -e

TOOLCHAIN_PATH="$PWD/$(find fomu-toolchain-* -type d -maxdepth 0 2>/dev/null)"
echo "TOOLCHAIN_PATH: $TOOLCHAIN_PATH"

export PATH=$TOOLCHAIN_PATH/bin:$PATH

echo '::group::RISC-V C Example'
(
	set -x
	cd riscv-blink
	make
	file riscv-blink.dfu
)
echo '::endgroup::'

echo '::group::RISC-V Zig Example'
(
	set -x
	cd riscv-zig-blink
	zig build
	file riscv-zig-blink.bin
)
echo '::endgroup::'

echo '::group::Verilog Blink example'
(
	set -x
	cd verilog/blink
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'

echo '::group::Verilog Blink (expanded) example for Hacker board'
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=hacker
	file blink.dfu
)
echo '::endgroup::'

echo '::group::Verilog Blink (expanded) example for PVT board'
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'

echo '::group::LiteX example for Hacker'
(
	set -x
	cd litex
	./workshop.py --board=hacker
	file build/gateware/top.dfu
)
echo '::endgroup::'

echo '::group::LiteX example for PVT'
(
	set -x
	cd litex
	./workshop.py --board=pvt
	file build/gateware/top.dfu
)
echo '::endgroup::'
