#!/bin/sh
# This script:
#	Rewrites the Gnofract 4D repository to separate the documentation, creating a new repository.

# Debug Mode
set -x
set -e

if [ ! -d "./temp/gnofract4d_rewrite/.git" ]; then
	echo "canot find './temp/gnofract4d_rewrtie/.git' folder"
	exit 1
fi


rm -rf temp/gnofract4d_documentation
mkdir -p temp/gnofract4d_documentation
cd temp/gnofract4d_documentation

git init

git remote add rewrite_origin ../gnofract4d_rewrite
git fetch --all

git switch --create master rewrite_origin/rewrite_master

# remove we want the manual, and the script to make the manual.
git filter-repo --path doc/gnofract4d-manual/C \
	--path createdocs.py \
	--path-rename doc/gnofract4d-manual/C/:manual/ \
	--force

#DONE!

