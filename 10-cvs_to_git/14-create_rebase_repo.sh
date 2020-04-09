#!/bin/sh
# This script:
#	Creates a temporary repository that contains both the original git version, and the newly converted cvs-to-git version.
#	Create branches ready for rebase.

# Debug Mode
set -x
set -e

if [ ! -d "./ref/gnofract4d_git_modern/.git" ]; then
	echo "canot find './gnofract4d_git_modern/.git' folder"
	exit 1
fi


if [ ! -d "./temp/gnofract4d_git_cvs/.git" ]; then
	echo "canot find './gnofract4d_git_cvs/git' folder"
	exit 1
fi

rm -rf temp/gnofract4d_rebase
mkdir -p temp/gnofract4d_rebase
cd temp/gnofract4d_rebase

git init
git remote add git_cvs_origin ../gnofract4d_git_cvs/
git remote add git_modern_origin ../../ref/gnofract4d_git_modern/

git fetch --all

git switch --create git_cvs_master git_cvs_origin/git_cvs_master
git switch --create git_modern_master git_modern_origin/git_modern_master

#DONE!

