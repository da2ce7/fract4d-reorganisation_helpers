#!/bin/sh
# This script:
#	Checkouts the Fract 4d reposurgeon cvs to git recipe.
#	Unpacks the pre-packaged conversion, and continues.

# Debug Mode
set -x
set -e

mkdir -p ref/gnofract4d_reposurgeon
cd ref/gnofract4d_reposurgeon

if [ ! -d ".git/" ]; then
	git init
fi

git config remote.da2ce7_origin.url >&- || git remote add da2ce7_origin https://github.com/da2ce7/fract4d-cvs_reposurgeon_conversion.git

git fetch --all
git clean -ffxd

git switch --force-create  master da2ce7_origin/master

# skip making new git repo, instead extract pre-packaged.
tar --extract --file=gnofract4d-git.tar.lzo

#DONE!

