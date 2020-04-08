#!/bin/sh
# This script runs a collection of scripts that downloads, updates, converts the old cvs to git, rebase the new repo ontop of this old work.

# Debug Mode
set -x
set -e

if [ ! -d "./gnofract4d_git_helper_scripts/" ]; then
	echo "must run in subfolder of scripts"
	exit 1
fi

# run cvs to git scripts
./gnofract4d_git_helper_scripts/10-cvs_to_git/11-create_git_repo.sh
./gnofract4d_git_helper_scripts/10-cvs_to_git/12-create_reposurgeon_cvs_to_git.sh
./gnofract4d_git_helper_scripts/10-cvs_to_git/13-create_cvs_repo.sh
./gnofract4d_git_helper_scripts/10-cvs_to_git/14-create_rebase_repo.sh
./gnofract4d_git_helper_scripts/10-cvs_to_git/15-rebase_repo_unto_master.sh

# run rewrite repo scripts
./gnofract4d_git_helper_scripts/20-rewrite_history/21-create_rewrite_repo.sh
./gnofract4d_git_helper_scripts/20-rewrite_history/22-rewrite_repo.sh

# run extract website scripts
./gnofract4d_git_helper_scripts/30-extract_website/36-create_extract_website_repo.sh
./gnofract4d_git_helper_scripts/30-extract_website/37-create_website_repo.sh


#DONE!

