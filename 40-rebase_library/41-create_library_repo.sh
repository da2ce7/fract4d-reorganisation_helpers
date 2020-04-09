#!/bin/sh
# This script checks out the modern library repo.

# Debug Mode
set -x
set -e

mkdir -p ref/gnofract4d_library_modern
cd ref/gnofract4d_library_modern

if [ ! -d ".git/" ]; then
	git init
fi

git config remote.fract4d_origin.url >&- || git remote add fract4d_origin https://github.com/fract4d/formulas.git
git config remote.da2ce7_origin.url >&-  || git remote add da2ce7_origin https://github.com/da2ce7/fract4d-library.git

git fetch --all
git clean -ffxd

git switch --force-create library_modern_master da2ce7_origin/master

#DONE!

