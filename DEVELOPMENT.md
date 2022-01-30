# Developing the Workshop

The workshop is written in
[reStructuredText (rst)](https://en.wikipedia.org/wiki/ReStructuredText) and
[generated using Sphinx](https://www.sphinx-doc.org/en/master/).

It is hosted on [Read The Docs](http://readthedocs.org/) and currently uses the
[Material Design style](https://material.io/) developed by Google through
[a slightly custom version of the `sphinx_materialdesign_theme` package](http://github.com/SymbiFlow/sphinx_materialdesign_theme).

It uses the [`sphinxcontrib-session` extension](https://github.com/mithro/sphinxcontrib-session)
to properly highlight the example sessions and to allow copying only the
session lines.

Other sphinx extensions which are used include;

- [`sphinxcontrib-hdl-diagrams`](http://sphinxcontrib-hdl-diagrams.rtfd.io/) to
  generate nice diagrams from Verilog examples.
- [`sphinx-wavedrom`](https://github.com/bavovanachte/sphinx-wavedrom) to
  generate [nice waveform diagrams](http://wavedrom.com/). `sphinxcontrib-wavedrom`?
- [`sphinx_tabs`](https://github.com/djungelorm/sphinx-tabs) to support tabs
  for different Linux / Windows / Mac OS X instructions.

## Useful Resources for writing docs

- [Sphinx RestructuredText Primer](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html)
- [ReStructuredText directives](https://docutils.sourceforge.io/docs/ref/rst/directives.html)
- [Material Design Icons](https://material.io/resources/icons/)

# Building Workshop Locally

## On Mac & Linux

```shell-session
$ cd docs
```
Download conda environment with Python utilities:

```shell-session
$ make env
rm -rf env
make _download/Miniconda3-latest-Linux-x86_64.sh
make[1]: Entering directory '~/fomu-workshop/docs'
mkdir env
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O _download/Miniconda3-latest-Linux-x86_64.sh
--2020-01-03 10:15:07--  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
Resolving repo.anaconda.com (repo.anaconda.com)... 104.16.131.3, 104.16.130.3, 2606:4700::6810:8203, ...
Connecting to repo.anaconda.com (repo.anaconda.com)|104.16.131.3|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 71785000 (68M) [application/x-sh]
Saving to: ‘_download/Miniconda3-latest-Linux-x86_64.sh’

_download/Miniconda3-latest-Linux-x86_64.sh                100%[==================>]  68.46M  1.29MB/s    in 17s

2020-01-03 10:15:29 (3.98 MB/s) - ‘_download/Miniconda3-latest-Linux-x86_64.sh’ saved [71785000/71785000]

chmod a+x _download/Miniconda3-latest-Linux-x86_64.sh
make[1]: Leaving directory '~/fomu-workshop/docs'
_download/Miniconda3-latest-Linux-x86_64.sh -p ~/fomu-workshop/docs/env -b -f
PREFIX=~/fomu-workshop/docs/env
Unpacking payload ...
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: ~/fomu-workshop/docs/env

  added / updated specs:
    - _libgcc_mutex==0.1=main
    - asn1crypto==1.2.0=py37_0
    - ca-certificates==2019.10.16=0

<snip>

tk-8.6.10            | 3.2 MB    | ########################### | 100%
_libgcc_mutex-0.1    | 2 KB      | ########################### | 100%
xorg-libsm-1.2.3     | 25 KB     | ########################### | 100%
requests-2.22.0      | 84 KB     | ########################### | 100%
harfbuzz-2.4.0       | 1.5 MB    | ########################### | 100%
conda-package-handli | 942 KB    | ########################### | 100%
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
```

Install dependencies:

```shell-session
$ pip install -r requirements.txt
```

Build the html output:

```shell-session
$ make html
Running Sphinx v2.3.1
loading pickled environment... done
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 21 source files that are out of date
updating environment: [config changed ('version')] 15 added, 0 changed, 6 removed
reading sources... [100%] verilog
writing output... [100%] verilog
copying images... [100%] _static/wishbone-usb-debug-bridge.png
copying static files... ... done
copying extra files... done
dumping search index in English (code: en)... done
dumping object inventory... done
build succeeded, 15 warnings.

The HTML pages are in _build/html.
Copying tabs assets
```

Start your web browser:

```shell-session
$ xdg-open ./_build/html/index.html
```

## On Windows

You may use either cmd.exe or Powershell. To begin with, set up venv. This may prompt you to install Python from the Microsoft Store:
```shell-session
$ cd docs
$ python -mvenv .
```

Activate the venv by running `Activate.bat` (if using cmd.exe) or `Activate.ps1` (if using Powershell). You must do this any time you want to work on the documentation:

```shell-session
$ .\Scripts\Activate.ps1
(docs) $
```

You'll notice that the word `(docs)` is added to your command prompt. This indicates you're in a venv directory.

Next, install dependencies:

```shell-session
(docs) $ pip install -r requirements.txtCollecting sphinx_symbiflow_theme
  Cloning http://github.com/SymbiFlow/sphinx_materialdesign_theme.git (to revision master) to c:\users\sean\appdata\local\temp\pip-install-do82_l8w\sphinx-symbiflow-theme_75938b6aa0c04180962403b9b4b53fae
  Running command git clone -q http://github.com/SymbiFlow/sphinx_materialdesign_theme.git 'C:\Users\sean\AppData\Local\Temp\pip-install-do82_l8w\sphinx-symbiflow-theme_75938b6aa0c04180962403b9b4b53fae'
  Resolved http://github.com/SymbiFlow/sphinx_materialdesign_theme.git to commit 5a7c118c6485461de299366f638a0f3cc41ed4e8
Collecting sphinxcontrib-session
  Cloning https://github.com/mithro/sphinxcontrib-session.git to c:\users\sean\appdata\local\temp\pip-install-do82_l8w\sphinxcontrib-session_468cf0a370a04b079fd59a990969f629
  Running command git clone -q https://github.com/mithro/sphinxcontrib-session.git 'C:\Users\sean\AppData\Local\Temp\pip-install-do82_l8w\sphinxcontrib-session_468cf0a370a04b079fd59a990969f629'
  Resolved https://github.com/mithro/sphinxcontrib-session.git to commit f9e959a696ba02d874ffc291a3b83a4458c1bad6

<snip>

    Running setup.py install for sphinxcontrib-session ... done
    Running setup.py install for sphinxcontrib-hdl-diagrams ... done
    Running setup.py install for sphinx-symbiflow-theme ... done
Successfully installed Jinja2-3.0.3 MarkupSafe-2.0.1 Pygments-2.11.2 alabaster-0.7.12 appdirs-1.4.4 attrdict-2.0.1 babel-2.9.1 cairocffi-1.3.0 cairosvg-2.5.2 certifi-2021.10.8 cffi-1.15.0 charset-normalizer-2.0.10 colorama-0.4.4 cssselect2-0.4.1 defusedxml-0.7.1 docutils-0.16 idna-3.3 imagesize-1.3.0 livereload-2.6.3 nmigen-0.2 packaging-21.3 pillow-9.0.0 pycparser-2.21 pyparsing-3.0.7 pytz-2021.3 pyvcd-0.1.7 requests-2.27.1 six-1.16.0 snowballstemmer-2.2.0 sphinx-3.5.4 sphinx-autobuild-2021.3.14 sphinx-symbiflow-theme-0.1.11 sphinx-tabs-3.2.0 sphinxcontrib-applehelp-1.0.2 sphinxcontrib-devhelp-1.0.2 sphinxcontrib-hdl-diagrams-0.0.dev0 sphinxcontrib-htmlhelp-2.0.0 sphinxcontrib-jsmath-1.0.1 sphinxcontrib-qthelp-1.0.3 sphinxcontrib-serializinghtml-1.1.5 sphinxcontrib-session-0.0.1 sphinxcontrib-wavedrom-3.0.2 svgwrite-1.4.1 tinycss2-1.1.1 tornado-6.1 urllib3-1.26.8 wasmtime-0.30.0 wavedrom-2.0.3.post2 webencodings-0.5.1 xcffib-0.11.1 yowasp-yosys-0.13.dev285
WARNING: You are using pip version 21.2.4; however, version 22.0 is available.
You should consider upgrading via the 'E:\Code\Fomu\workshop\docs\Scripts\python.exe -m pip install --upgrade pip' command.
(docs) $
```

Build HTML:
```
(docs) $ sphinx-build -M html . _build
Running Sphinx v3.5.4

<snip>

dumping search index in English (code: en)... done
dumping object inventory... done
build succeeded, 20 warnings.

The HTML pages are in _build\html.
(docs) $
```

Start your web browser:

```shell-session
$ explorer ./_build/html/index.html
```