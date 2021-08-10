include ../../board.mk

DESIGN = blink
TOP    = top

VERILOG_SYN_FILES = blink.v

YOSYS     ?= yosys
NEXTPNR   ?= nextpnr-ice40
ICEPACK   ?= icepack

SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c

QUIET = @

# If a container engine is used, each tool is executed in a separated container
ifdef CONTAINER_ENGINE
include ../../container.mk
endif

# Default target: run all required targets to build the DFU image.
all: $(DESIGN).dfu
	$(QUIET) echo "Built '$(DESIGN)' for Fomu $(FOMU_REV)"

.DEFAULT: all

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
$(DESIGN).json: $(VERILOG_SYN_FILES)
	$(QUIET) $(YOSYS) $(YOSYSFLAGS) \
		-p  \
		"synth_ice40 \
		-top $(TOP) \
		-json $@" $(VERILOG_SYN_FILES) 2>&1 | tee yosys-report.txt

include ../../PnR_Prog.mk

.PHONY: load

# Cleanup the generated files.
clean:
	rm -fr *.json *-report.txt *.asc *.bit *.dfu

.PHONY: clean
