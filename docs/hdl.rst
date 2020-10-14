.. _HDLs:

Hardware Description Languages
------------------------------

The two most common **H**\ ardware **D**\ escription **L**\ anguages are
Verilog and VHDL.

.. NOTE:: The pre-built toolchain we are releasing supports Verilog only.
  However, `GHDL <https://github.com/ghdl>`_ can be usable as a VHDL frontend
  for Yosys. See `ghdl-yosys-plugin <https://github.com/ghdl/ghdl-yosys-plugin>`_.

When writing HDL, a tool called ``yosys`` is used to convert the
human readable verilog into a netlist representation, this is called
*synthesis*. Once we have the netlist representation, a tool called
``nextpnr`` performs an operation called *place and route* (P&R) which
makes it something that will actually run on the FPGA. This is all
done for you using the ``Makefiles`` in the subdirectories of ``verilog``
or ``vhdl``.

A big feature of ``nextpnr`` over its predecessor, is the fact that
it is timing-driven. This means that a design will be generated with
a given clock domain guaranteed to perform fast enough.

When the ``make`` command runs ``nextpnr-ice40`` you will see something
similar included in the output:

::

   Info: Max frequency for clock 'clk': 73.26 MHz (PASS at 12.00 MHz)

This output example shows that we could run ``clk`` at up to 73.26
MHz and it would still be stable (even though we only requested 12.00
MHz). Note that there is some variation between designs depending on
how the placer and router decided to lay things out, so your exact
frequency numbers might be different from the ones shown in the code
blocks of this documentation.

Languages and generators
========================

.. toctree::

   verilog
   vhdl
   mixed-hdl
   migen
