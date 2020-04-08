#!/bin/sh
# This script checks out the modern git repo.

# Debug Mode
set -x
set -e

mkdir -p gnofract4d_git_modern
cd gnofract4d_git_modern

if [ ! -d ".git/" ]; then
	git init
fi

git config remote.fract4d_origin.url >&- || git remote add fract4d_origin https://github.com/fract4d/gnofract4d.git
git config remote.da2ce7_origin.url >&- || git remote add da2ce7_origin git@github.com:da2ce7/gnofract4d.git

git fetch --all
git clean -ffxd

git switch --force-create git_modern_master da2ce7_origin/mailmap

#DONE!

