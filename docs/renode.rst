Working with LiteX and (co-)simulation with Renode
==================================================

LiteX used as the soft SoC on Fomu is a very robust and scalable soft
SoC platform, capable of running both bare metal binaries, Zephyr and
even Linux.

It is also supported in `Renode <https://renode.io>`__, which is an open
source simulation framework that lets you run unmodified software in a
fully controlled and inspectable environment. Renode is a functional
simulator, which means it aims to mimic the observable behavior of the
hardware instead of trying to be cycle-accurate.

We will now see how a full-blown Zephyr RTOS can be run on LiteX in
Renode, and then how this simulation can be interfaced with a Fomu for a
useful HW/SW co-development workflow.

   Note: Apart from RISC-V and LiteX platforms, Renode supports many
   other architectures and platforms, as described in the
   `documentation <https://renode.readthedocs.io/en/latest/introduction/supported-boards.html>`__,
   which also includes a user manual and a few tutorials. You can also
   take a look at a `Video Tutorials section on Renode’s
   website <https://renode.io/tutorials/>`__.

Keep in mind that all platforms and configurations in Renode used in
this tutorial are contained in text/config files - you can also explore
Renode’s usage patterns by just inspecting those files for details.

.. toctree::

   renode-starting
   renode-zephyr
   renode-bridge
   renode-verilator
