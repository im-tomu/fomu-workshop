.. _required-drivers:

Required Drivers
================

On most systems (such as Windows 10 or newer, or MacOS X), the Fomu board does **not** need any special drivers.

* On GNU/Linux, you do not need to install any drivers, **however**, you may need
  ``sudo`` access unless you :ref:`linux-udev` to grant permission for using the
  USB device from a non-privileged account.
* Windows systems **earlier** than Windows 10: you will need to
  :ref:`install Zadig drivers <windows-zadig>`.

.. _linux-udev:

Setup udev rules
----------------

.. WARNING::
   This set up is for GNU/Linux **only**. Setting up these udev rules grants
   permissions for using the USB device from a non-privileged account.

On GNU/Linux, try running ``dfu-util -l``. If you get an error message like the
following, you should add a ``udev`` rule as to give your user permission to the
USB device.

.. session:: shell-session
   :emphasize-lines: 9

   $ dfu-util -l
   dfu-util 0.9

   Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
   Copyright 2010-2016 Tormod Volden and Stefan Schmidt
   This program is Free Software and has ABSOLUTELY NO WARRANTY
   Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

   dfu-util: Cannot open DFU device 1209:5bf0
   $

Steps to set up udev rule
#########################

#. Add your user to group ``plugdev``:

   .. session:: shell-session

      $ sudo groupadd plugdev
      $ sudo usermod -a -G plugdev $USER

   .. WARNING::
      You **must** log out and then log in again for the addition to group ``plugdev`` to take affect.

#. Use ``id $USER`` and/or ``groups`` to check you are in group ``plugdev``:

   .. session:: shell-session

      $ id $USER
      uid=1000(tim) gid=1000(tim) groups=500(plugdev),997(admin)

      $ groups | grep plugdev
      tim plugdev admin

#. Create a file named ``/etc/udev/rules.d/99-fomu.rules`` and add the following.

   .. code:: udev

      SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5bf0", MODE="0664", GROUP="plugdev"

   .. NOTE::
      You need ``sudo`` privileges for creating this file.

#. Reload the udev-rules using the following:

   .. session:: shell-session

      $ sudo udevadm control --reload-rules
      $ sudo udevadm trigger


.. _windows-zadig:

Installing Zadig Drivers
------------------------

.. warning::

   This set up is only needed for Windows system **earlier** than Windows 10.

#. Download `Zadig <https://zadig.akeo.ie/>`__.
#. Open Zadig.
#. Under ``Options``, select ``List All Devices``.
#. In the dropdown, select your Fomu; in the field right of the green arrow,
   choose the ``WinUSB`` driver; and hit ``Upgrade Driver``.

   .. figure:: ../_static/Zadig-Setup.png
      :align: center
      :alt: Setup of Zadig for updating USB port driver on Windows earlier than 10

      Setup of Zadig for updating USB port driver on Windows earlier than 10.
