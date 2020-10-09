Fomu on IceStudio *Nightly*
---------------------------

.. IMPORTANT:: Fomu is currently not supported in the stable releases
  of IceStudio. Development or `nightly <https://github.com/juanmard/icestudio/releases/tag/nightly>`_
  releases need to be used. Moreover, Apio needs to be updated from
  the git repository.

  NOTE: on GNU/Linux, first ``source ~/.icestudio/venv/bin/activate``.

  .. code-block:: shell

      pip install -U git+https://github.com/FPGAwars/apio.git@develop#egg=apio

“Hello world!” - Blink a LED
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The canonical “Hello, world!” of hardware is to blink a LED. The
directory ``icestudio`` contains a Blinky example in ICE format.
Moreover, ``Blinky_BoardTop.ice`` wraps Blinky, showcasing how
to use the Design Under Test (DUT) as a black box.

Open ``Blinky_BoardTop.ice`` from `Icestudio <https://juanmard.github.io/icestudio/>`_
and use the buttons on the botton:

.. image:: _static/icestudio/blinky_steps.png
   :width: 600 px
   :align: center
   :target: https://github.com/juanmard/icestudio

0. Check that the **selected board** is the Fomu.

   - Click on the button with a 'microchip' icon, and a modal window will open.
   - There, select the device (UP5K) in the first dropdown list and the board (Fomu) in the second list.


1. Click on the **Verify** button for checking the design.
2. Click on the **Build** button for having the design exported to Verilog, synthesised, placed, routed and, finally, the bitstream generated.
3. Click on the **Upload** for sending the bitstream to the board.
4. After each of the steps is executed, the corresponding log can be shown through button **View command output**.

You should see the rainbow pattern in the Fomu as soon as the *Upload*
step is finished. However, that's just the beginning of the trip. You
can navigate the hierarchy of the designs by double-clicking on the main
block. Go as deep as you want, until you find raw Verilog code. As you
can observe, ICE modules are fancy wrappers around the Verilog code from
``verilog/blink``.

Editing submodules is blocked by default, but you can unlock the feature
with the red button on the botton left. Do the modifications you wish,
then save the changes and go back to the top. There is a 'Home' button
on the bottom left for jumping to the root of the design straightaway.
From the top, you can verify, build and upload the design again.

Find more info about features of IceStudio (such as collections or
plugins) in the `documentation <https://juanmard.github.io/icestudio/index.html>`_.
