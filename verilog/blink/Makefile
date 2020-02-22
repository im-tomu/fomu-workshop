# Simple Fomu Makefile
# --------------------
# This Makefile shows the steps to generate a DFU loadable image onto
# Fomu hacker board.

# Different Fomu hardware revisions are wired differently and thus
# require different configurations for yosys and nextpnr.
# Configuration is performed by setting the environment variable FOMU_REV accordingly.
ifeq ($(FOMU_REV),evt1)
YOSYSFLAGS?= -D EVT=1
PNRFLAGS  ?= --up5k --package sg48 --pcf ../pcf/fomu-evt2.pcf
else ifeq ($(FOMU_REV),evt2)
YOSYSFLAGS?= -D EVT=1
PNRFLAGS  ?= --up5k --package sg48 --pcf ../pcf/fomu-evt2.pcf
else ifeq ($(FOMU_REV),evt3)
YOSYSFLAGS?= -D EVT=1
PNRFLAGS  ?= --up5k --package sg48 --pcf ../pcf/fomu-evt3.pcf
else ifeq ($(FOMU_REV),hacker)
YOSYSFLAGS?= -D HACKER=1
PNRFLAGS  ?= --up5k --package uwg30 --pcf ../pcf/fomu-hacker.pcf
else ifeq ($(FOMU_REV),pvt)
YOSYSFLAGS?= -D PVT=1
PNRFLAGS  ?= --up5k --package uwg30 --pcf ../pcf/fomu-pvt.pcf
else
$(error Unrecognized FOMU_REV value. must be "evt1", "evt2", "evt3", "pvt", or "hacker")
endif

# Default target: run all required targets to build the DFU image.
all: blink.dfu
	@true

.DEFAULT: all

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
blink.json: blink.v
	yosys \
		$(YOSYSFLAGS) \
		-p 'synth_ice40 -top top -json blink.json' blink.v

# Use **nextpnr** to generate the FPGA configuration.
# This is called the **place** and **route** step.
blink.asc: blink.json ../pcf/fomu-hacker.pcf
	nextpnr-ice40 \
		$(PNRFLAGS) \
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

.PHONY: clean
