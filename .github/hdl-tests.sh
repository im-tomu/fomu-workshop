#!/bin/bash

set -e

cd $(dirname "$0")/../hdl

echo '::group::Verilog Blink example'
(
	set -x
	cd verilog/blink
	make FOMU_REV=pvt blink.bit
	[ -f blink.bit ]
)
echo '::endgroup::'

echo '::group::Verilog Blink (expanded) example for Hacker board'
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=hacker blink.bit
	[ -f blink.bit ]
)
echo '::endgroup::'

echo '::group::Verilog Blink (expanded) example for PVT board'
(
	set -x
	cd verilog/blink-expanded
	make FOMU_REV=pvt blink.bit
	[ -f blink.bit ]
)
echo '::endgroup::'

echo '::group::VHDL Blink example'
(
	set -x
	cd vhdl/blink
	make FOMU_REV=pvt blink.bit
	[ -f blink.bit ]
)
echo '::endgroup::'

echo '::group::Mixed HDL Blink example'
(
	set -x
	cd mixed/blink
	make FOMU_REV=pvt blink.bit
	[ -f blink.bit ]
)
echo '::endgroup::'
