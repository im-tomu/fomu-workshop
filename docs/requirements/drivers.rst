.. _required-drivers:

Required Drivers
================

On most systems the Fomu board does **not** need any special drivers.

* On Windows 10 or newer you do not need to install anything.
* On Windows systems **earlier** than Windows 10 you will need to
  :ref:`windows-zadig`.
* On MacOS X you do not need to install any drivers.
* On Linux you do not need to install any drivers, **however** you may need
  ``sudo`` access unless you :ref:`linux-udev` to grant permission to use the
  USB device from a non-privileged account.


.. _linux-udev:

Setup udev rules
----------------

.. warning::

   This set up is for Linux **only**.

   Setting up these udev rules grant permissions to use the USB device from a
   non-privileged account.

In Linux, try running ``dfu-util -l``, and if you get an error message like the
following you should add a ``udev`` rule as to give your user permission to the
usb device.

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
-------------------------

#. Add your user to the plugdev group

   .. session:: shell-session

      $ sudo groupadd plugdev
      $ sudo usermod -a -G plugdev $USER

#. Check you are in the ``plugdev`` group with ``id $USER``

   .. session:: shell-session

      $ id $USER
      uid=1000(tim) gid=1000(tim) groups=500(plugdev),997(admin)
      $

#. You **will** need to log out and log in again in order to be a member of the ``plugdev`` group.

   .. warning::

      You **must** log out and then log in again for the group addition to take affect.

#. Check you are in the ``plugdev`` group with ``groups``

   .. session:: shell-session

      $ groups | grep plugdev
      tim plugdev admin
      $

#. Create a file named ``/etc/udev/rules.d/99-fomu.rules`` and add the following:

   .. code:: udev

      SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5bf0", MODE="0664", GROUP="plugdev"

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
#. Under Options, select "List All Devices".
#. In the dropdown, select your Fomu and in the field right of the green arrow
   choose the `WinUSB` driver and hit Upgrade Driver.

   .. image:: ../_static/Zadeg-Setup.PNG
      :alt: Setup of ZADEG for Updating USBport driver on WIN7