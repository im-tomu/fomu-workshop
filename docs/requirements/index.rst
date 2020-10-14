.. |Foboot Version| replace:: v2.0.3

Requirements
############

For this workshop you will need;

#. The Fomu workshop files - see :ref:`required-files` section.
#. The Fomu toolchain - see :ref:`required-software` section.
#. A Fomu board - see :ref:`required-hardware` section.
#. Set up drivers - see :ref:`required-drivers` section.

.. note::

    If you are at a workshop, please **install the tools first** and then get
    the hardware from your presenter.


.. warning::

    Your Fomu should be running Foboot |Foboot Version| or newer.

    You can see what version you are running by typing ``dfu-util -l`` like so;

    .. session:: shell-session
        :emphasize-lines: 9

        $ dfu-util -l
        dfu-util 0.9

        Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
        Copyright 2010-2016 Tormod Volden and Stefan Schmidt
        This program is Free Software and has ABSOLUTELY NO WARRANTY
        Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

        Found DFU: [1209:5bf0] ver=0101, devnum=19, cfg=1, intf=0, path="1-2", alt=0, name="Fomu PVT running DFU Bootloader v2.0.3", serial="UNKNOWN"
        $

    If your Fomu is running an version older than |Foboot Version| follow the
    :ref:`bootloader-update` section.

.. toctree::
   :maxdepth: 5

   files
   software
   hardware
   drivers
