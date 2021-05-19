PACKAGE   ?= blink
TOP       ?= $(PACKAGE)

# Currently GIT_VERSION is unusd and there are no tags, so skip calculating it
#GIT_VERSION := $(shell git describe --tags)

# Default programs
NEXTPNR   ?= nextpnr-ice40
YOSYS     ?= yosys
ICEPACK   ?= icepack

# Add Windows and Unix support
RM         = rm -rf
COPY       = cp -a
PATH_SEP   = /
ifeq ($(OS),Windows_NT)
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

include ../../board.mk

BUILD_DIR  = build
VSOURCES   = $(wildcard *.v)
QUIET      = @

ALL        = all
TARGET     = $(PACKAGE).bin
CLEAN      = clean

$(ALL): $(TARGET) $(PACKAGE).dfu
	$(QUIET) echo "Built '$(PACKAGE)' for Fomu $(FOMU_REV)"

run: $(TARGET)
	fomu-flash -f $(TARGET)

run-dfu: $(PACKAGE).dfu
	dfu-util -D $(PACKAGE).dfu

$(BUILD_DIR)/$(PACKAGE).json: $(VSOURCES) | $(BUILD_DIR)
	$(QUIET) echo " SYNTH    $@"
	$(QUIET) $(YOSYS) $(YOSYSFLAGS) -p 'synth_ice40 -top $(TOP) -json $@' $(PACKAGE).v

$(BUILD_DIR)/$(PACKAGE).asc: $(BUILD_DIR)/$(PACKAGE).json $(PCF)
	$(QUIET) echo " PNR      $@"
	$(QUIET) $(NEXTPNR) $(PNRFLAGS) --json $(BUILD_DIR)/$(PACKAGE).json --pcf $(PCF) --asc $@

$(TARGET): $(BUILD_DIR)/$(PACKAGE).asc
	$(QUIET) echo " PACK     $@"
	$(QUIET) $(ICEPACK) $(BUILD_DIR)/$(PACKAGE).asc $@

$(PACKAGE).dfu: $(TARGET)
	$(QUIET) echo "  DFU      $@"
	$(QUIET) $(COPY) $(PACKAGE).bin $@
	$(QUIET) dfu-suffix -v 1209 -p 70b1 -a $@

$(BUILD_DIR):
	$(QUIET) mkdir $(BUILD_DIR)

.PHONY: clean

clean:
	$(QUIET) echo "  RM      $(subst /,$(PATH_SEP),$(wildcard $(BUILD_DIR)/*.json))"
	-$(QUIET) $(RM) $(subst /,$(PATH_SEP),$(wildcard $(BUILD_DIR)/*.json))
	$(QUIET) echo "  RM      $(subst /,$(PATH_SEP),$(wildcard $(BUILD_DIR)/*.asc))"
	-$(QUIET) $(RM) $(subst /,$(PATH_SEP),$(wildcard $(BUILD_DIR)/*.asc))
	$(QUIET) echo "  RM      $(TARGET) $(PACKAGE).bin $(PACKAGE).dfu"
	-$(QUIET) $(RM) $(subst /,$(PATH_SEP),abc.history)
	$(QUIET) echo "  RM      $(TARGET) abc.history"
	-$(QUIET) $(RM) $(TARGET) $(PACKAGE).bin $(PACKAGE).dfu
