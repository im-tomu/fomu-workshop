# Fomu Workshop

This repository contains files and projects that will be useful during the Fomu workshop.

Fomu aims to be accessible from multiple levels, from interactive REPL-style scripting all the way down to low-level hardware description languages.

## Micropython

Micropython is a work-in-progress port to Fomu.  Currently the following features exist:

* Manipulate RGB LED
* Read SPI flash ID

### Required Software

* dfu-util
* terminal emulator (screen, Tera Term, picocom, etc.)

### Usage

To load Micropython, use `dfu-util`:

```sh
# If this is the first time loading Micropython
$ dfu-util -D micropython-fomu.dfu

# If Micropython has already been loaded
$ dfu-util -e
```

Then access the USB serial port using your serial program of choice.

## RISC-V

You can directly program the RISC-V softcore on Fomu.  The VexRiscv implements an RV32I core with no multiply unit.

### Required Software

* [Risc-V Toolchain](https://www.sifive.com/boards/)
* make

### Usage

The `riscv-blink/` directory contains a simple "blink" program.  This utilizes the LEDD hardware PWM block to produce a pleasing "fade" pattern.  The `riscv-blink/` example project is entirely self-contained.  All you have to do is go into the directory and run `make`.

For a more advanced example, the `riscv-usb-cdcacm/` directory contains a program that enumerates as a USB serial port.  This simply echoes back any characters that are typed, adding 1 to the value.  For example, if you send "a", it will respond with "b".

As with micropython, you can load these binaries with `dfu-util -D output.bin`.

## HDL

HDL interfaces directly with the hardware.  With Verilog, you have complete control over the chip.  For easier debugging, LiteX lets you write in Python, which provides you with a USB debug bridge.

### Required Software

* [Yosys](https://github.com/FPGAwars/toolchain-yosys/releases/latest)
* [Icestorm](https://github.com/FPGAwars/toolchain-ice40/releases/latest)
* [Nextpnr](https://github.com/FPGAwars/toolchain-ice40/releases/latest)
* [Python](https://www.python.org/downloads/) (for LiteX)

The first is a simple Verilog blink, and is located in the `verilog-blink/` directory.  Go into this directory and run `make FOMU_REV=???`.  You will need to specify the version of Fomu you're using.  Once it is built, you can load the bitstream with `dfu-util -D blink.bin`.