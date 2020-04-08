#!/bin/sh
# This script checks out the Gnofract 4D rebased repo, and prepares the branch for rewriting.

# Debug Mode
set -x
set -e

if [ ! -d "./gnofract4d_rebase" ]; then
	echo "canot find './gnofract4d_rebase' folder"
	exit 1
fi

rm -rf gnofract4d_rewrite
mkdir gnofract4d_rewrite
cd gnofract4d_rewrite

git init
git remote add rebase_origin ../gnofract4d_rebase/
git fetch --all
git switch --create rewrite_master rebase_origin/rebase_master


