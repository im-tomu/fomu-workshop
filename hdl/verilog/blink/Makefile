# Simple Fomu Makefile
# --------------------
# This Makefile shows the steps to generate a DFU loadable image onto
# Fomu hacker board.

include ../../board.mk

DESIGN = blink
TOP    = top

VERILOG_SYN_FILES = blink.v

YOSYS     ?= yosys
NEXTPNR   ?= nextpnr-ice40
ICEPACK   ?= icepack

# If a container engine is used, each tool is executed in a separated container
ifdef CONTAINER_ENGINE
include ../../container.mk
endif

# Default target: run all required targets to build the DFU image.
all: $(DESIGN).dfu
	@true

.DEFAULT: all

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
$(DESIGN).json: $(VERILOG_SYN_FILES)
	$(YOSYS) $(YOSYSFLAGS) \
		-p  \
		"synth_ice40 \
		-top $(TOP) \
		-json $@" $(VERILOG_SYN_FILES) 2>&1 | tee yosys-report.txt

# Use **nextpnr** to generate the FPGA configuration.
# This is called the **place** and **route** step.
$(DESIGN).asc: $(DESIGN).json $(PCF)
	$(NEXTPNR) \
		$(PNRFLAGS) \
		--pcf $(PCF) \
		--json  $< \
		--asc $@

# Use icepack to convert the FPGA configuration into a "bitstream" loadable onto the FPGA.
# This is called the bitstream generation step.
$(DESIGN).bit: $(DESIGN).asc
	$(ICEPACK) $< $@

# Use dfu-suffix to generate the DFU image from the FPGA bitstream.
$(DESIGN).dfu: $(DESIGN).bit
	cp $< $@
	dfu-suffix -v 1209 -p 70b1 -a $@

# Use df-util to load the DFU image onto the Fomu.
load: $(DESIGN).dfu
	dfu-util -D  $<

.PHONY: load

# Cleanup the generated files.
clean:
	-rm -f $(DESIGN).json 	# Generate netlist
	-rm -f $(DESIGN).asc 	# FPGA configuration
	-rm -f $(DESIGN).bit 	# FPGA bitstream
	-rm -f $(DESIGN).dfu 	# DFU image loadable onto the Fomu

.PHONY: clean
