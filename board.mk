# Different Fomu hardware revisions are wired differently and thus
# require different configurations for yosys and nextpnr.
# Configuration is performed by setting the environment variable FOMU_REV accordingly.
ifeq ($(FOMU_REV),evt1)
YOSYSFLAGS ?= -D EVT=1
PNRFLAGS   ?= --up5k --package sg48
PCF        ?= ../../pcf/fomu-evt2.pcf
else ifeq ($(FOMU_REV),evt2)
YOSYSFLAGS ?= -D EVT=1
PNRFLAGS   ?= --up5k --package sg48
PCF        ?= ../../pcf/fomu-evt2.pcf
else ifeq ($(FOMU_REV),evt3)
YOSYSFLAGS ?= -D EVT=1
PNRFLAGS   ?= --up5k --package sg48
PCF        ?= ../../pcf/fomu-evt3.pcf
else ifeq ($(FOMU_REV),hacker)
YOSYSFLAGS ?= -D HACKER=1
PNRFLAGS   ?= --up5k --package uwg30
PCF        ?= ../../pcf/fomu-hacker.pcf
else ifeq ($(FOMU_REV),pvt)
YOSYSFLAGS ?= -D PVT=1
PNRFLAGS   ?= --up5k --package uwg30
PCF        ?= ../../pcf/fomu-pvt.pcf
else
$(error Unrecognized FOMU_REV value. must be "evt1", "evt2", "evt3", "pvt", or "hacker")
endif
