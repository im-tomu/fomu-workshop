.. _required-software:

Required Software
#################

Fomu requires specialized software.

.. NOTE::
   If you’re taking this workshop as a class, the toolchains are provided
   on the USB disk.

Static builds of this software are provided for GNU/Linux, macOS, and Windows via
`Fomu Toolchain <https://github.com/im-tomu/fomu-toolchain/releases/latest>`__.

Debian packages are also `available for Raspberry Pi <https://github.com/im-tomu/fomu-raspbian-packages>`__.

Moreover, some examples can be executed using :ref:`required-software:containers`.

Fomu Toolchain
--------------

To install the software, extract it somewhere on your computer, then
open up a terminal window and add that directory to your ``PATH``:

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

Examples in :ref:`HDLs:VHDL` and :ref:`HDLs:mixed` use `ghdl-yosys-plugin <https://github.com/ghdl/ghdl-yosys-plugin>`_,
which looks for standard libraries in the path used when GHDL was configured/built.
Therefore, the nightly
<https://github.com/im-tomu/fomu-toolchain/releases/tag/nightly>
version of the toolchain (that includes the yosys GHDL plugin) needs
to be installed, and when the toolchain is extracted to an arbitrary
location, ``GHDL_PREFIX`` needs to be set:

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

.. NOTE::
   See the README of `Fomu Toolchain <https://github.com/im-tomu/fomu-toolchain/releases/latest>`_
   for a complete list of the tools included in the toolchain.

.. _required-software:containers:

Containers
----------

There are several projects which provide ready to use container images including open source EDA tools.
One of those is `hdl/containers <https://hdl.github.io/containers/>`__.
As explained in `hdl.github.io/containers: Usage <https://hdl.github.io/containers/#_usage>`__, there are two main
strategies for running EDA tools through containers:

* All-in-one: a single container is used, which includes all the required tools and dependencies.
  `make` and all the tools are executed inside that single container.
* Fine-grained: `make` is executed on the host. For each tool/step, an specific container is used.

Both strategies are supported by the examples in subdir :repo:`hdl <hdl>` of this repository.
Users willing to run those examples with containers need to take care about the following environment variables:

* `GHDL_PLUGIN_MODULE`: while ghdl-yosys-plugin is built into Yosys in the fomu-toolchain, it is provided as a module in
  most containers.
  Typically, `GHDL_PLUGIN_MODULE=ghdl` is required.
  Some specific containers might require `GHDL_PLUGIN_MODULE=path/to/ghdl-plugin-name.so`.
* `CONTAINER_ENGINE`: in order to enable the fine-grained approach, `CONTAINER_ENGINE` needs to contain the CLI tool
  name of a container engine, such as `docker` or `podman`.
  This variable needs to be unset for the all-in-one approach.
  In that case, the build is agnostic to the fact that everything is being done inside a container.

  .. NOTE::
    By default, container images defined in :repo:`hdl/container.mk <hdl/container.mk>` are used when
    `CONTAINER_ENGINE` is set.
    It's up to the users to customise that file in order to use different container images, or for executing some of the
    tools locally.

.. TIP::
  Find both approaches (and environment variables) used in the CI workflow
  (:repo:`.github/workflows/test.yml <.github/workflows/test.yml>`) of this repository.
