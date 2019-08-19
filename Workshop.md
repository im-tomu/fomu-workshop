# Fomu Workshop

![Hi, I'm Fomu!](img/fomu.png "Fomu logo")

Hi, I'm Fomu!  This workshop covers the basics of Fomu in a top-down approach.  We'll start out by learning what Fomu is, how to load software into Fomu, and finally how to write software for Fomu.

FPGAs are complex, weird things, so we'll take a gentle approach and start out by treating it like a Python interpreter first, and gradually peel away layers until we're writing our own hardware registers.  You can take a break at any time and explore!  Stop when you feel the concepts are too unfamiliar, or plough on and dig deep into the world of hardware.

## Required Software

Fomu requires specialized software.  Namely, you must have the following software on your system:

| Tool | Purpose |
| ---- |------------------ |
| **yosys** | Verilog synthesis |
| **nextpnr-ice40** | FPGA place-and-route |
| **icestorm** | FPGA bitstream packing |
| **riscv toolchain** | Compile code for a RISC-V softcore |
| **dfu-util** | Load a bitstream or code onto Fomu |
| **python3** | Convert Migen/Litex code to Verilog |
| **wishbone-tool** | Interact with Fomu over USB |
| **serial console** | Interact with Python over a virtual console |

This software is provided on a USB drive for Linux x86/64, macOS, and Windows.  Debian packages are also available for Raspberry Pi.  For other platforms, please see the people running the workshop.

This software is also available from the [Fomu Toolchain repository](github.com/im-tomu/fomu-toolchain/releases/latest).

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
Download        [======                   ]  24%        32768 bytes
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

## RISC-V

The MicroPython interface is simply a RISC-V program.