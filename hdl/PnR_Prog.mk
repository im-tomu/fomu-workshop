COPY ?= cp -a

# Use **nextpnr** to generate the FPGA configuration.
# This is called the **place** and **route** step.
$(DESIGN).asc: $(DESIGN).json $(PCF)
	$(QUIET) $(NEXTPNR) \
		$(PNRFLAGS) \
		--pcf $(PCF) \
		--json $(DESIGN).json \
		--asc $@

# Use icepack to convert the FPGA configuration into a "bitstream" loadable onto the FPGA.
# This is called the bitstream generation step.
$(DESIGN).bit: $(DESIGN).asc
	$(QUIET) $(ICEPACK) $< $@

# Use dfu-suffix to generate the DFU image from the FPGA bitstream.
$(DESIGN).dfu: $(DESIGN).bit
	$(QUIET) $(COPY) $< $@
	$(QUIET) dfu-suffix -v 1209 -p 70b1 -a $@

# Use df-util to load the DFU image onto the Fomu.
load: $(DESIGN).dfu
	dfu-util -D $<
