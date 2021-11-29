# When using fomu toolchain to synthezise VHDL, GHDL_PREFIX has to be set
# See https://github.com/YosysHQ/fpga-toolchain#using-ghdl

GHDL_PREFIX ?= $(shell dirname $(shell ghdl --libghdl-library-path))/ghdl
export GHDL_PREFIX := $(GHDL_PREFIX)
