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

FIXME: @xobs to add instructions here.
