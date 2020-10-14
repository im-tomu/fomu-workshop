.. _HDLs:VHDL:

VHDL on Fomu
------------

.. HINT:: Component declarations for instantiating hard cores (such as the
  ones in ``sb_ice40_components.vhd``) are found in the installation of
  `iCEcube2 <http://www.latticesemi.com/iCEcube2>`_.


“Hello world!” - Blink a LED
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The canonical “Hello, world!” of hardware is to blink a LED. The
directory ``vhdl/blink`` contains a VHDL example of a blink
project. This takes the 48 MHz clock and divides it down by a large
number so you get an on/off pattern.

Enter the ``vhdl/blink`` directory and build the demo by using ``make``:

**Make sure you set the** ``FOMU_REV`` **value to match your hardware!** See :ref:`required-hardware`.

.. session:: shell-session

   $ make FOMU_REV=$FOMU_REV
   ...
   Info: Max frequency for clock 'clk': 70.39 MHz (PASS at 12.00 MHz)

   Info: Max delay posedge clk -> <async>: 3.15 ns

   Info: Slack histogram:
   Info:  legend: * represents 1 endpoint(s)
   Info:          + represents [1,1) endpoint(s)
   Info: [ 69127,  69680) |**
   Info: [ 69680,  70233) |**
   Info: [ 70233,  70786) |
   Info: [ 70786,  71339) |**
   Info: [ 71339,  71892) |**
   Info: [ 71892,  72445) |**
   Info: [ 72445,  72998) |**
   Info: [ 72998,  73551) |
   Info: [ 73551,  74104) |**
   Info: [ 74104,  74657) |**
   Info: [ 74657,  75210) |**
   Info: [ 75210,  75763) |**
   Info: [ 75763,  76316) |
   Info: [ 76316,  76869) |**
   Info: [ 76869,  77422) |**
   Info: [ 77422,  77975) |**
   Info: [ 77975,  78528) |
   Info: [ 78528,  79081) |***************************
   Info: [ 79081,  79634) |**
   Info: [ 79634,  80187) |***
   22 warnings, 0 errors
   docker run --rm -v //t/fomu/fomu-workshop/vhdl/blink/../..://src -w //src/vhdl/blink ghdl/synth:icestorm icepack blink.asc blink.bit
   cp blink.bit blink.dfu
   dfu-suffix -v 1209 -p 70b1 -a blink.dfu
   dfu-suffix (dfu-util) 0.9

   Copyright 2011-2012 Stefan Schmidt, 2013-2014 Tormod Volden
   This program is Free Software and has ABSOLUTELY NO WARRANTY
   Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

   Suffix successfully added to file
   $

You can then load ``blink.dfu`` onto Fomu by using ``make load`` or the same
``dfu-util -D`` command we’ve been using so far. You should see a blinking pattern of
varying color on your Fomu, indicating your bitstream was successfully loaded.
