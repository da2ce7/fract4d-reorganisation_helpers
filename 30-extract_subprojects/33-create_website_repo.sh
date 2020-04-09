#!/bin/sh
# This script:
#	Rewrites the Gnofract 4D repository,
#	Removes all the files except the website,
#	Changes to the root to the website folder.

# Debug Mode
set -x
set -e

if [ ! -d "./temp/gnofract4d_rewrite/.git" ]; then
	echo "canot find './temp/gnofract4d_rewrtie/.git' folder"
	exit 1
fi


rm -rf temp/gnofract4d_website
mkdir temp/gnofract4d_website
cd temp/gnofract4d_website

git init

git remote add rewrite_origin ../gnofract4d_rewrite
git fetch --all

git switch --create master rewrite_origin/rewrite_master

# remove everything except the website, and change the website as the root of the repo.
git filter-repo --path website/ --path-rename website/:  --force

#DONE!

