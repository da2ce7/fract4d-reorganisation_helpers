#!/bin/sh
# This script:
#	Creates a repo with both the moden library and extracted library.
#	And prepare it for rebasing.

# Debug Mode
set -x
set -e

if [ ! -d "./ref/gnofract4d_library_modern/.git" ]; then
	echo "canot find './ref/gnofract4d_library_modern/.git' folder"
	exit 1
fi


if [ ! -d "./temp/gnofract4d_library_old/.git" ]; then
	echo "canot find './temp/gnofract4d_library_old/.git' folder"
	exit 1
fi

rm -rf temp/gnofract4d_library_rebase
mkdir -p temp/gnofract4d_library_rebase
cd temp/gnofract4d_library_rebase

git init
git remote add library_old_origin ../gnofract4d_library_old/
git remote add library_modern_origin ../../ref/gnofract4d_library_modern/

git fetch --all

git switch --create library_old_master library_old_origin/library_old_master
git switch --create library_modern_master library_modern_origin/library_modern_master

#DONE!

