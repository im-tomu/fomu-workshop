Wishbone bridge between Renode and Fomu
=======================================

This part of the workshop is based on a `Renode, Fomu and Etherbone
bridge
example <https://renode.readthedocs.io/en/latest/tutorials/fomu-example.html>`__
from the Renode documentation.

Just like we can access Fomu peripherals using ``wishbone-tool``, we can
also connect to a physical board from Renode, mapping a part of the
memory space to be accessible via the Etherbone protocol.

This is a very useful capability as it enables us to potentially
simulate an advanced LiteX SoC system which would not normally fit in
the FPGA (or e.g. take a long time to synthesize), and interface it with
the remaining part of the physical system for I/O.

Setting up the server
^^^^^^^^^^^^^^^^^^^^^

You can use ``wishbone-tool`` to bridge protocols such as USB to Etherbone.
To start the server, run the following command:

.. session:: shell-session

   $ wishbone-tool -s wishbone
   INFO [wishbone_tool::bridge::usb] opened USB device device 006 on bus 001

This starts an Etherbone server on ``localhost:1234`` by default.  See
``wishbone-tool --help`` to change these settings.

Now you can start Renode and setup the platform.

Connecting from Renode
^^^^^^^^^^^^^^^^^^^^^^

Run ``renode`` and in the Monitor type:

::

   (monitor) include @scripts/complex/fomu/renode_etherbone_fomu.resc
   (machine-0) start
   Starting emulation...
   (machine-0) sysbus LogPeripheralAccess sysbus.led

You see a new window with a `shell
application <https://github.com/antmicro/zephyr/commit/29d8e51da15237f2a6bd2a3c8c97e004a66fc97a>`__,
that provides additional commands allowing you to control LEDs on Fomu.

.. code:: bash

   uart:~$ led_toggle
   uart:~$ led_breathe

The ``led_toggle`` command controls the LED by turning it on and off.
``led_breathe`` makes the LED fade slowly in and out, creating a
“breathe” effect.

The script you loaded configures Renode to log all communication with
Fomu. After issuing some commands in Zephyr’s shell you’ll see:

::

   01:00:31.8276 [DEBUG] led: [cpu: 0x40000988] WriteUInt32 to 0x8 (unknown), value 0x7.
   01:00:31.8279 [DEBUG] led: [cpu: 0x40000990] WriteUInt32 to 0x4 (unknown), value 0x8.
   01:00:31.8290 [DEBUG] led: [cpu: 0x40000998] WriteUInt32 to 0x0 (unknown), value 0xC8.
   01:00:31.8298 [DEBUG] led: [cpu: 0x400009A0] WriteUInt32 to 0x4 (unknown), value 0x9.
   01:00:31.8301 [DEBUG] led: [cpu: 0x400009A8] WriteUInt32 to 0x0 (unknown), value 0xBA.
   01:00:31.8305 [DEBUG] led: [cpu: 0x400009B0] WriteUInt32 to 0x8 (unknown), value 0x6.
   01:00:31.8308 [DEBUG] led: [cpu: 0x400009B4] WriteUInt32 to 0x8 (unknown), value 0x7.
   01:00:31.8311 [DEBUG] led: [cpu: 0x400009BC] WriteUInt32 to 0x4 (unknown), value 0x5.
   01:00:31.8314 [DEBUG] led: [cpu: 0x400009C0] WriteUInt32 to 0x0 (unknown), value 0x0.
   01:00:31.8317 [DEBUG] led: [cpu: 0x400009C4] WriteUInt32 to 0x4 (unknown), value 0x6.
   01:00:31.8321 [DEBUG] led: [cpu: 0x400009C8] WriteUInt32 to 0x0 (unknown), value 0x0.
   01:00:31.8324 [DEBUG] led: [cpu: 0x400009D0] WriteUInt32 to 0x4 (unknown), value 0x2.
   01:00:31.8327 [DEBUG] led: [cpu: 0x400009D4] WriteUInt32 to 0x0 (unknown), value 0x0.
   01:00:31.8331 [DEBUG] led: [cpu: 0x400009DC] WriteUInt32 to 0x4 (unknown), value 0x3.
   01:00:31.8334 [DEBUG] led: [cpu: 0x400009E0] WriteUInt32 to 0x0 (unknown), value 0x0.
   01:00:31.8337 [DEBUG] led: [cpu: 0x400009E8] WriteUInt32 to 0x4 (unknown), value 0x1.
   01:00:31.8341 [DEBUG] led: [cpu: 0x400009F4] WriteUInt32 to 0x0 (unknown), value 0xFF.
   01:00:31.8344 [DEBUG] led: [cpu: 0x40000A08] WriteUInt32 to 0x4 (unknown), value 0xA.
   01:00:31.8347 [DEBUG] led: [cpu: 0x40000A0C] WriteUInt32 to 0x0 (unknown), value 0x0.
   01:00:31.8350 [DEBUG] led: [cpu: 0x40000A14] WriteUInt32 to 0x4 (unknown), value 0xB.
   01:00:31.8353 [DEBUG] led: [cpu: 0x40000A18] WriteUInt32 to 0x0 (unknown), value 0xFF.

