#!/bin/sh
# This script rewrites the Gnofract 4D repo.

# Debug Mode
set -x
set -e

if [ ! -d "./gnofract4d_rewrite" ]; then
	echo "canot find './gnofract4d_rewrite' folder"
	exit 1
fi

cd gnofract4d_rewrite

# Do rewrite with git filter-repo, updating the authors from the pre-existing mailmap file.

git filter-repo --mailmap .mailmap --force

