#!/bin/sh
# This script rewrites the Gnofract 4D repo, removing all the files except the website; then changing the root to the website folder.

# Debug Mode
set -x
set -e

if [ ! -d "./gnofract4d_rewrite" ]; then
	echo "canot find './gnofract4d_rewrtie' folder"
	exit 1
fi


rm -rf gnofract4d_website
mkdir gnofract4d_website
cd gnofract4d_website

git init

git remote add rewrite_origin ../gnofract4d_rewrite
git fetch --all

git switch --create master rewrite_origin/rewrite_master

# remove everything except the website, and change the website as the root of the repo.
git filter-repo --path website/ --path-rename website/:  --force


#DONE!

