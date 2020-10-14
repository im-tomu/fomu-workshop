.. _required-files:

Required Files
--------------

.. note::

   If you’re attending a workshop that provides USB drives, these files may be
   available on the USB drive under the ``Workshop`` directory.

You will need the Workshop files. They are located in the
`fomu-workshop <https://github.com/im-tomu/fomu-workshop>`__ Github
repository. You can download
`master.zip <https://github.com/im-tomu/fomu-workshop/archive/master.zip>`__
or clone it from git:

.. session:: shell-session

   $ git clone --recurse-submodules https://github.com/im-tomu/fomu-workshop.git
   Cloning into 'fomu-workshop'...
   remote: Enumerating objects: 140, done.
   remote: Counting objects: 100% (140/140), done.
   remote: Compressing objects: 100% (93/93), done.
   remote: Total 871 (delta 87), reused 94 (delta 46), pack-reused 731
   Receiving objects: 100% (871/871), 6.22 MiB | 1.46 MiB/s, done.
   Resolving deltas: 100% (468/468), done.
   Submodule 'litex/deps/litedram' (https://github.com/enjoy-digital/litedram.git) registered for path 'litex/deps/litedram'
   Submodule 'litex/deps/litescope' (https://github.com/enjoy-digital/litescope.git) registered for path 'litex/deps/litescope'
   Submodule 'litex/deps/litex' (https://github.com/enjoy-digital/litex.git) registered for path 'litex/deps/litex'
   Submodule 'litex/deps/litex_boards' (https://github.com/litex-hub/litex-boards.git) registered for path 'litex/deps/litex_boards'
   Submodule 'litex/deps/migen' (https://github.com/m-labs/migen.git) registered for path 'litex/deps/migen'
   Submodule 'litex/deps/pyserial' (https://github.com/pyserial/pyserial.git) registered for path 'litex/deps/pyserial'
   Submodule 'litex/deps/valentyusb' (https://github.com/im-tomu/valentyusb.git) registered for path 'litex/deps/valentyusb'
   ...
   remote: Enumerating objects: 78, done.
   remote: Counting objects: 100% (78/78), done.
   remote: Compressing objects: 100% (71/71), done.
   remote: Total 78 (delta 2), reused 78 (delta 2), pack-reused 0
   Receiving objects: 100% (78/78), 10.88 MiB | 3.86 MiB/s, done.
   Resolving deltas: 100% (2/2), done.
   Submodule path 'litex/deps/litex/litex/soc/cores/cpu/vexriscv/verilog/ext/VexRiscv/src/test/resources/VexRiscvRegressionData': checked out '539398c1481203a51115b5f1228ea961f0ac9bd3'
   Submodule path 'litex/deps/litex/litex/soc/software/compiler_rt': checked out '81fb4f00c2cfe13814765968e09931ffa93b5138'
   Submodule path 'litex/deps/litex_boards': checked out '91083f99a8551c3465aaf3d6130268c7f7f24a50'
   Submodule path 'litex/deps/migen': checked out '562c0466443f859d6cf0c87a0bb50db094d27cf4'
   Submodule path 'litex/deps/pyserial': checked out 'acab9d2c0efb63323faebfd5e3405d77cd4b5617'
   Submodule path 'litex/deps/valentyusb': checked out 'b34852eb2e77bd9d04ebc3e6e8454cf6d93a02fb'
   $
