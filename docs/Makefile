# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS      =
SPHINXBUILD     = [ -e env/bin/activate ] && source env/bin/activate; sphinx-build
SPHINXAUTOBUILD = [ -e env/bin/activate ] && source env/bin/activate; sphinx-autobuild
SOURCEDIR       = .
BUILDDIR        = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help

livehtml:
	@$(SPHINXAUTOBUILD) -b html --ignore \*.swp --ignore \*~ $(SPHINXOPTS) "$(SOURCEDIR)" "$(BUILDDIR)/html"

.PHONY: livehtml

_download/Miniconda3-latest-Linux-x86_64.sh:
	mkdir _download
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O _download/Miniconda3-latest-Linux-x86_64.sh
	chmod a+x _download/Miniconda3-latest-Linux-x86_64.sh

env: _download/Miniconda3-latest-Linux-x86_64.sh
	rm -rf env
	./_download/Miniconda3-latest-Linux-x86_64.sh -p $(PWD)/env -b -f
	source env/bin/activate; conda config --system --add envs_dirs $(PWD)/env/envs
	source env/bin/activate; conda config --system --add pkgs_dirs $(PWD)/_download/pkgs
	source env/bin/activate; conda env update --name base --file ./environment.yml

.PHONY: env


# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: Makefile
