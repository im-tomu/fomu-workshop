Fomu as a CPU
-------------

The MicroPython interface is simply a RISC-V program. It interacts with
the RISC-V softcore inside Fomu by reading and writing memory directly.

The CPU in Fomu is built on LiteX, which places every device on a
Wishbone bus. This is a 32-bit internal bus that maps peripherals into
memory.

.. image:: _static/litex-design.png
   :width: 100%
   :alt: Fomu peripherals on the Wishbone bus

If you look at the diagram above, you can see that everything in the
system is on the Wishbone bus. The CPU is a bus master, and can initiate
reads and writes. The system’s RAM is on the wishbone bus, and is
currently located at address ``0x10000000``. The boot ROM is also on the
bus, and is located at ``0x00000000``. There is also SPI flash which is
memory-mapped, so when you load your program onto the SPI flash it shows
up on the Wishbone bus at offset ``0x20040000``.

The Configuration and Status Registers (CSRs) all show up at offset
``0xe0000000``. These are the registers we were accessing from Python.
Just like before, these special memory addresses correspond to control
values.

You’ll notice a “Bridge” in the diagram above. This is an optional
feature that we ship by default on Fomu. It bridges the Wishbone bus to
another device. In our case, it makes Wishbone available over USB.

.. image:: _static/wishbone-usb-debug-bridge.png
   :width: 100%
   :alt: Wishbone USB debug bridge interface

The above image shows the structure of a special USB packet we can
generate to access the Wishbone bus from a host PC. It lets us do two
things: Read a 32-bit value from Wishbone, or write a 32-bit value to
Wishbone. These two primitives give us complete control over Fomu.

Recall these definitions from earlier:

.. literalinclude:: ../riscv-blink/include/generated/csr.h
   :language: cpp
   :lines: 668,674,680,712

We can use the ``wishbone-tool`` program to read these values directly
out of Fomu:

.. session:: shell-session

   $ wishbone-tool 0xe0007000
   Value at e0007000: 00000002
   $ wishbone-tool 0xe0007004
   Value at e0007004: 00000000
   $ wishbone-tool 0xe0007008
   Value at e0007008: 00000003
   $

The three values correspond to the version number of the board at time
of writing: v2.0.3.

We can also read and write directly to memory. Recall that memory is
mapped to address ``0x10000000``. Let’s write a test value there and try
to read it back.

.. session:: shell-session

   $ wishbone-tool 0x10000000
   Value at 10000000: 00000005
   $ wishbone-tool 0x10000000 0x12345678
   $ wishbone-tool 0x10000000
   Value at 10000000: 0x12345678

We can see that the value got stored in memory, just like we thought it
would. The bridge is working, and we have access to Fomu over USB.

Interacting with the LED Directly
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Recall the LED block from Python. We used ``rgb.write_raw()`` to write
values to the LED block. Because of how the LED block is implemented, we
need to actually make two writes to the Wishbone bus in order to write
one value to the LED block. The first write sets the address, and the
second write sends the actual data.

The registers for the LED block are defined as:

.. code:: cpp

   #define CSR_RGB_DAT_ADDR 0xe0006800
   #define CSR_RGB_ADDR_ADDR 0xe0006804

Let’s change the red color to the maximum value. To do that, we’ll write
a ``1`` to the address register, and ``0xff`` to the data register:

.. session:: shell-session

   $ wishbone-tool 0xe0006804 1
   $ wishbone-tool 0xe0006800 0xff
   $

We can see that the LED immediately changed its behavior. Try playing
around with various values to see what combinations you can come up
with!

You can reset Fomu by writing a special value to the ``CSR_REBOOT_CTRL``
register at ``0xe0006000L``. All writes to this register must start with
``0xac``, to ensure random values aren’t written. We can reboot Fomu by
simply writing this value:

.. session:: shell-session

   $ wishbone-tool 0xe0006000 0xac
   INFO [wishbone_tool::usb_bridge] opened USB device device 007 on bus 001
   INFO [wishbone_tool::usb_bridge] waiting for target device
   ERROR [wishbone_tool] server error: BridgeError(USBError(Pipe))
   $

We can see that ``wishbone-tool`` has crashed with an error of
``USBError(Pipe)``, because the USB device went away as we were talking
to it. This is expected behavior. Fomu should be back to its normal
color and blink rate now.

Compiling RISC-V Code
~~~~~~~~~~~~~~~~~~~~~

Of course, Fomu’s softcore is a full CPU, so we can write C code for it.
Go to the ``riscv-blink/`` directory and run ``make``. This will
generate ``riscv-blink.dfu``, which we can load onto Fomu.

.. session:: shell-session

   $ make
     CC       ./src/main.c        main.o
     CC       ./src/rgb.c rgb.o
     CC       ./src/time.c        time.o
     AS       ./src/crt0-vexriscv.S       crt0-vexriscv.o
     LD       riscv-blink.elf
     OBJCOPY  riscv-blink.bin
     IHEX     riscv-blink.ihex
     DFU      riscv-blink.dfu
   $ dfu-util -D riscv-blink.dfu
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

This will load the binary onto Fomu and start it immediately. The LED
should be blinking quickly in a rainbow pattern. Congratulations! You’ve
compiled and loaded a RISC-V program onto a softcore.

Let’s modify the program by increasing the fade rate so much that it
appears solid. First, reboot Fomu by running
``wishbone-tool 0xe0006000 0xac``. Next, apply the following patch to
``src/main.c``:

