Verilog on Fomu
---------------

“Hello world!” - Blink an LED
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The canonical “Hello, world!” of hardware is to blink an LED. The
directory ``verilog-blink`` contains a Verilog example of a blink
project. This takes the 48 MHz clock and divides it down by a large
number so you get an on/off pattern. It also exposes some of the signals
on the touchpads, making it possible to probe them with an oscilloscope.

Enter the ``verilog-blink`` directory and build the ``verilog-blink``
demo by using ``make``:

**Make sure you set the ``FOMU_REV`` value to match your hardware! See
the Required Hardware section.**

.. session::

   $ make FOMU_REV=$FOMU_REV
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
   Built 'blink' for Fomu XXXXX
   $

You can load ``blink.bin`` onto Fomu by using the same ``dfu-util -D``
command we’ve been using. The LED should begin blinking on and off
regularly, indicating your bitstream was successfully loaded.

   When writing HDL, a tool called ``yosys`` is used to convert the
   human readable verilog into a netlist representation, this is called
   synthesis. Once we have the netlist representation a tool called
   ``nextpnr`` performs an operation called “place and route” which
   makes it something that will actually run on the FPGA. This is all
   done for you using the ``Makefile`` in the ``verilog-blink``
   directory.

   A big feature of ``nextpnr`` over its predecessor, is the fact that
   it is timing-driven. This means that a design will be generated with
   a given clock domain guaranteed to perform fast enough.

   When the ``make`` command runs ``nextpnr-ice40`` you will see the
   following included in the output;

   ::

      Max frequency for clock 'clk12':   24.63 MHz (PASS at 12.00 MHz)
      Max frequency for clock 'clk48_1': 60.66 MHz (PASS at 48.00 MHz)
      Max frequency for clock 'clkraw': 228.05 MHz (PASS at 48.00 MHz)

   This output example above shows we could run ``clk12`` at up to 24.63
   MHz and it would still be stable, even though we only requested 12.00
   MHz. Note that there is some variation between designs depending on
   how the placer and router decided to lay things out, so your exact
   frequency numbers might be different.
