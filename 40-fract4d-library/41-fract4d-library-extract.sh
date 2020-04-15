#!/bin/sh
# This script:
#	Rewrites the Gnofract 4D repo.
#	Removes all the files except the color map and fractal formulas.
#	Renames the color map and fractal formular folders.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# Debug Mode
set -x
set -e

# check if we have git repo to use:
if [[ ! -d "./${filter_repo_dir}/.git" ]]; then
	echo "canot find './${filter_repo_dir}/.git' folder"
	exit 1
fi

cd ${filter_repo_dir}

# preform the extraction of the colour maps and fractal formulas.
git filter-repo --path maps/ \
	--path-rename maps/:color_maps/gnofract4d/ \
	--path formulas/ \
	--path-rename formulas/:fractals/gnofract4d/ \
	--force

# Switch to master, ready for clone.
git switch --create="master" "${filter_repo_branch}"

#DONE!

