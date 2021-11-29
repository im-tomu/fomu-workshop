# When using fomu toolchain to synthezise VHDL, GHDL_PREFIX has to be set
# See https://github.com/YosysHQ/fpga-toolchain#using-ghdl

ifndef GHDL_PREFIX
# If GHDL_PREFIX is not user-supplied, determine it from ghdl invocation
# Skip if ghdl is not available
	ifneq (, $(shell which ghdl))
		GHDL_PREFIX := $(shell dirname $(shell ghdl --libghdl-library-path))/ghdl
		export GHDL_PREFIX := $(GHDL_PREFIX)
	endif
endif