You can interact with Fomu manually, via the Monitor. To do that, you
first need to find the name of the peripheral that serves the connection
to Fomu.

Type in ``peripherals`` to see a list of all the elements of the
emulated SoC. Look for ``EtherBoneBridge`` entry:

::

   (machine-0) peripherals
   Available peripherals:
     sysbus (SystemBus)
     │
     ├── cpu (VexRiscv)
     │     Slot: 0
     │
     ├── ddr (MappedMemory)
     │     <0x40000000, 0x4FFFFFFF>
     │     <0xC0000000, 0xCFFFFFFF>
     │
     ├── eth (LiteX_Ethernet)
     │   │ <0x60007800, 0x600078FF>
     │   │ <0xE0007800, 0xE00078FF>
     │   │ <0x30000000, 0x30001FFF>
     │   │ <0xB0000000, 0xB0001FFF>
     │   │ <0x60007000, 0x600077FF>
     │   │ <0xE0007000, 0xE00077FF>
     │   │
     │   └── phy (EthernetPhysicalLayer)
     │         Address: 0
     │
     ├── flash_mem (MappedMemory)
     │     <0x20000000, 0x21FFFFFF>
     │     <0xA0000000, 0xA1FFFFFF>
     │
     ├── led (EtherBoneBridge)
     │     <0xE0006800, 0xE00068FF>
     │
     ├── mem (MappedMemory)
     │     <0x00000000, 0x0003FFFF>
     │     <0x80000000, 0x8003FFFF>
     │
     ├── spi (LiteX_SPI_Flash)
     │   │ <0x60005000, 0x6000500F>
     │   │ <0xE0005000, 0xE000500F>
     │   │
     │   └── flash (Micron_MT25Q)
     │
     ├── sram (MappedMemory)
     │     <0x10000000, 0x1003FFFF>
     │     <0x90000000, 0x9003FFFF>
     │
     ├── timer0 (LiteX_Timer)
     │     <0x60002800, 0x60002843>
     │     <0xE0002800, 0xE0002843>
     │
     └── uart (LiteX_UART)
           <0x60001800, 0x600018FF>
           <0xE0001800, 0xE00018FF>

The device that acts as a connector to Fomu is called ``led`` and is
registered at ``0xE0006800``:

::

     ├── led (EtherBoneBridge)
     │     <0xE0006800, 0xE00068FF>

You can either use a full or relative address (via the ``sysbus`` or
``led`` objects, respectively) to communicate with the physical LED
controller:

::

   (machine-0) sysbus WriteDoubleWord 0xE0006804 0x1234 # writes 0x1234 to the given address
   (machine-0) led WriteDoubleWord 0x4 0x4321 # writes 0x4321 to 0xE0006800 + 0x4

Note: the above values are just an example and won’t change the LED
status in any visible way. If you want to enable “breathe” effect
directly from the Monitor, see the necessary sequence in `the
application source
code <https://github.com/antmicro/zephyr/commit/29d8e51da15237f2a6bd2a3c8c97e004a66fc97a>`__.
