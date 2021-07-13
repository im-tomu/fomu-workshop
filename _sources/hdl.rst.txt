.. _HDLs:

Hardware Description Languages
------------------------------

The two most common **H**\ ardware **D**\ escription **L**\ anguages are Verilog and VHDL.
As explained in :ref:`background:code-into-gates`, a *synthesis* tool is used for converting
the human readable HDL into a netlist representation. The synthesis tool used in the Fomu
toolchain is called ``yosys``. Once we have the netlist representation, a tool called
``nextpnr`` performs an operation called *place and route* (PnR), which makes it something
that will actually run on the FPGA. This is all done for you using the ``Makefiles`` in the
subdirectories of any of the following examples: :repo:`verilog <verilog>`,
:repo:`vhdl <vhdl>`, :repo:`mixed-hdl <mixed-hdl>`, or :repo:`migen <migen>`.

.. NOTE::
   ``nextpnr`` is timing-driven. This means that a design will be generated with a given
   clock domain guaranteed to perform fast enough, but sometimes it won't optimise further.
   When the ``make`` command runs ``nextpnr-ice40`` you will see something similar to the
   following:

   ::

      Info: Max frequency for clock 'clk': 73.26 MHz (PASS at 12.00 MHz)

   This output example shows that we could run ``clk`` at up to 73.26
   MHz and it would still be stable (even though we only requested 12.00
   MHz). Note that there is some variation between designs depending on
   how the placer and router decided to lay things out, so your exact
   frequency numbers might be different from the ones shown in the code
   blocks of this documentation.

.. IMPORTANT::
   As explained in :ref:`background:about-fomu`, Fomu implements its USB in a softcore, and
   the bitstream that runs on the FPGA must provide the ability to communicate over USB.
   That is a tradeoff for achieving such a tiny board size, which unfortunately makes
   it not straightforward to use non-trivial HDL designs. This is because
   I/O is very limited, hence, it is challenging to actually *see* whether the designs are
   behaving as expected. Ideally, a USB-to-UART core would be provided for users to instantiate
   in their HDL designs. Should you be interested in helping achieve it, `let us know! <https://github.com/im-tomu/fomu-workshop/issues/new>`_
   Meanwhile, :ref:`HDLs:migen` examples provide a working SoC that allows interacting
   through USB using a Wishbone Bus.

.. figure:: _static/ice40-rgb.png
   :align: center
   :width: 600px
   :alt: iCE40 UltraLite and iCE40 UltraPlus RGB Port Level Diagram

   iCE40 UltraLite and iCE40 UltraPlus RGB Port Level Diagram.

Regardless of the HDL language or higher abstraction programming language used for
describing the design, all the examples in this workshop do use the *hard* RGB block
for driving the LED on the board. It is defined as a Verilog module or VHDL component
named ``SB_RGBA_DRV``.
As shown in the block diagram from the datasheet, the RGB driver has five inputs
(``CURREN``, ``RGBLEDEN``, ``RGB0PWM``, ``RGB1PWM``, and ``RGB2PWM``),
and three outputs (``RGB0``, ``RGB1``, and ``RGB2``). It also has four parameters:
``CURRENT_MODE``, ``RGB0_CURRENT``, ``RGB1_CURRENT``, and ``RGB2_CURRENT``. As a result,
it allows driving the LEDs safely, by specifying the current limit for each of them.
More information on this driver can be found in the `ICE40 LED Driver Usage Guide <_static/reference/FPGA-TN-1288-ICE40LEDDriverUsageGuide.pdf>`_.

.. ATTENTION::
   Even though it is possible to drive the RGB outputs directly (i.e. without instantiating
   ``SB_RGBA_DRV``), it is strongly discouraged, as it might damage the LEDs.

Languages and generators
========================

.. toctree::

   verilog
   vhdl
   mixed-hdl
   migen
   icestudio
