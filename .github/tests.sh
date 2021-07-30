#!/bin/bash

set -e

TOOLCHAIN_PATH="${TOOLCHAIN_PATH:-$PWD/$(find fomu-toolchain-* -type d -maxdepth 0 2>/dev/null)}"
echo "TOOLCHAIN_PATH: $TOOLCHAIN_PATH"

export PATH=$TOOLCHAIN_PATH/bin:$PATH
export GHDL_PREFIX=$TOOLCHAIN_PATH/lib/ghdl

$(dirname "$0")/hdl-tests.sh

echo '::group::RISC-V C Example'
(
	set -x
	cd riscv-blink
	make
	file riscv-blink.dfu
)
echo '::endgroup::'

if [ "x$RUNNER_OS" != "xmacOS" ]; then
echo '::group::RISC-V Zig Example'
(
	set -x
	cd riscv-zig-blink
	zig build
	file riscv-zig-blink.bin
)
echo '::endgroup::'
fi

echo '::group::LiteX example for Hacker'
(
	set -ex
	cd litex
	./workshop.py --board=hacker
	file build/gateware/fomu_hacker.dfu
	file build/gateware/fomu_hacker.bin
	rm -rf build        
)
echo '::endgroup::'

echo '::group::LiteX example for PVT'
(
	set -ex
	cd litex
	./workshop.py --board=pvt
	file build/gateware/fomu_pvt.dfu
	file build/gateware/fomu_pvt.bin
	rm -rf build        
)
echo '::endgroup::'

echo '::group::LiteX RGB example for PVT'
(
	set -ex
	cd litex
	./workshop_rgb.py --board=pvt
	file build/gateware/fomu_pvt.dfu
	file build/gateware/fomu_pvt.bin
	rm -rf build        
)
echo '::endgroup::'

echo '::group::Migen Blink example for PVT board'
(
	set -x
	cd migen
	FOMU_REV=pvt ./blink.py
	file build/top.bin
	rm -rf build
)
echo '::endgroup::'

echo '::group::Migen Blink (expanded) example for PVT board'
(
	set -x
	cd migen
	FOMU_REV=pvt ./blink-expanded.py
	file build/top.bin
	rm -rf build
)
echo '::endgroup::'

echo '::group::Chisel Blink example'
(
	set -x
	cd chisel/blink
	make FOMU_REV=pvt
	file blink.dfu
)
echo '::endgroup::'
