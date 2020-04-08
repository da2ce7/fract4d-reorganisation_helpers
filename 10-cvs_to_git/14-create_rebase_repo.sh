#!/bin/sh
# This script creates a new git repo where the modern git repo and updated converted cvs repo are both added as remotes and branches.

# Debug Mode
set -x
set -e

if [ ! -d "./gnofract4d_git_modern/.git" ]; then
	echo "canot find './gnofract4d_git_modern/.git' folder"
	exit 1
fi


if [ ! -d "./gnofract4d_git_cvs/.git" ]; then
	echo "canot find './gnofract4d_git_cvs/git' folder"
	exit 1
fi

rm -rf gnofract4d_rebase
mkdir gnofract4d_rebase
cd gnofract4d_rebase

git init
git remote add git_cvs_origin ../gnofract4d_git_cvs/
git remote add git_modern_origin ../gnofract4d_git_modern/

git fetch --all

git switch --create git_cvs_master git_cvs_origin/git_cvs_master
git switch --create git_modern_master git_modern_origin/git_modern_master

#DONE!

