# Different Fomu hardware revisions are wired differently and thus
# require different configurations for yosys and nextpnr.
# Configuration is performed by setting the environment variable FOMU_REV accordingly.
ifeq ($(FOMU_REV),evt1)
YOSYSFLAGS?= -D EVT=1
PNRFLAGS  ?= --up5k --package sg48 --pcf ../../pcf/fomu-evt2.pcf
else ifeq ($(FOMU_REV),evt2)
YOSYSFLAGS?= -D EVT=1
PNRFLAGS  ?= --up5k --package sg48 --pcf ../../pcf/fomu-evt2.pcf
else ifeq ($(FOMU_REV),evt3)
YOSYSFLAGS?= -D EVT=1
PNRFLAGS  ?= --up5k --package sg48 --pcf ../../pcf/fomu-evt3.pcf
else ifeq ($(FOMU_REV),hacker)
YOSYSFLAGS?= -D HACKER=1
PNRFLAGS  ?= --up5k --package uwg30 --pcf ../../pcf/fomu-hacker.pcf
else ifeq ($(FOMU_REV),pvt)
YOSYSFLAGS?= -D PVT=1
PNRFLAGS  ?= --up5k --package uwg30 --pcf ../../pcf/fomu-pvt.pcf
else
$(error Unrecognized FOMU_REV value. must be "evt1", "evt2", "evt3", "pvt", or "hacker")
endif

VHDL_SYN_FILES = ../sb_ice40_components.vhd blink.vhd

GHDL_FLAGS += --std=08
GHDL      ?= ghdl
GHDLSYNTH ?= ghdl
YOSYS     ?= yosys
NEXTPNR   ?= nextpnr-ice40
ICEPACK   ?= icepack

# Default target: run all required targets to build the DFU image.
all: blink.dfu
	@true

.DEFAULT: all

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
blink.json: $(VHDL_SYN_FILES)
	$(YOSYS) $(YOSYSFLAGS) \
		-p \
		"$(GHDLSYNTH) $(GHDL_FLAGS) $^ -e; \
		synth_ice40 \
		-top Fomu_Blink \
		-json $@" 2>&1 | tee yosys-report.txt

# Use **nextpnr** to generate the FPGA configuration.
# This is called the **place** and **route** step.
blink.asc: blink.json
	$(NEXTPNR) \
		$(PNRFLAGS) \
		--json $< \
		--asc $@

# Use icepack to convert the FPGA configuration into a "bitstream" loadable onto the FPGA.
# This is called the bitstream generation step.
blink.bit: blink.asc
	$(ICEPACK) $< $@

# Use dfu-suffix to generate the DFU image from the FPGA bitstream.
blink.dfu: blink.bit
	cp $< $@
	dfu-suffix -v 1209 -p 70b1 -a $@

# Use df-util to load the DFU image onto the Fomu.
load: blink.dfu
	dfu-util -D $<

.PHONY: load

# Cleanup the generated files.
clean:
	rm -fr *.cf *.json *-report.txt *.asc *.bit *.dfu

.PHONY: clean