.. code:: diff

   --- a/riscv-blink/src/main.c
   +++ b/riscv-blink/src/main.c
   @@ -46,6 +46,7 @@ int main(void) {
        usb_init();
        rgb_init();
        usb_connect();
   +    rgb_write((100000/64000)-1, LEDDBR);
        int i = 0;
        while (1) {
            color_wheel(i++);

What this does is increase the LED blink rate from 250 Hz to a much
higher value. Compile this and load it again with
``dfu-util -D riscv-blink.bin``. The blink rate should appear solid,
because it’s blinking too quickly to see.

Debugging RISC-V Code
~~~~~~~~~~~~~~~~~~~~~

Because we have ``peek`` and ``poke``, and because the USB bridge is a
bus master, we can actually halt (and reset!) the CPU over the USB
bridge. We can go even further and attach a full debugger to it!

To start with, run ``wishbone-tool -s gdb``:

.. session:: shell-session

   $ wishbone-tool -s gdb
   INFO [wishbone_tool::usb_bridge] opened USB device device 008 on bus 001
   INFO [wishbone_tool::server] accepting connections on 127.0.0.1:1234
   $

In a second window, run gdb on ``riscv-blink.elf``:

.. session:: shell-session

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

If we run ``bt`` we can get a backtrace, and chances are that we landed
in an ``msleep`` function:

.. code:: gdb

   (gdb) bt
   #0  0x2004014c in csr_readl (addr=3758106664) at ./include/hw/common.h:46
   #1  timer0_value_read () at ./include/generated/csr.h:242
   #2  0x200401dc in msleep (ms=ms@entry=80) at ./include/hw/common.h:41
   #3  0x20040074 in main () at ./src/main.c:45
   (gdb)

We can insert breakpoints, step, continue execution, and generally debug
the entire system. We can even reset the program by running
``mon reset``.


Using Rust
~~~~~~~~~~

As an alternative to C, the `Rust Language <https://www.rust-lang.org/>`_ can be used to write software for the Fomu softcore.
To install Rust, follow the instructions on https://rustup.rs/. After installing Rust, we can install support for RISCV 
targets using ``rustup``:

.. session:: shell-session

     $ rustup target add riscv32i-unknown-none-elf
     info: downloading component 'rust-std' for 'riscv32i-unknown-none-elf'
     4.5 MiB /   4.5 MiB (100 %)   2.1 MiB/s in  2s ETA:  0s
     info: installing component 'rust-std' for 'riscv32i-unknown-none-elf'

A Rust version of the C program used above is located in the ``riscv-rust-blink`` directory. Change into that directory, 
and build it using ``cargo``, the Rust package manager:

.. session:: shell-session
     
     $ cargo build --release
     Compiling semver-parser v0.7.0
     Compiling proc-macro2 v0.4.30
     Compiling unicode-xid v0.1.0
     Compiling rand_core v0.4.2
     Compiling vexriscv v0.0.1
     Compiling syn v0.15.44
     Compiling bit_field v0.9.0
     Compiling fomu-rt v0.0.3
     Compiling r0 v0.2.2
     Compiling vcell v0.1.2
     Compiling panic-halt v0.2.0
     Compiling rand_core v0.3.1
     Compiling semver v0.9.0
     Compiling rand v0.5.6
     Compiling rustc_version v0.2.3
     Compiling bare-metal v0.2.4
     Compiling quote v0.6.13
     Compiling fomu-pac v0.0.1
     Compiling riscv-rt-macros v0.1.6
     Compiling riscv-rust-blink v0.1.0 (/home/dominik/Coding/fomu-workshop/riscv-rust-blink)
     Finished release [optimized] target(s) in 29.39s

The resulting binary is located in the target subfolder: ``target/riscv32i-unknown-none-elf/release/riscv-rust-blink``. It can
be flashed using the ``flash.sh`` script, also located in the ``riscv-rust-blink`` folder:

.. session:: shell-session

     $ ./flash.sh
     dfu-suffix (dfu-util) 0.9

     Copyright 2011-2012 Stefan Schmidt, 2013-2014 Tormod Volden
     This program is Free Software and has ABSOLUTELY NO WARRANTY
     Please report bugs to http://sourceforge.net/p/dfu-util/tickets/
     
     Suffix successfully added to file
     dfu-util 0.9
     
     Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
     Copyright 2010-2019 Tormod Volden and Stefan Schmidt
     This program is Free Software and has ABSOLUTELY NO WARRANTY
     Please report bugs to http://sourceforge.net/p/dfu-util/tickets/
     
     Match vendor ID from file: 1209
     Match product ID from file: 70b1
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
     Download	[=========================] 100%         3012 bytes
     Download done.
     state(7) = dfuMANIFEST, status(0) = No error condition is present
     state(8) = dfuMANIFEST-WAIT-RESET, status(0) = No error condition is present
     Done!


Now the Fomu should blink in the same rainbow pattern as before.


.. warning::

     The Rust example currently does not support the USB functionality. After programming the example, we will not be able to
     acces the Fomu over USB anymore. To enable USB again, we have to reset the Fomu by removing it from the USB port and 
     plugging it in again.


Further RISC-V experiments
~~~~~~~~~~~~~~~~~~~~~~~~~~

The `TinyUSB <https://github.com/hathach/tinyusb>`__ USB stack supports Fomu. To get started with it, you might compile the mass storage example it provides. To do so, follow these steps:

* Clone the TinyUSB git repository: ``git clone https://github.com/hathach/tinyusb`` (you don't need to initialize the subrepositories)
* Change to ``tinyusb/examples/device/cdc_msc``
* Compile: ``make BOARD=fomu CROSS_COMPILE=riscv64-unknown-elf-``
* Load it onto the Fomu:  ``dfu-util -D _build/fomu/cdc_msc.bin``

Fomu should now appear as a USB storage device containing a README.
