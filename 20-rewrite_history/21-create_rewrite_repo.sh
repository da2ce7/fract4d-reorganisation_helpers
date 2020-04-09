#!/bin/sh
# This script:
#	Checks out the Gnofract 4D rebased repo
#	Prepares the branch for rewriting.

# Debug Mode
set -x
set -e

if [ ! -d "./temp/gnofract4d_rebase" ]; then
	echo "canot find './temp/gnofract4d_rebase' folder"
	exit 1
fi

rm -rf temp/gnofract4d_rewrite
mkdir -p temp/gnofract4d_rewrite
cd temp/gnofract4d_rewrite

git init
git remote add rebase_origin ../gnofract4d_rebase/
git fetch --all
git switch --create rewrite_master rebase_origin/rebase_master


