# Minimal Mixed HDL Example (VHDL and Verilog)

A minimal mixed HDL example which simply blinks the RGB LEDs at different
frequencies.

This example contains equivalent sources in VHDL and Verilog, which can be
combined freely:

- `blink.vhd` + `clkgen.v`
- `blink.v` + `clkgen.vhdl`
- `blink.vhd` + `clkgen.vhdl`
- `blink.v` + `clkgen.v`

All four cases produce exactly the same result, because the same design is
described regardless of the HDL language used. In the makefile, the first
case is built by default.

## Using

Type `make` to build the DFU image.
Type `make load` to load the DFU image onto the Fomu board.
Type `make clean` to remove all the generated files.
