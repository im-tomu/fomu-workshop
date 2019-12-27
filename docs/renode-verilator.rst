Renode Co-simulation using Verilator
====================================

While connecting Renode to a real FPGA gives you some interesting
possibilities in testing and debugging your gateware together with your
software, there is another usage scenario which is completely hardware
independent - connecting functional simulation of the base system in
Renode with HDL simulation of a part of the system that is under
development.

To this end, Renode provides an integration layer for Verilator. A
typical setup with Renode + Verilator consists of several components:

-  the ‘verilated’ HDL code itself (e.g. a UART peripheral),
-  Verilator integration library, `provided as a plugin to
   Renode <https://github.com/renode/renode/tree/master/src/Plugins/VerilatorPlugin/VerilatorIntegrationLibrary/src>`__,
-  shim layer in C++ connecting the above.

Currently Renode supports peripherals with the AXILite interface. Keep
in mind that due to the abstract nature of bus operations in Renode, it
doesn’t matter what kind of bus is used on the hardware you want to
simulate.

In the Renode tree you will find an example with all the elements
already prepared. To run it, start Renode and type:

::

   (monitor) include @scripts/single-node/riscv_verilated_uartlite.resc
   (UARTLite) start

This script loads a RISC-V-based system with a verilated UARTLite. You
can verify it by calling:

::

   (UARTLite) sysbus WhatPeripheralIsAt 0x70000000
   Antmicro.Renode.Peripherals.Verilated.VerilatedUART

To inspect the communication with the UART, run:

::

   (UARTLite) sysbus LogPeripheralAccess uart

You will see every read and write to the peripheral displayed in the
Renode log.

Please note that, despite not being a Renode-native model, the UART is
also capable of displaying an analyzer window. This is because Renode
adds a special support for UART-type peripherals, allowing you not only
to connect bus lines, but also the TX and RX UART lines, to the Renode
infrastructure.

The HDL and integration layer for this UART peripheral is available on
`Antmicro’s
GitHub <https://github.com/antmicro/renode-verilator-integration/tree/master/samples/uartlite>`__.

To compile it manually, you need to have ``ZeroMQ`` (``libzmq3-dev`` on
Debian-like systems) and ``Verilator`` installed in your system. You
also need to provide a full path to the
``src/Plugins/VerilatorPlugin/VerilatorIntegrationLibrary`` directory as
the ``INTEGRATION_DIR`` environment variable. This means that you need
to have a copy of Renode sources to build a verilated peripheral.

With this set up, simply run ``make``.

Integration with verilated code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Renode supports integration with Verilator via AXILite bus, but can be
easily expanded to support other standards as well.

We’ll briefly take a look on the integration layer implemented in
`sim-main.cpp <https://github.com/antmicro/renode-verilator-integration/blob/master/samples/uartlite/sim_main.cpp>`__.

First, the user has to decide on the bus type and peripheral type. These
are provided by the integration library:

.. code:: c

   #include "src/peripherals/uart.h"
   #include "src/buses/axilite.h"

A bus is a type declaring all the signals and how should they be handled
on each transaction. These signals have to be connected to the signals
in the HDL design:

::

   void Init() {
       AxiLite* bus = new AxiLite();

       //=================================================
       // Init bus signals
       //=================================================
       bus->clk = &top->clk;
       bus->rst = &top->rst;
       bus->awaddr = (unsigned long *)&top->awaddr;
       bus->awvalid = &top->awvalid;
       bus->awready = &top->awready;
       bus->wdata = (unsigned long *)&top->wdata;
       bus->wstrb = &top->wstrb;
       bus->wvalid = &top->wvalid;
       bus->wready = &top->wready;
       bus->bresp = &top->bresp;
       bus->bvalid = &top->bvalid;
       bus->bready = &top->bready;
       [...]

To handle the “external” communication, the user can either use the base
``RenodeAgent`` class of one of its derivatives: for example the
``UART`` type allows you to connect RX and TX signals:

::

       // Init peripheral
       //=================================================
       uart = new UART(bus, &top->txd, &top->rxd, prescaler);

For more details, see the `verilated uartlite
repository <https://github.com/antmicro/renode-verilator-integration/tree/master/samples/uartlite>`__.

