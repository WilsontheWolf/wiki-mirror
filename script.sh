#!/bin/bash

set -o errexit -o nounset

VENV="./.venv"

if [ ! -d "$VENV" ]; then
	python3 -m venv $VENV
fi

PATH="$VENV/bin:$PATH"

pip install sphinx shibuya myst_parser sphinx-lua-ls sphinxcontrib-video

rm -rf _tmpbuild 2> /dev/null || true
sphinx-build wiki _tmpbuild -b dirhtml
