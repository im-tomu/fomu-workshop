.. _bootloader:

Bootloader
==========


.. _bootloader-update:

Updating the Fomu Bootloader
----------------------------


To update your Fomu, download the appropriate ``-updater`` dfu release from
`foboot <https://github.com/im-tomu/foboot/releases/latest>`__.

#. Download the :file:`{board type}-updater-v2.0.3.dfu` file.

   * If you have a ``PVT`` Fomu, download |pvt-updater|.
   * If you have a ``Hacker`` Fomu, download |hacker-updater|.

#. Run :file:`dfu-util -D pvt-updater-{version}.dfu`.
#. Your Fomu will flash rainbow for about five seconds, then reboot and go back
   to blinking.
#. To verify it has updated, ``dfu-util -l`` and check the version output.

.. |pvt-updater| replace:: `pvt-updater-v2.0.3.dfu <https://github.com/im-tomu/foboot/releases/download/v2.0.3/pvt-updater-v2.0.3.dfu>`__
.. |hacker-updater| replace:: `hacker-updater-v2.0.3.dfu <https://github.com/im-tomu/foboot/releases/download/v2.0.3/hacker-updater-v2.0.3.dfu>`__

This is an example session for updating a production board:

.. session::

    $ dfu-util -l
    dfu-util 0.9

    Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
    Copyright 2010-2016 Tormod Volden and Stefan Schmidt
    This program is Free Software and has ABSOLUTELY NO WARRANTY
    Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

    Found DFU: [1209:5bf0] ver=0101, devnum=19, cfg=1, intf=0, path="1-2", alt=0, name="Fomu PVT running DFU Bootloader v1.9.1", serial="UNKNOWN"
    $ wget https://github.com/im-tomu/foboot/releases/download/v2.0.3/pvt-updater-v2.0.3.dfu -O ~/Downloads/pvt-updater-v2.0.3.dfu
    --2019-12-27 20:01:16--  https://github.com/im-tomu/foboot/releases/download/v2.0.3/pvt-updater-v2.0.3.dfu
    Resolving github.com (github.com)... 140.82.118.3
    Connecting to github.com (github.com)|140.82.118.3|:443... connected.
    HTTP request sent, awaiting response... 302 Found
    Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.138.107
    Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.138.107|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 112844 (110K) [application/octet-stream]
    Saving to: ‘~/Downloads/pvt-updater-v2.0.3.dfu’

    ~/Downloads/pvt-updater-v2.0.3.dfu       100%[=====================================>] 110.20K   332KB/s    in 0.3s

    2019-12-27 20:01:17 (332 KB/s) - ‘~/Downloads/pvt-updater-v2.0.3.dfu’ saved [112844/112844]

    $ dfu-util -D ~/Downloads/pvt-updater-v2.0.3.dfu
    dfu-util 0.9

    Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
    Copyright 2010-2016 Tormod Volden and Stefan Schmidt
    This program is Free Software and has ABSOLUTELY NO WARRANTY
    Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

    Match vendor ID from file: 1209
    Match product ID from file: 70b1
    Opening DFU capable USB device...
    ID 1209:5bf0
    Run-time device DFU version 0101
    Claiming USB DFU Interface...
    Setting Alternate Setting #0 ...
    Determining device status: state = dfuIDLE, status = 0
    dfuIDLE, continuing
    DFU mode device DFU version 0101
    Device returned transfer size 1024
    Copying data from PC to DFU device
    Download	[=========================] 100%       112828 bytes
    Download done.
    state(7) = dfuMANIFEST, status(0) = No error condition is present
    state(8) = dfuMANIFEST-WAIT-RESET, status(0) = No error condition is present
    Done!
    $ sleep 5
    $ dfu-util -l
    dfu-util 0.9

    Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
    Copyright 2010-2016 Tormod Volden and Stefan Schmidt
    This program is Free Software and has ABSOLUTELY NO WARRANTY
    Please report bugs to http://sourceforge.net/p/dfu-util/tickets/

    Found DFU: [1209:5bf0] ver=0101, devnum=20, cfg=1, intf=0, path="1-2", alt=0, name="Fomu PVT running DFU Bootloader v2.0.3", serial="UNKNOWN"
    $

