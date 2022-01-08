include ../../board.mk

DESIGN = blink
TOP    = $(DESIGN)

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

# Add Windows and Unix support
RM         = rm -rf
COPY       = cp -a
PATH_SEP   = /
ifeq ($(OS),Windows_NT)
ifndef MSYSTEM
# When SHELL=sh.exe and this actually exists, make will silently
# switch to using that instead of cmd.exe.  Unfortunately, there's
# no way to tell which environment we're running under without either
# (1) printing out an error message, or (2) finding something that
# works everywhere.
# As a result, we force the shell to be cmd.exe, so it works both
# under cygwin and normal Windows.
SHELL      = cmd.exe
COPY       = copy
RM         = del
PATH_SEP   = \\
endif
endif

all: $(DESIGN).dfu
	$(QUIET) echo "Built '$(DESIGN)' for Fomu $(FOMU_REV)"

.DEFAULT: all

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
$(DESIGN).json: $(VERILOG_SYN_FILES)
	$(QUIET) $(YOSYS) $(YOSYSFLAGS) \
		-p \
		"read_verilog $(VERILOG_SYN_FILES); \
		synth_ice40 \
		-top $(TOP) \
		-json $@" 2>&1 | tee yosys-report.txt

include ../../PnR_Prog.mk

run: $(DESIGN).bin
	fomu-flash -f $<

.PHONY: load

clean:
	rm -fr *.json *-report.txt *.asc *.bit *.dfu
