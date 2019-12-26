Requirements
------------

Required Hardware
~~~~~~~~~~~~~~~~~

For this workshop, you will need a Fomu board. This workshop may be
competed with any model of Fomu, though there are some parts that
require you to identify which model you have:

+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
|                   | Hacker                                                                  | Production                                                        |
+===================+=========================================================================+===================================================================+
| **String**        | hacker                                                                  | pvt                                                               |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Bash Command**  | ``export FOMU_REV=hacker``                                              | ``export FOMU_REV=pvt``                                           |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Front**         | |Hacker Hardware Front without case|                                    | |Production Hardware Front without case|                          |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Back**          | |Hacker Hardware Back without case|                                     | |Production Hardware Back without case|                           |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **In Case**       | |Hacker Hardware Back with case|                                        | |Production Hardware Back with case|                              |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Parts**         | |Hacker Hardware Annotated Diagram|                                     | |Production Hardware Annotated Diagram|                           |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Color**         | |Dark Blue|                                                             | |Cyan Light Blue|                                                 |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Bootloader**    | Fomu **Hacker** running DFU Bootloader vX.X.X                           | Fomu **PVT** running DFU Bootloader vX.X.X                        |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Description**   | These are the original design and cut corners to make it easier to      | If you ordered a Fomu from Crowd Supply, this is the model you'll |
|                   | manufacture. If you received one directly from Tim before 36C3, you     | receive. It is small, and fits in a USB port. There is no         |
|                   | probably have one of these. Hacker boards have white silkscreen on      | silkscreen on it. This model of Fomu has a large silver crystal   |
|                   | the back.                                                               | oscillator that is the tallest component on the board.            |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Received at**   | From Tim at 35C3, CCCamp19, HackADay Supercon 2019                      | At RISC-V Summit 2019, 36C3, Crowdsupply, Mouser                  |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+
| **Buy more**      | End of Life                                                             | `CrowdSupply <https://j.mp/fomu-cs>`__,                           |
+-------------------+-------------------------------------------------------------------------+-------------------------------------------------------------------+

.. |Dark Blue| raw:: html

    <span style="background-color: #051b70; color: white;">dark blue</span>

.. |Cyan Light Blue| raw:: html

    <span style="background-color: #03b1c4;">cyan / light blue</span>

.. |Hacker Hardware Front without case| image:: ../img/hw-hacker-front-bare-small.jpg
.. |Production Hardware Front without case| image:: ../img/hw-pvt-front-bare-small.jpg
.. |Hacker Hardware Back without case| image:: ../img/hw-hacker-back-bare-small.jpg
.. |Production Hardware Back without case| image:: ../img/hw-pvt-back-bare-small.jpg
.. |Hacker Hardware Back with case| image:: ../img/hw-hacker-back-case-small.jpg
.. |Production Hardware Back with case| image:: ../img/hw-pvt-back-case-small.jpg
.. |Hacker Hardware Annotated Diagram| image:: ../img/hw-hacker-annotated.png
.. |Production Hardware Annotated Diagram| image:: ../img/hw-pvt-annotated.png

Your Fomu should be running Foboot v1.8.7 or newer. You can see what
version you are running by typing ``dfu-util -l`` and noting the version
number.

Aside from that, you need a computer with a USB port that can run the
toolchain software. You should not need any special drivers, though on
Linux you may need sudo access, or special udev rules to grant
permission to use the USB device from a non-privileged account.

.. note::

   There are also Fomu EVT boards which were shipped to early backers of
   the Fomu crowd funding campaign. This model of Fomu is about the size
   of a credit card. It should have the text “Fomu EVT3” written across
   it in white silkscreen. If you have a different EVT board such as
   EVT2 or EVT1, they should work also.

Required Files
~~~~~~~~~~~~~~

You will need the Workshop files. They are located in the
`fomu-workshop <https://github.com/im-tomu/fomu-workshop>`__ Github
repository. You can download
`master.zip <https://github.com/im-tomu/fomu-workshop/archive/master.zip>`__
or clone it from git:

.. prompt:: bash $

   git clone --recurse-submodules https://github.com/im-tomu/fomu-workshop.git

If you’re attending a workshop that provides USB drives, these files may
be available on the USB drive under the ``Workshop`` directory.

Required Software
~~~~~~~~~~~~~~~~~

Fomu requires specialized software. This software is provided for Linux
x86/64, macOS, and Windows, via `Fomu
Toolchain <https://github.com/im-tomu/fomu-toolchain/releases/latest>`__.

Debian packages are also `available for Raspberry
Pi <https://github.com/im-tomu/fomu-raspbian-packages>`__.

If you’re taking this workshop as a class, the toolchains are provided
on the USB disk.

To install the software, extract it somewhere on your computer, then
open up a terminal window and add that directory to your PATH:

.. tabs::

   .. group-tab:: MacOS X

      .. prompt:: bash $

         export PATH=[path-to-toolchain]/bin:$PATH

   .. group-tab:: Linux

      .. prompt:: bash $

         export PATH=[path-to-toolchain]/bin:$PATH

   .. group-tab:: Windows

      .. prompt:: text >

         $ENV:PATH = "[path-to-toolchain]\bin;" + $ENV:PATH

      .. prompt:: text >

         PATH=[path-to-toolchain]\bin;%PATH%


To confirm installation, run the ``yosys`` command and confirm you get
the following output;

.. code:: sh

   $ yosys

    /----------------------------------------------------------------------------\
    |                                                                            |
    |  yosys -- Yosys Open SYnthesis Suite                                       |
    |                                                                            |
    |  Copyright (C) 2012 - 2018  Clifford Wolf <clifford@clifford.at>           |
    |                                                                            |
    |  Permission to use, copy, modify, and/or distribute this software for any  |
    |  purpose with or without fee is hereby granted, provided that the above    |
    |  copyright notice and this permission notice appear in all copies.         |
    |                                                                            |
    |  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES  |
    |  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF          |
    |  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR   |
    |  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    |
    |  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN     |
    |  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF   |
    |  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.            |
    |                                                                            |
    \----------------------------------------------------------------------------/

    Yosys 78b30bbb1102047585d1a2eac89b1c7f5ca7344e (Fomu build) (git sha1 41d9173, gcc 5.5.0-12ubuntu1~14.04 -fPIC -Os)


   yosys>

Ensure it says **(Fomu build)**. Type ``exit`` to quit ``yosys``.

.. note::

   The `Fomu Toolchain <https://github.com/im-tomu/fomu-toolchain/releases/latest>`__
   consists of the following tools;

   ============================================================= =============================================
   Tool                                                          Purpose
   ============================================================= =============================================
   `yosys <https://github.com/YosysHQ/yosys>`__                  Verilog synthesis
   `nextpnr-ice40 <https://github.com/YosysHQ/nextpnr>`__        FPGA place-and-route
   `icestorm <https://github.com/cliffordwolf/icestorm>`__       FPGA bitstream packing
   `riscv toolchain <https://www.sifive.com/boards/>`__          Compile code for a RISC-V softcore
   `dfu-util <https://dfu-util.sourceforge.net/>`__              Load a bitstream or code onto Fomu
   `python <https://python.org/>`__                              Convert Migen/Litex code to Verilog
   `wishbone-tool <https://github.com/xobs/wishbone-utils/>`__   Interact with Fomu over USB
   **serial console**                                            Interact with Python over a virtual console
   ============================================================= =============================================
