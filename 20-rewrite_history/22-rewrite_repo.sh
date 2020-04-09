#!/bin/sh
# This script:
#	Rewrites the Gnofract 4D repo.

# Debug Mode
set -x
set -e

if [ ! -d "./temp/gnofract4d_rewrite" ]; then
	echo "canot find './temp/gnofract4d_rewrite' folder"
	exit 1
fi

cd temp/gnofract4d_rewrite

# Do rewrite with git filter-repo, updating the authors from the pre-existing mailmap file.

git filter-repo --mailmap .mailmap --force


# Switch to master, ready for clone.
git switch --create master rebase_origin/rebase_master

