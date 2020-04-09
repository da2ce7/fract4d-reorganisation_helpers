#!/bin/sh
# This script:
#	Creates a temporary repository that contains the newly converted cvs-to-git version.
#	Removes the files that were never included in the modern git repository.

# Debug Mode
set -x
set -e

if [ ! -d "./ref/gnofract4d_reposurgeon/gnofract4d-git/.git" ]; then
	echo "canot find './ref/gnofract4d_reposurgeon/gnofract4d-git/.git' folder"
	exit 1
fi

rm -rf temp/gnofract4d_git_cvs
mkdir -p temp/gnofract4d_git_cvs
cd temp/gnofract4d_git_cvs

git init
git remote add cvs_reposurgeon_origin ../../ref/gnofract4d_reposurgeon/gnofract4d-git/

git fetch --all

git switch --create git_cvs_master cvs_reposurgeon_origin/master

# remove elephant_valley folder
git rm --cached -r elephant-valley/
git commit -m "remove 'elephant-valley' website testing ground"

# remove prams folder
git rm --cached -r params/
git commit -m "remove old fractal parameter files"

# remove utility folder
git rm --cached -r utils/
git commit -m "remove old utility files"

# remove translation folder
git rm --cached -r po/
git commit -m "remove old translation files"

# now we will use git.
git rm --cached CVS_IS_DEAD_USE_GIT
git commit -m "now we use git"

#DONE!

