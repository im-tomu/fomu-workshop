Getting Renode
==============

Renode is available for Linux, macOS and Windows.

On Linux and macOS, you need to have
`Mono <https://www.mono-project.com>`__ installed on your computer. You
should follow the `Mono installation
instructions <https://www.mono-project.com/download/stable/>`__ and
install the ``mono-complete`` package.

On Windows it’s enough to have a fairly recent `.NET
Framework <https://dotnet.microsoft.com/download/dotnet-framework>`__
installed.

Then you can either install Renode from `prebuilt
packages <https://github.com/renode/renode#installation>`__, or `compile
it
yourself <https://renode.readthedocs.io/en/latest/advanced/building_from_sources.html>`__.

Try out Renode quickly with precompiled LiteX demos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Renode comes with several precompiled demos, which can be used to verify
everything works for you before starting to compile and use your own
software binaries.

There are three demo scripts available:

-  ``litex_vexriscv_micropython.resc``
-  ``litex_vexriscv_zephyr.resc``
-  ``litex_vexriscv_linux.resc``

To run them, start Renode using the ``renode`` command (or ``./renode``
if you built from sources).

You will see a terminal window pop up, which is the Renode CLI, called
the Monitor.

In the Monitor type:

::

   (monitor) start @scripts/single-node/<script_name>

(where is one of the above).

Voila! A UART analyzer window should appear and you should see LiteX
booting the respective binary.
