.. _required-software:

Required Software
#################

.. note::

   If you’re taking this workshop as a class, the toolchains are provided
   on the USB disk.

Fomu requires specialized software. This software is provided for GNU/Linux, macOS,
and Windows, via `Fomu Toolchain <https://github.com/im-tomu/fomu-toolchain/releases/latest>`__.
Debian packages are also `available for Raspberry Pi <https://github.com/im-tomu/fomu-raspbian-packages>`__.

To install the software, extract it somewhere on your computer, then
open up a terminal window and add that directory to your PATH:

.. tabs::

   .. group-tab:: GNU/Linux or MacOS X

      .. session:: shell-session

         $ export PATH=[path-to-toolchain]/bin:$PATH

   .. group-tab:: Windows

      If you use PowerShell as your terminal;

      .. session:: ps1con

         PS> $ENV:PATH = "[path-to-toolchain]\bin;" + $ENV:PATH

      If you use ``cmd.exe`` as your terminal;

      .. session:: doscon

         C:\> PATH=[path-to-toolchain]\bin;%PATH%

Examples in :ref:`HDLs:VHDL` and :ref:`HDLs:mixed` use ghdl-yosys-plugin, which
looks for standard libraries in the path used when GHDL was configured/built.
Therefore, when the toolchain is extracted to an arbitrary location, `GHDL_PREFIX`
needs to be set:

.. tabs::

   .. group-tab:: GNU/Linux or MacOS X

      .. session:: shell-session

         $ export GHDL_PREFIX=[path-to-toolchain]/lib/ghdl

   .. group-tab:: Windows

      If you use PowerShell as your terminal;

      .. session:: ps1con

         PS> $ENV:GHDL_PREFIX = "[path-to-toolchain]\lib\ghdl"

      If you use ``cmd.exe`` as your terminal;

      .. session:: doscon

         C:\> GHDL_PREFIX=[path-to-toolchain]\lib\ghdl

To confirm installation, run the ``yosys`` command and confirm you get
the following output;

.. code-block:: shell-session
   :emphasize-lines: 23

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

    Yosys 78b30bbb1102047585d1a2eac89b1c7f5ca7344e (git sha1 41d9173, gcc 5.5.0-12ubuntu1~14.04 -fPIC -Os)

   yosys>

Type ``exit`` to quit ``yosys``.

.. note::

   See the README of `Fomu Toolchain <https://github.com/im-tomu/fomu-toolchain/releases/latest>`_
   for a complete list of the tools included in the toolchain.
