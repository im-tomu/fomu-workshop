Verilog on Fomu
---------------

“Hello world!” - Blink a LED
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The canonical “Hello, world!” of hardware is to blink a LED. The
directory ``verilog/blink`` contains a Verilog example of a blink
project. This takes the 48 MHz clock and divides it down by a large
number so you get an on/off pattern. It also exposes some of the signals
on the touchpads, making it possible to probe them with an oscilloscope.

Enter the ``verilog/blink`` directory and build the demo by using ``make``:

**Make sure you set the ``FOMU_REV`` value to match your hardware! See
the Required Hardware section.**

.. session:: shell-session

   $ make FOMU_REV=$FOMU_REV
   ...
   Info: Max frequency for clock 'clk': 73.26 MHz (PASS at 12.00 MHz)

   Info: Max delay posedge clk -> <async>: 3.15 ns

   Info: Slack histogram:
   Info:  legend: * represents 1 endpoint(s)
   Info:          + represents [1,1) endpoint(s)
   Info: [ 69683,  70208) |**
   Info: [ 70208,  70733) |
   Info: [ 70733,  71258) |**
   Info: [ 71258,  71783) |**
   Info: [ 71783,  72308) |**
   Info: [ 72308,  72833) |**
   Info: [ 72833,  73358) |
   Info: [ 73358,  73883) |**
   Info: [ 73883,  74408) |*
   Info: [ 74408,  74933) |**
   Info: [ 74933,  75458) |**
   Info: [ 75458,  75983) |*
   Info: [ 75983,  76508) |*
   Info: [ 76508,  77033) |**
   Info: [ 77033,  77558) |**
   Info: [ 77558,  78083) |*
   Info: [ 78083,  78608) |
   Info: [ 78608,  79133) |*************************
   Info: [ 79133,  79658) |**
   Info: [ 79658,  80183) |***
   22 warnings, 0 errors
   icepack blink.asc blink.bit
   cp blink.bit blink.dfu
   dfu-suffix -v 1209 -p 70b1 -a blink.dfu
   dfu-suffix (dfu-util) 0.9

   Copyright 2011-2012 Stefan Schmidt, 2013-2014 Tormod Volden
   This program is Free Software and has ABSOLUTELY NO WARRANTY
   Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

   Suffix successfully added to file
   $

You can then load ``blink.dfu`` onto Fomu by using the same ``dfu-util -D``
command we’ve been using so far. You should see a blinking pattern of
varying color on your Fomu, indicating your bitstream was successfully loaded.

   When writing HDL, a tool called ``yosys`` is used to convert the
   human readable verilog into a netlist representation, this is called
   synthesis. Once we have the netlist representation a tool called
   ``nextpnr`` performs an operation called “place and route” which
   makes it something that will actually run on the FPGA. This is all
   done for you using the ``Makefile`` in the ``verilog/blink``
   directory.

   A big feature of ``nextpnr`` over its predecessor, is the fact that
   it is timing-driven. This means that a design will be generated with
   a given clock domain guaranteed to perform fast enough.

   When the ``make`` command runs ``nextpnr-ice40`` you will see something
   similar included in the output:

   ::

      Info: Max frequency for clock 'clk': 73.26 MHz (PASS at 12.00 MHz)

   This output example shows that we could run ``clk`` at up to 73.26
   MHz and it would still be stable, even though we only requested 12.00
   MHz. Note that there is some variation between designs depending on
   how the placer and router decided to lay things out, so your exact
   frequency numbers might be different.

Reading Input
^^^^^^^^^^^^^

There is another small example in ``verilog/blink-expanded`` which shows
how to read out some given pins. Build and flash it like described above
and see if you can enable the blue and red LED by shorting pins 1+2 or 3+4
on your Fomu (the pins are the exposed contacts sticking out of the USB port).
