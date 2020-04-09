#!/bin/sh
# This script:
#	Checks out the modern git repo.

# Debug Mode
set -x
set -e

mkdir -p ref/gnofract4d_git_modern
cd ref/gnofract4d_git_modern

if [ ! -d ".git/" ]; then
	git init
fi

git config remote.fract4d_origin.url >&- || git remote add fract4d_origin https://github.com/fract4d/gnofract4d.git

git fetch --all
git clean -ffxd

git switch --force-create git_modern_master fract4d_origin/master

#DONE!

