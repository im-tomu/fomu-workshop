include ../../board.mk

DESIGN = blink
TOP    = Fomu_Blink

VHDL_SYN_FILES = ../../sb_ice40_components.vhd blink.vhd

GHDL_FLAGS += --std=08
GHDL       ?= ghdl
GHDLSYNTH  ?= ghdl
YOSYS      ?= yosys
NEXTPNR    ?= nextpnr-ice40
ICEPACK    ?= icepack

QUIET = @

# If ghdl-yosys-plugin is built as a module (not the case with fomu-toolchain)
ifdef GHDL_PLUGIN_MODULE
YOSYSFLAGS += -m $(GHDL_PLUGIN_MODULE)
endif

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
$(DESIGN).json: $(VHDL_SYN_FILES)
	$(QUIET) $(YOSYS) $(YOSYSFLAGS) \
		-p \
		"$(GHDLSYNTH) $(GHDL_FLAGS) $^ -e; \
		synth_ice40 \
		-top $(TOP) \
		-json $@" 2>&1 | tee yosys-report.txt

include ../../PnR_Prog.mk

.PHONY: load

# Cleanup the generated files.
clean:
	rm -fr *.cf *.json *-report.txt *.asc *.bit *.dfu

.PHONY: clean
