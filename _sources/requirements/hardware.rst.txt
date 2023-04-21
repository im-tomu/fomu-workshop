.. _required-hardware:

Required Hardware
#################

- For this workshop, you will need a `Fomu board <https://github.com/im-tomu/fomu-hardware>`_.
- Aside from that, you need a computer with a USB port that can run the :ref:`required-software`.

.. NOTE::
  You should not need any special drivers, though on Linux you may need ``sudo``
  access, or special ``udev`` rules for granting permission to use the USB device from a
  non-privileged account.

.. ATTENTION::
  This workshop may be competed with any model of Fomu, though there are some
  parts that require you to identify which model you have. See the
  :ref:`which-fomu` below.

.. _which-fomu:

Which Fomu do I have?
=====================

+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
|                  | Hacker                                                               | Production                                                        |
+==================+======================================================================+===================================================================+
| **String**       | hacker                                                               | pvt                                                               |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Bash Command** | ``export FOMU_REV=hacker``                                           | ``export FOMU_REV=pvt``                                           |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Front**        | |Hacker Hardware Front without case|                                 | |Production Hardware Front without case|                          |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Back**         | |Hacker Hardware Back without case|                                  | |Production Hardware Back without case|                           |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **In Case**      | |Hacker Hardware Back with case|                                     | |Production Hardware Back with case|                              |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Parts**        | |Hacker Hardware Annotated Diagram|                                  | |Production Hardware Annotated Diagram|                           |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Color**        | |Dark Blue|                                                          | |Cyan Light Blue|                                                 |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Bootloader**   | Fomu **Hacker** running DFU Bootloader vX.X.X                        | Fomu **PVT** running DFU Bootloader vX.X.X                        |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Description**  | These are the original design and cut corners to make it easier to   | If you ordered a Fomu from Crowd Supply, this is the model you'll |
|                  | manufacture. If you received one directly from Tim before 36C3, you  | receive. It is small, and fits in a USB port. There is no         |
|                  | probably have one of these. Hacker boards have white silkscreen on   | silkscreen on it. This model of Fomu has a large silver crystal   |
|                  | the back.                                                            | oscillator that is the tallest component on the board.            |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Schematic**    | `schematic-hacker.pdf <../_static/reference/schematic-hacker.pdf>`__ | `schematic-pvt.pdf <../_static/reference/schematic-pvt.pdf>`__    |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Received at**  | From Tim at 35C3, CCCamp19, HackADay Supercon 2019                   | At RISC-V Summit 2019, 36C3, Crowdsupply, Mouser                  |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+
| **Buy more**     | End of Life                                                          | `CrowdSupply <https://j.mp/fomu-cs>`__,                           |
+------------------+----------------------------------------------------------------------+-------------------------------------------------------------------+

.. |Dark Blue| raw:: html

    <span style="background-color: #051b70; color: white;">dark blue</span>

.. |Cyan Light Blue| raw:: html

    <span style="background-color: #03b1c4;">cyan / light blue</span>

.. |Hacker Hardware Front without case| image:: ../_static/hw-hacker-front-bare-small.jpg
.. |Production Hardware Front without case| image:: ../_static/hw-pvt-front-bare-small.jpg
.. |Hacker Hardware Back without case| image:: ../_static/hw-hacker-back-bare-small.jpg
.. |Production Hardware Back without case| image:: ../_static/hw-pvt-back-bare-small.jpg
.. |Hacker Hardware Back with case| image:: ../_static/hw-hacker-back-case-small.jpg
.. |Production Hardware Back with case| image:: ../_static/hw-pvt-back-case-small.jpg
.. |Hacker Hardware Annotated Diagram| image:: ../_static/hw-hacker-annotated.png
.. |Production Hardware Annotated Diagram| image:: ../_static/hw-pvt-annotated.png


.. note::

   There are also Fomu EVT boards which were shipped to early backers of
   the Fomu crowd funding campaign. This model of Fomu is about the size
   of a credit card. It should have the text “Fomu EVT3” written across
   it in white silkscreen. If you have a different EVT board such as
   EVT2 or EVT1, they should also work.
