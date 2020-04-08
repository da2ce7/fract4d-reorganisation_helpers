#!/bin/sh
# This script creates new git checkout of the cvs-to-git output, and removes the files that that were not included in the modern git repo.

# Debug Mode
set -x
set -e

if [ ! -d "./gnofract4d_reposurgeon/gnofract4d-git/" ]; then
        echo "canot find './gnofract4d_reposurgeon/gnofract4d-git/' folder"
	exit 1
fi

rm -rf gnofract4d_git_cvs
mkdir gnofract4d_git_cvs
cd gnofract4d_git_cvs

git init
git remote add cvs_reposurgeon_origin ../gnofract4d_reposurgeon/gnofract4d-git/

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

