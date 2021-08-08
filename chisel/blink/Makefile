# Simple Fomu Makefile
# --------------------
# This Makefile shows the steps to generate a DFU loadable image onto
# Fomu hacker board.

include ../../hdl/board.mk

# Default target: run all required targets to build the DFU image.
all: blink.dfu
	@true

.DEFAULT: all

# Call sbt to generate the Blink.sv from Chisel.
# Please note that in general, it is a lot faster to
# start `sbt` once and then to run `run` on the `sbt`
# command line every time you want to rebuild the verilog.
# Unfortunately `sbt` start up times are notoriously bad :(
Blink.sv: src/Blink.scala build.sbt
	sbt "run $(FOMU_REV)"

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
blink.json: Blink.sv
	yosys \
		$(YOSYSFLAGS) \
		-p 'synth_ice40 -top Blink -json blink.json' Blink.sv

# Use **nextpnr** to generate the FPGA configuration.
# This is called the **place** and **route** step.
blink.asc: blink.json
	nextpnr-ice40 \
		$(PNRFLAGS) \
		--pcf ../../pcf/fomu-$(FOMU_REV).pcf \
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
	-rm -f Blink.fir
	-rm -f Blink.anno.json
	-rm -f Blink.sv
	-rm -f blink.json 	# Generate netlist
	-rm -f blink.asc 	# FPGA configuration
	-rm -f blink.bit 	# FPGA bitstream
	-rm -f blink.dfu 	# DFU image loadable onto the Fomu

.PHONY: clean
