#!/bin/sh
# This script:
#	Rewrites the Gnofract 4D repo.
#	Removes all the files except the color map and fractal formulas.
#	Renames the color map and fractal formular folders.

# Debug Mode
set -x
set -e

if [ ! -d "./temp/gnofract4d_rewrite/.git" ]; then
	echo "canot find './temp/gnofract4d_rewrtie/.git' folder"
	exit 1
fi


rm -rf temp/gnofract4d_library_old
mkdir -p temp/gnofract4d_library_old
cd temp/gnofract4d_library_old

git init

git remote add rewrite_origin ../gnofract4d_rewrite
git fetch --all

git switch --create library_old_master rewrite_origin/rewrite_master

# remove everything except the website, and change the website as the root of the repo.
git filter-repo --path maps/ \
	--path-rename maps/:color_maps/gnofract4d/ \
	--path formulas/ \
	--path-rename formulas/:fractals/gnofract4d/ \
	--force

#DONE!

