CONTAINER_ENGINE ?= docker

PWD = $(shell pwd)
CONTAINER_ARGS = run \
	--rm \
	-v /$(PWD)/../../..://wrk \
	-w //wrk/hdl/$(notdir $(shell dirname $(PWD)))/$(notdir $(PWD))

GHDL    = $(CONTAINER_ENGINE) $(CONTAINER_ARGS) gcr.io/hdl-containers/ghdl/yosys ghdl
YOSYS   = $(CONTAINER_ENGINE) $(CONTAINER_ARGS) gcr.io/hdl-containers/ghdl/yosys yosys
NEXTPNR = $(CONTAINER_ENGINE) $(CONTAINER_ARGS) gcr.io/hdl-containers/nextpnr/ice40 nextpnr-ice40
ICEPACK = $(CONTAINER_ENGINE) $(CONTAINER_ARGS) gcr.io/hdl-containers/icestorm icepack
