.. _HDLs:mixed:

Mixed HDL on Fomu
-----------------

.. HINT:: It is strongly suggested to get familiar with :ref:`HDLs:Verilog` and :ref:`HDLs:VHDL` examples before
  tinkering with these mixed language use cases.


“Hello world!” - Blink a LED
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The canonical “Hello, world!” of hardware is to blink a LED.
The directory :repo:`hdl/mixed/blink <hdl/mixed/blink>` contains a VHDL + Verilog example of a blink project.
This takes the 48 MHz clock and divides it down by a large number so you get an on/off pattern.

Enter the :repo:`hdl/mixed/blink <hdl/mixed/blink>` directory and build the demo by using ``make``:

.. session:: shell-session

   $ make FOMU_REV=$FOMU_REV
   ...
   Info: Max frequency for clock 'clk_generator.clko': 73.26 MHz (PASS at 12.00 MHz)

   Info: Max delay posedge clk_generator.clko -> <async>: 3.15 ns

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

You can then load ``blink.dfu`` onto Fomu by using ``make load`` or the same ``dfu-util -D`` command we’ve been using so
far.
You should see a blinking pattern of varying color on your Fomu, indicating your bitstream was successfully loaded.

If you take a closer look at the sources in :repo:`hdl/mixed/blink <hdl/mixed/blink>`, you will find that
modules/components ``blink`` and ``clkgen`` are written both in VHDL and Verilog.
The :repo:`Makefile <hdl/mixed/blink/Makefile>` uses ``blink.vhd`` and ``clkgen.v`` by default.
However, any of the following cases produce the same result:

- ``blink.vhd`` + ``clkgen.v``
- ``blink.v`` + ``clkgen.vhdl``
- ``blink.vhd`` + ``clkgen.vhdl``
- ``blink.v`` + ``clkgen.v``

You can modify variables `VHDL_SYN_FILES` and ``VERILOG_SYN_FILES`` in the :repo:`Makefile <hdl/mixed/blink/Makefile>`
for trying other combinations.
For a better understanding, it is suggested to compare these modules with the single file solutions in
:ref:`HDLs:Verilog` and :ref:`HDLs:VHDL`.
