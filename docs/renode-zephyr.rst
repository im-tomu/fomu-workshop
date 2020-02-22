Running your own Zephyr binary on LiteX/VexRiscv in Renode
==========================================================

Zephyr is a very capable RTOS governed by a Linux Foundation subproject.
It is very well supported on the RISC-V architecture, as well as in
LiteX.

Building a Zephyr application
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To install all the dependencies and prepare the environment for building
the Zephyr application follow the official `Zephyr Getting Started
Guide <https://docs.zephyrproject.org/latest/getting_started/index.html>`__
up to point 4. On Linux you can follow the instructions from the point 5
on installing the Software Development Toolchain. The python version
in the FOMU toolchain may not work; remove it from your PATH before
attempting to build zephyr.
For other operating
systems, if you followed the instructions from the ``Required Software``
section of this tutorial, you should have a toolchain in ``PATH``.

On macOS and Windows you also need to set some additional variables.

For macOS:

.. session:: shell-session

   $ export ZEPHYR_TOOLCHAIN_VARIANT=cross-compile
   $ export CROSS_COMPILE=riscv64-unknown-elf-

For Windows:

::

   set ZEPHYR_TOOLCHAIN_VARIANT=cross-compile
   set CROSS_COMPILE=riscv64-unknown-elf-

To build the ``shell`` demo application for the LiteX/VexRiscv board run
the following commands on Linux and macOS:

.. session:: shell-session

   $ cd ~/zephyrproject/zephyr
   $ source zephyr-env.sh
   $ west build -p auto -b litex_vexriscv samples/subsys/shell/shell_module/

And on Windows:

::

   cd %HOMEPATH%\zephyrproject\zephyr
   zephyr-env.cmd
   west build -p auto -b litex_vexriscv samples\subsys\shell\shell_module\

The resulting ELF file will be in ``build/zephyr/zephyr.elf``.

Run the app in Renode
^^^^^^^^^^^^^^^^^^^^^

To run the app you just compiled, you basically need to replace the
precomipled demo binary with the one you want, by setting the ``zephyr``
variable - see below.

Just like before, start Renode using the ``renode`` command (or
``./renode`` if you built from sources).

You will see the Monitor, where you should type:

::

   (monitor) $zephyr=@~/zephyrproject/zephyr/build/zephyr/zephyr.elf
   (monitor) start @scripts/single-node/litex_vexriscv_zephyr.resc

You should see a new window pop up for the serial port. In it, you
should see the Zephyr interactive shell.

Debugging the app in Renode
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In general, debugging in Renode is done with GDB just like with a
physical board - you connect to a debug port and execute GDB commands as
usual. For details, see the `Renode debugging
documentation <https://renode.readthedocs.io/en/latest/debugging/gdb.html>`__.
