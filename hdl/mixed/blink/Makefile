include ../../board.mk

DESIGN = blink
TOP    = Fomu_Blink

# VHDL top with instantiated Verilog
VHDL_SYN_FILES    = ../../sb_ice40_components.vhd blink.vhd
VERILOG_SYN_FILES = clkgen.v

# Verilog top with instantiated VHDL
#VHDL_SYN_FILES = ../../sb_ice40_components.vhd clkgen.vhd
#VERILOG_SYN_FILES = blink.v

GHDL_FLAGS += --std=08
GHDL       ?= ghdl
GHDLSYNTH  ?= ghdl
YOSYS      ?= yosys
NEXTPNR    ?= nextpnr-ice40
ICEPACK    ?= icepack

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
	@true

.DEFAULT: all

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
$(DESIGN).json: $(VHDL_SYN_FILES) $(VERILOG_SYN_FILES)
	$(YOSYS) $(YOSYSFLAGS) \
		-p \
		"$(GHDLSYNTH) $(GHDL_FLAGS) $(VHDL_SYN_FILES) -e; \
		synth_ice40 \
		-top $(TOP) \
		-json $@" $(VERILOG_SYN_FILES) 2>&1 | tee yosys-report.txt

# Use **nextpnr** to generate the FPGA configuration.
# This is called the **place** and **route** step.
$(DESIGN).asc: $(DESIGN).json $(PCF)
	$(NEXTPNR) \
		$(PNRFLAGS) \
		--pcf $(PCF) \
		--json $< \
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
	dfu-util -D $<

.PHONY: load

# Cleanup the generated files.
clean:
	rm -fr *.cf *.json *-report.txt *.asc *.bit *.dfu

.PHONY: clean
