# Simple Fomu Makefile
# --------------------
# This Makefile shows the steps to generate an DFU loadable image onto
# Fomu PVT board.

# Default target.
all: blink.dfu
	@true

.DEFAULT: all

# Use *Yosys* generate the synthesized netlist
# This is called the **synthesis** and **tech mapping** step.
blink.json: blink.v
	yosys -p 'synth_ice40 -top top -json blink.json' blink.v

# Use **nextpnr** generate the FPGA configuration.
# This is called the **place** and **route** step.
blink.asc: blink.json ../pcf/fomu-pvt.pcf
	nextpnr-ice40 \
		--up5k --package uwg30 \
		--pcf ../pcf/fomu-pvt.pcf \
		--json blink.json \
		--asc blink.asc

# Use icepack to convert the FPGA configuration into a "bitstream" loadable onto the FPGA.
# This is called the bitstream generation step.
blink.bit: blink.asc
	icepack blink.asc blink.bit

# Use dfu-suffix to generate the DFU image from the FPGA bitstream.
blink.dfu: blink.bit
	cp blink.bit blink.dfu
	dfu-suffix -v 1209 -p 70b1 -a blink.dfu

# Use df-util to load the DFU image onto the Fomu.
load: blink.dfu
	dfu-util -D blink.dfu

.PHONY: load

# Cleanup the generated files.
clean:
	-rm -f blink.json 	# Generate netlist
	-rm -f blink.asc 	# FPGA configuration
	-rm -f blink.bit 	# FPGA bitstream
	-rm -f blink.dfu 	# DFU image loadable onto the Fomu

.PHONY: load
