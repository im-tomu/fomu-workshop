# Minimal Verilog Example - Expanded Version

A minimal Verilog example which permanantly blinks the green LED and
supports enabling the red and blue LED by button press or connecting pins.

## Using

Type `make` to build the DFU image.
Type `dfu-util -D blink.dfu` to load the DFU image onto the Fomu board.
Type `make clean` to remove all the generated files.
