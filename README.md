# Fomu Workshop

![Hi, I'm Fomu!](img/logo.png "Fomu logo")

Hi, I'm Fomu!  This workshop covers the basics of Fomu in a top-down approach.  We'll start out by learning what Fomu is, how to load software into Fomu, and finally how to write software for Fomu.

FPGAs are complex, weird things, so we'll take a gentle approach and start out by treating it like a Python interpreter first, and gradually peel away layers until we're writing our own hardware registers.  You can take a break at any time and explore!  Stop when you feel the concepts are too unfamiliar, or plough on and dig deep into the world of hardware.

## Required Software

Fomu requires specialized software.  Namely, you must have the following software on your system:

| Tool | Purpose |
| ---- |------------------ |
| **[yosys](https://github.com/YosysHQ/yosys)** | Verilog synthesis |
| **[nextpnr-ice40](https://github.com/YosysHQ/nextpnr)** | FPGA place-and-route |
| **[icestorm](https://github.com/cliffordwolf/icestorm)** | FPGA bitstream packing |
| **[riscv toolchain](https://www.sifive.com/boards/)** | Compile code for a RISC-V softcore |
| **[dfu-util](https://dfu-util.sourceforge.net/)** | Load a bitstream or code onto Fomu |
| **[python](https://python.org/)** | Convert Migen/Litex code to Verilog |
| **[wishbone-tool](https://github.com/xobs/wishbone-utils/)** | Interact with Fomu over USB |
| **serial console** | Interact with Python over a virtual console |

This software is provided for Linux x86/64, macOS, and Windows, via [Fomu Toolchain] (github.com/im-tomu/fomu-toolchain/releases/latest). If you're taking this workshop as a class, the toolchain are provided on the USB disk. Debian packages are also [available for Raspberry Pi](https://github.com/im-tomu/fomu-raspbian-packages). For other platforms, please see the people running the workshop.

To install the software, extract it somewhere on your computer, then open up a terminal window and add that directory to your PATH:

* MacOS: `export PATH=[path-to-bin]:$PATH`
* Linux: `export PATH=[path-to-bin]:$PATH`
* Windows Powershell: `$ENV:PATH = "[path-to-bin];" + $ENV:PATH`
* Windows cmd.exe: `PATH=[path-to-bin];%PATH`

To confirm installation, run a command such as `nextpnr-ice40` or `yosys`.

## Required Hardware

For this workshop, you will need a Fomu board. This workshop may be competed with any model of Fomu, though there are some parts that require you to identify which model you have:

1. **Fomu EVT3**: This model of Fomu is about the size of a credit card. It should have the text "Fomu EVT3" written across it in white silkscreen. If you have a different EVT board such as EVT2 or EVT1, they should work also.
1. **Fomu PVT1**: If you ordered a Fomu from Crowd Supply, this is the model you'll receive. It is small, and fits in a USB port. There is no silkscreen on it. This model of Fomu has a large silver crystal oscillator that is the tallest component on the board.
1. **Fomu Hacker**: These are the original design and are easiest to manufacture. If you received one directly from Tim, you probably have one of these. Hacker boards have white silkscreen on the back.

Your Fomu should be running Foboot v1.8.7 or newer. You can see what version you are running by typing "dfu-util -l" and noting the version number.

Aside from that, you need a computer with a USB port that can run the toolchain software. You should need any special drivers, though on Linux you may need sudo access, or special udev rules to grant permission to use the USB device from a non-privileged account.

## About FPGAs

Field Programmable Gate Arrays (FPGAs) are arrays of gates that are programmable in the field.  Unlike most chips you will encounter, which have transistor gates arranged in a fixed order, FPGAs can change their configuration by simply loading new code.  Fundamentally, this code programs lookup tables which form the basic building blocks of logic.

These lookup tables (called LUTs) are so important to the design of an FPGA that they usually form part of the name of the part.  For example, Fomu uses a UP5K, which has about 5000 LUTs.  NeTV used an LX9, which had about 9000 LUTs, and NeTV2 uses a XC7A35T that has about 35000 LUTs.

![ICE40 LUT](img/ice40-lut.png "The ICE40 LUT4 is a basic 4-input 1-output LUT")

This is the `SB_LUT4`, which is the basic building block of Fomu.  It has four inputs and one output.  To program Fomu, we must define what each possible input pattern will create on the output.

To do this, we turn to a truth table:

|      | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 |
| ---- |---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|
| IO0  | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1  | 1  | 1  | 1  | 1  | 1  |
| IO1  | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 0 | 0 | 0  | 0  | 1  | 1  | 1  | 1  |
| IO2  | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 1  | 1  | 0  | 0  | 1  | 1  |
| IO3  | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0  | 1  | 0  | 1  | 0  | 1  |
| O    |_?_|_?_|_?_|_?_|_?_|_?_|_?_|_?_|_?_|_?_|_?_ |_?_ |_?_ |_?_ |_?_ |_?_ |

For example, to create a LUT that acted as an AND gate, we would define O to be 0 for everything except the last column.  To create a NAND gate, we would define O to be 1 for everything from the last column.

FPGA LUTs are almost always _n_-inputs to 1-output. The ICE family of FPGAs from Lattice have 4-input LUTs. Xilinx parts tend to have 5- or 6-input LUTs which generally means they can do more logic in fewer LUTs. Comparing LUT count between FPGAs is a bit like comparing clock speed between different CPUs - not entirely accurate, but certainly a helpful rule of thumb.

It is from this simple primitive that we build up the building blocks of FPGA design.

### Turning code into gates

Writing lookup tables is hard, so people have come up with abstract Hardware Description Languages (HDLs) we can use to describe them.  The two most common languages are Verilog and VHDL.  In the open source world, Verilog is more common.  However, a modern trend is to embed an HDL inside an existing programming language, such as how Migen is embedded in Python, or SpinalHDL is embedded in Scala.

Here is an example of a Verilog module:

```verilog
module example (output reg [0:5] Q, input C);
	reg [0:8] counter;
	always @(posedge C)
	begin
		counter <= counter + 1'b1;
		Q = counter[3] ^ counter[5] | counter<<2;
	end
endmodule
```

We can run this Verilog module through a synthesizer to turn it into `SB_LUT4` blocks, or we can turn it into a more familiar logic diagram:

![Verilog Synthesis](img/verilog-synthesis.png "A syntheis of the above logic into some gates")

If we do decide to synthesize to `SB_LUT4` blocks, we will end up with a pile of LUTs that need to be strung together somehow.  This is done by a Place-and-Route tool.  This performs the job of assigning physical LUTs to each LUT that gets defined by the synthesizer, and then figuring out how to wire it all up.

Once the place-and-route tool is done, it generates an abstract file that needs to be translated into a format that the hardware can recognize.  This is done by a bitstream packing tool.  Finally, this bitstream needs to be loaded onto the device somehow, either off of a SPI flash or by manually programming it by toggling wires.

### About the ICE40UP5K

we will use an ICE40UP5K for this workshop.  This chip has a number of very nice features:


1. 5280 4-input LUTs (LC)
1. 16 kilobytes BRAM
1. **128 kilobytes "SPRAM"**
1. Current-limited 3-channel LED driver
1. 2x I2C and 2x SPI
1. 8 16-bit DSP units
1. **Warmboot capability**
1. **Open toolchain**

Many FPGAs have what's called block RAM, or BRAM.  This is frequently used to store data such as buffers, CPU register files, and large arrays of data.  This type of memory is frequently reused as RAM on many FPGAs.  The ICE40UP5K is unusual in that it also as 128 kilobytes of Single Ported RAM that can be used as memory for a softcore.  That means that, unlike other FPGAs, valuable block ram isn't taken up by system memory.

Additionally, the ICE40 family of devices generally supports "warmboot" capability.  This enables us to have multiple designs live on the same FPGA and tell the FPGA to swap between them.

As always, this workshop wouldn't be nearly as easy without the open toolchain that enables us to port it to a lot of different platforms.

### About Fomu

Fomu is an ICE40UP5K that fits in your USB port.  It contains two megabytes of SPI flash memory, four edge buttons, and a three-color LED.  Unlike most other ICE40 projects, Fomu implements its USB in a softcore.  That means that the bitstream that runs on the FPGA must also provide the ability to communicate over USB.  This uses up a lot of storage on this small FPGA, but it also enables us to have such a tiny form factor, and lets us do some really cool things with it.

![Fomu Block Diagram](img/fomu-block-diagram.png "Block diagram of Fomu")

The ICE40UP5K at the heart of Fomu really controls everything, and this workshop is all about trying to unlock the power of this chip.

### Working with Fomu

There is a default bootloader that runs when you plug in Fomu.  It is called `foboot`, and it presents itself as a DFU image.  Future versions of Fomu will include a bootloader that shows up as an external drive, however for now we're still using DFU.

Verify the drivers were installed.  Plug in your Fomu now and see if you can see it using `dfu-util -l`:

```sh
$ dfu-util -l
dfu-util 0.8
Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2014 Tormod Volden and Stefan Schmidt
This program is Free Software and has ABSOLUTELY NO WARRANTY
Please report bugs to dfu-util@lists.gnumonks.org

Found DFU: [1209:5bf0] ver=0101, devnum=21, cfg=1, intf=0, alt=0, name="Fomu Hacker running DFU Bootloader v1.8.8", serial="UNKNOWN"
$
```

If you get the above message, it means your computer has successfully detected Fomu.  If you get a "permission denied" error in Linux, try running `sudo dfu-util -l`, or add a `udev` rule to give your user permission to the usb device.

To load a binary image onto Fomu, we use the `-D` option:

```sh
$ dfu-util -D file.dfu
Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2014 Tormod Volden and Stefan Schmidt
This program is Free Software and has ABSOLUTELY NO WARRANTY
Please report bugs to dfu-util@lists.gnumonks.org

Match vendor ID from file: 1209
Match product ID from file: 5bf0
Opening DFU capable USB device...
ID 1209:5bf0
Run-time device DFU version 0101
Claiming USB DFU Interface...
Setting Alternate Setting #0 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 0101
Device returned transfer size 1024
Copying data from PC to DFU device
Download        [=========================] 100%       132908 bytes
Download done.
```

After the image is loaded, Fomu will start the new image.  You can load RISC-V code or an ICE40 bitstream.

To restart Fomu, unplug it and plug it back in.  This will start the bootloader.  To run the program on Fomu without needing to load it again, use the `-e` option:

```sh
$ dfu-util -e
Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2014 Tormod Volden and Stefan Schmidt
This program is Free Software and has ABSOLUTELY NO WARRANTY
Please report bugs to dfu-util@lists.gnumonks.org

Opening DFU capable USB device...
ID 1209:5bf0
Run-time device DFU version 0101
Claiming USB DFU Interface...
Setting Alternate Setting #0 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 0101
Device returned transfer size 1024
$
```

## Python on Fomu

You can load Python onto Fomu as an ordinary RISC-V binary.  It is located in the root of the Fomu workshop files.  Use `dfu-util` to load it:

```sh
$ dfu-util.exe -D micropython-fomu.dfu
Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2014 Tormod Volden and Stefan Schmidt
This program is Free Software and has ABSOLUTELY NO WARRANTY
Please report bugs to dfu-util@lists.gnumonks.org

Opening DFU capable USB device...
ID 1209:5bf0
Run-time device DFU version 0101
Claiming USB DFU Interface...
Setting Alternate Setting #0 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 0101
Device returned transfer size 1024
$
```

If you're on a macOS machine, use the following command to connect to the device:

```sh
$ screen /dev/cu.usbserial*
```

If you're on Linux, it will be called `ttyACM?`:

```sh
$ screen /dev/ttyACM*
```

On Windows, you can use a program such as teraterm, which is included in the Fomu Toolchain:

```powershell
PS> ttermpro.exe
```

You should be greeted with a MicroPython banner and REPL:

```
MicroPython v1.10-299-g8603316 on 2019-08-19; fomu with vexriscv
>>>
```

This is a fully-functioning MicroPython shell.  Try running some simple commands such as `print()` and `hex(9876+1234)`.

### Fomu with Python

Fomu has a few extended modules that you can use to interact with some of the hardware.  For example, the RGB LED has some predefined modes you can access.  These are all located under the `fomu` module.

Import the `fomu` module and access the `rgb` block to change the mode to the predefined `error` mode:

```python
>>> import fomu
>>> rgb = fomu.rgb()
>>> rgb.mode("error")
>>> 
```

We can also look at some information from the SPI flash, such as the SPI ID.  This ID varies between Fomu models, so it can be a good indication of what kind of Fomu your code is running on:

```python
>>> spi = fomu.spi()
>>> hex(spi.id())
'0xc2152815'
>>> 
```

### Memory-mapped Registers

If we look at the generated Fomu header files, we can see many, many memory-mapped registers.  For example, the major, minor, and revision numbers all have registers:

```cpp
#define CSR_VERSION_MAJOR_ADDR 0xe0007000
#define CSR_VERSION_MINOR_ADDR 0xe0007004
#define CSR_VERSION_REVISION_ADDR 0xe0007008
#define CSR_VERSION_MODEL_ADDR 0xe0007028
```

These are special areas of memory that don't really exist.  Instead, they correspond to hardware.  We can read these values using the `machine` class.  Read out the major, minor, and revision codes from your Fomu.  They may be different from what you see here:

```python
>>> import machine
>>> machine.mem32[0xe0007000]
1
>>> machine.mem32[0xe0007004]
8
>>> machine.mem32[0xe0007008]
7
>>>
```

The `CSR_VERSION_MODEL_ADDR` contains a single character that indicates what version of the hardware you have.  We can convert this to a character and print it out.  For a Production PVT Fomu, you might see this:

```python
>>> chr(machine.mem32[0xe0007028])
'P'
>>>
```

### Memory-mapped RGB driver

The blinking LED is actually a hardware block from Lattice.  It has control registers, and we can modify these registers by writing to memory in Fomu.  Some of these registers control things such as the timing of the fade in and fade out pulses, and some control the level of each of the three colors.

![ICE40 LEDD](img/ice40-ledd.png "Registers of the ICE40 RGB driver")

There is a wrapper in Python that simplifies the process of writing to these registers.  The first argument is the register number, and the second argument is the value to write.

Try changing the color of the three LEDs:

```python
>>> rgb.write_raw(0b0001, 255)
>>> rgb.write_raw(0b1010, 14)
>>> rgb.write_raw(0b1011, 1)
>>>
```

The color should change immediately.  More information on these registers can be found in the [iCE40 LED Driver Usage Guide](reference/FPGA-TN-1288-ICE40LEDDriverUsageGuide.pdf).

## Fomu as a CPU

The MicroPython interface is simply a RISC-V program.  It interacts with the RISC-V softcore by reading and writing memory directly.

The CPU in Fomu is built on LiteX, which places every device on a Wishbone bus.  This is a 32-bit internal bus that maps peripherals into memory.

![Litex Design](img/litex-design.png "Fomu peripherals on the Wishbone bus")

If you look at the diagram above, you can see that everything in the system is on the Wishbone bus.  The CPU is a bus master, and can initiate reads and writes.  The system's RAM is on the wishbone bus, and is currently located at address `0x10000000`.  The boot ROM is also on the bus, and is located at `0x00000000`.  There is also SPI flash which is memory-mapped, so when you load your program onto SPI it shows up on the Wishbone bus at offset `0x20040000`.

The Configuration and Status Registers (CSRs) all show up at offset `0xe0000000`.  These are the registers we were accessing from Python.  Just like before, these special memory addresses correspond to control values.

You'll notice a "Bridge" in the diagram above.  This is an optional feature that we ship by default on Fomu.  It bridges the Wishbone bus to another device.  In our case, it makes Wishbone available over USB.

![Litex Design](img/wishbone-usb-debug-bridge.png "Fomu peripherals on the Wishbone bus")

This is a special USB packet we can generate to access the Wishbone bus from a host PC.  It lets us do two things: Read a 32-bit value from Wishbone, or write a 32-bit value to Wishbone.  These two primitives give us complete control over Fomu.

Recall these definitions from earlier:

```cpp
#define CSR_VERSION_MAJOR_ADDR 0xe0007000
#define CSR_VERSION_MINOR_ADDR 0xe0007004
#define CSR_VERSION_REVISION_ADDR 0xe0007008
#define CSR_VERSION_MODEL_ADDR 0xe0007028
```

We can use the `wishbone-tool` program to read these values directly out of Fomu:

```sh
$ wishbone-tool 0xe0007000
Value at e0007000: 00000001
$ wishbone-tool 0xe0007004
Value at e0007004: 00000008
$ wishbone-tool 0xe0007008
Value at e0007008: 00000007
$
```

The three values correspond to the version number of the board at time of writing: v1.8.7.

We can also read and write directly to memory.  Recall that memory is mapped to address `0x10000000`.  Let's write a test value there and try to read it back.

```sh
$ wishbone-tool 0x10000000
Value at 10000000: 00000005
$ wishbone-tool 0x10000000 0x12345678
$ wishbone-tool 0x10000000
Value at 10000000: 0x12345678
```

We can see that the value got stored in memory, just like we thought it would.  The bridge is working, and we have access to Fomu over USB.

## Interacting with the LED Directly

Recall the LED block from Python.  We used `rgb.write_raw()` to write values to the LED block.  Because of how the LED block is implemented, we need to actually make two writes to the Wishbone bus in order to write one value to the LED block.  The first write sets the address, and the second write sends the actual data.

The registers for the LED block are defined as:

```cpp
#define CSR_RGB_DAT_ADDR 0xe0006800
#define CSR_RGB_ADDR_ADDR 0xe0006804
```

Let's change the red color to the maximum value.  To do that, we'll write a `1` to the address register, and `0xff` to the data register:

```sh
$ wishbone-tool 0xe0006804 1
$ wishbone-tool 0xe0006800 0xff
```

We can see that the LED immediately changed its behavior.  Try playing around with various values to see what combinations you can come up with!

You can reset Fomu by writing a special value to the `CSR_REBOOT_CTRL` register at `0xe0006000L`.  All writes to this register must start with `0xac`, to ensure random values aren't written.  We can reboot Fomu by simply writing this value:

```sh
$ wishbone-tool 0xe0006000 0xac
INFO [wishbone_tool::usb_bridge] opened USB device device 007 on bus 001
INFO [wishbone_tool::usb_bridge] waiting for target device
ERROR [wishbone_tool] server error: BridgeError(USBError(Pipe))
$
```

We can see that `wishbone-tool` has crashed with an error of `USBError(Pipe)`, because the USB device went away as we were talking to it.  This is expected behavior.  Fomu should be back to its normal color and blink rate now.

## Compiling RISC-V Code

Of course, Fomu's softcore is a full CPU, so we can write C code for it.  Go to the `riscv-blink/` directory and run `make`.  This will generate `riscv-blink.bin`, which we can load onto Fomu.

```sh
$ make
  CC       ./src/main.c        main.o
  CC       ./src/rgb.c rgb.o
  CC       ./src/time.c        time.o
  AS       ./src/crt0-vexriscv.S       crt0-vexriscv.o
  LD       riscv-blink.elf
  OBJCOPY  riscv-blink.bin
  IHEX     riscv-blink.ihex
$ dfu-util -D riscv-blink.bin
Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2014 Tormod Volden and Stefan Schmidt
This program is Free Software and has ABSOLUTELY NO WARRANTY
Please report bugs to dfu-util@lists.gnumonks.org

Match vendor ID from file: 1209
Match product ID from file: 5bf0
Opening DFU capable USB device...
ID 1209:5bf0
Run-time device DFU version 0101
Claiming USB DFU Interface...
Setting Alternate Setting #0 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 0101
Device returned transfer size 1024
Copying data from PC to DFU device
Download        [======                   ]  24%        804 bytes
$
```

This will load the binary onto Fomu and start it immediately.  The LED should be blinking quickly in a rainbow pattern.  Congratulations!  You've compiled and loaded a RISC-V program onto a softcore.

Let's modify the program by increasing the fade rate so much that it appears solid.  First, reboot Fomu by running `wishbone-tool 0xe0006000 0xac`.  Next, apply the following patch to `src/main.c`:

```patch
--- a/riscv-blink/src/main.c
+++ b/riscv-blink/src/main.c
@@ -38,6 +38,7 @@ void isr(void) {
 void main(void) {
     rgb_init();
     irq_setie(0);
+    rgb_write((100000/64000)-1, LEDDBR);
     int i = 0;
     while (1) {
         i++;
```

What this does is increase the LED blink rate from 250 Hz to a much higher value.  Compile this and load it again with `dfu-util -D riscv-blink.bin`.  The blink rate should appear solid, because it's blinking too quickly to see.

## Debugging RISC-V Code

Because we have `peek` and `poke`, and because the USB bridge is a bus master, we can actually halt (and reset!) the CPU over the USB bridge.  We can go even further and attach a full debugger to it!

To start with, run `wishbone-tool -s gdb`:

```sh
$ wishbone-tool -s gdb
INFO [wishbone_tool::usb_bridge] opened USB device device 008 on bus 001
INFO [wishbone_tool::server] accepting connections on 0.0.0.0:1234
```

In a second window, run gdb on `riscv-blink.elf`:

```sh
 $ riscv64-unknown-elf-gdb riscv-blink.elf -ex 'target remote localhost:1234'
 GNU gdb (GDB) 8.2.90.20190228-git
 Copyright (C) 2019 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "--host=x86_64-w64-mingw32 --target=riscv64-unknown-elf".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from .\riscv-blink.elf...
Remote debugging using localhost:1234
csr_writel (addr=3758106660, value=1) at ./include/hw/common.h:41
41              *((volatile uint32_t *)addr) = value;
(gdb)
```

If we run `bt` we can get a backtrace, and chances are that we landed in an `msleep` function:

```gdb
(gdb) bt
#0  0x2004014c in csr_readl (addr=3758106664) at ./include/hw/common.h:46
#1  timer0_value_read () at ./include/generated/csr.h:242
#2  0x200401dc in msleep (ms=ms@entry=80) at ./include/hw/common.h:41
#3  0x20040074 in main () at ./src/main.c:45
(gdb)
```

We can insert breakpoints, step, continue execution, and generally debug the entire system.  We can even reset the program by running `mon reset`.

### Further RISC-V experiments

There is an additional RISC-V demo in the workshop.  The `riscv-usb-cdcacm` directory contains a simple USB serial device that simply echoes back any characters that you type, incremented by 1.  This is a good way to get started with an interactive terminal program, or logging data via USB serial.

## Hardware Description Languages

The two most important programs for us when writing HDL are `yosys` and `nextpnr`.  A big feature of `nextpnr`, and a huge advantage over its predecessor, is the fact that it's timing-driven:

```
Max frequency for clock 'clk12':   24.63 MHz (PASS at 12.00 MHz)
Max frequency for clock 'clk48_1': 60.66 MHz (PASS at 48.00 MHz)
Max frequency for clock 'clkraw': 228.05 MHz (PASS at 48.00 MHz)
```

You'll see output like this when you run `nextpnr-ice40`, and it means that a given clock domain is guaranteed to be accurate at a given speed.  In the above example, we could run `clk12` at up to 24.63 MHz and it would still be stable, even though we only requested 12.00 MHz.  Note that there is some variation between designs depending on how the placer and router decided to lay things out.

The canonical "Hello, world!" of hardware is to blink an LED.  The directory `verilog-blink` contains a Verilog example of a blink project.  This takes the 48 MHz clock and divides it down by quite a lot so you get an on/off pattern.  It also exposes some of the signals on the touchpads, making it possible to probe them with an oscilloscope.

Build the blink demo by using `make`:

```sh
$ make FOMU_REV=hacker
...
Info: Max frequency for clock 'clk': 79.76 MHz (PASS at 12.00 MHz)

Info: Max delay <async>     -> <async>: 13.29 ns
Info: Max delay posedge clk -> <async>: 6.46 ns

Info: Slack histogram:
Info:  legend: * represents 1 endpoint(s)
Info:          + represents [1,1) endpoint(s)
Info: [ 70046,  70496) |*
Info: [ 70496,  70946) |*
Info: [ 70946,  71396) |**
Info: [ 71396,  71846) |**
Info: [ 71846,  72296) |**
Info: [ 72296,  72746) |**
Info: [ 72746,  73196) |
Info: [ 73196,  73646) |*
Info: [ 73646,  74096) |*
Info: [ 74096,  74546) |**
Info: [ 74546,  74996) |**
Info: [ 74996,  75446) |*
Info: [ 75446,  75896) |*
Info: [ 75896,  76346) |
Info: [ 76346,  76796) |**
Info: [ 76796,  77246) |***
Info: [ 77246,  77696) |*
Info: [ 77696,  78146) |*
Info: [ 78146,  78596) |
Info: [ 78596,  79046) |*************************
4 warnings, 0 errors
 PACK     blink.bin
Built 'blink' for Fomu hacker
$
```

You can load `blink.bin` onto Fomu by using the same `dfu-util -D` command we've been using.  The LED should begin blinking on and off regularly, indicating your bitstream was successfully loaded.

The USB core is written in Verilog, so you won't have access to Fomu when writing raw Verilog code.

### Migen and LiteX

Recall that Migen is an HDL embedded in Python, and LiteX provides us with a Wishbone abstraction layer.  There really is no reason we need to include a CPU with our design, but we can still reuse the USB Wishbone bridge in order to write HDL code.

We can use `DummyUsb` to respond to USB requests and bridge USB to Wishbone, and rely on LiteX to generate registers and wire them to hardware signals.  We can still use `wishbone-tool` to read and write memory, and with a wishbone bridge we can actually have code running on our local system that can read and write memory on Fomu.

```diff
- If you cloned this directory via git without the '--recursive' flag, you might have to
- execute 'git submodule update --init', for python to find the dependencies (eg. 'litex_boards').
```

Go to the `litex` directory and build the design and load it onto Fomu:

```sh
$ python3 workshop.py --board hacker
lxbuildenv: v2019.8.19.1 (run .\workshop.py --lx-help for help)
lxbuildenv: Skipping git configuration because "skip-git" was found in LX_CONFIGURATION
lxbuildenv: To fetch from git, run .\workshop.py --placer heap --lx-check-git
Warning: Wire top.basesoc_adr has an unprocessed 'init' attribute.
Warning: Wire top.basesoc_bus_wishbone_ack has an unprocessed 'init' attribute.
Warning: Wire top.basesoc_bus_wishbone_dat_r has an unprocessed 'init' attribute.
...
Info: Device utilisation:
Info:            ICESTORM_LC:  1483/ 5280    28%
Info:           ICESTORM_RAM:     1/   30     3%
Info:                  SB_IO:     4/   96     4%
Info:                  SB_GB:     8/    8   100%
Info:           ICESTORM_PLL:     1/    1   100%
Info:            SB_WARMBOOT:     0/    1     0%
Info:           ICESTORM_DSP:     0/    8     0%
Info:         ICESTORM_HFOSC:     0/    1     0%
Info:         ICESTORM_LFOSC:     0/    1     0%
Info:                 SB_I2C:     0/    2     0%
Info:                 SB_SPI:     0/    2     0%
Info:                 IO_I3C:     0/    2     0%
Info:            SB_LEDDA_IP:     0/    1     0%
Info:            SB_RGBA_DRV:     0/    1     0%
Info:         ICESTORM_SPRAM:     4/    4   100%
...
Info: [ 55530,  59533) |********+
Info: [ 59533,  63536) |************************************************+
Info: [ 63536,  67539) |******************************+
Info: [ 67539,  71542) |*************+
Info: [ 71542,  75545) |********************+
Info: [ 75545,  79548) |************************************************************
5 warnings, 0 errors
$ dfu-util -D build/gateware/top.bin
dfu-util 0.8
Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2014 Tormod Volden and Stefan Schmidt
This program is Free Software and has ABSOLUTELY NO WARRANTY
Please report bugs to dfu-util@lists.gnumonks.org

Invalid DFU suffix signature
A valid DFU suffix will be required in a future dfu-util release!!!
Cannot open DFU device 0b05:180a
Opening DFU capable USB device...
ID 1209:5bf0
Run-time device DFU version 0101
Claiming USB DFU Interface...
Setting Alternate Setting #0 ...
Determining device status: state = dfuIDLE, status = 0
dfuIDLE, continuing
DFU mode device DFU version 0101
Device returned transfer size 1024
Copying data from PC to DFU device
Download        [=========================] 100%       104090 bytes
Download done.
state(7) = dfuMANIFEST, status(0) = No error condition is present
state(8) = dfuMANIFEST-WAIT-RESET, status(0) = No error condition is present
Done!
$
```

Take a look at `test/csr.csv`.  This describes the various regions present in our design.  You can see `memory_region,sram,0x10000000,131072`, which indicates the RAM is 128 kilobytes long and is located at `0x10000000`, just as when we had a CPU.  You can also see the timer, which is a feature that comes as part of LiteX.  Let's try reading and writing RAM:

```sh
$ wishbone-tool 0x10000000
Value at 10000000: 0baf801e
$ wishbone-tool 0x10000000 0x98765432
$ wishbone-tool 0x10000000
Value at 10000000: 98765432
$ 
```

Aside from that, there's not much we can _do_ with this design.  But there's a lot of infrastructure there.  So let's add something.

![SB_RGBA_DRV](img/ice40-rgb.jpg "RGB block")

This is the RGB block from the datasheet.  It has five inputs: `CURREN`, `RGBLEDEN`, `RGB0PWM`, `RGB1PWM`, and `RGB2PWM`.  It has three outputs: `RGB0`, `RGB1`, and `RGB2`.  It also has four parameters: `CURRENT_MODE`, `RGB0_CURRENT`, `RGB1_CURRENT`, and `RGB2_CURRENT`.

This block is defined in Verilog, but we can very easily import it as a Module into Migen:

```python
class FomuRGB(Module, AutoCSR):
    def __init__(self, pads):
        self.output = CSRStorage(3)
        self.specials += Instance("SB_RGBA_DRV",
            i_CURREN = 0b1,
            i_RGBLEDEN = 0b1,
            i_RGB0PWM = self.output.storage[0],
            i_RGB1PWM = self.output.storage[1],
            i_RGB2PWM = self.output.storage[2],
            o_RGB0 = pads.r,
            o_RGB1 = pads.g,
            o_RGB2 = pads.b,
            p_CURRENT_MODE = "0b1",
            p_RGB0_CURRENT = "0b000011",
            p_RGB1_CURRENT = "0b000011",
            p_RGB2_CURRENT = "0b000011",
        )
```

This will instantiate this Verilog block and connect it up.  It also creates a `CSRStorage` object that is three bits wide, and assigns it to `output`.  Finally, it wires the pads up to the outputs of the block.

We can instantiate this block by simply creating a new object and adding it to `self.specials` in our design:

```python
...
        # Add the LED driver block
        led_pads = platform.request("rgb_led")
        self.submodules.rgb = FomuRGB(led_pads)
```

Finally, we need to add it to the `csr_map`.

Now, when we rebuild this design and check `test/csr.csv` we can see our new register:

```csv
csr_register,rgb_output,0xe0006800,1,rw
```

We can use `wishbone-tool` to write values to `0xe0006800` and see them take effect immediately.
