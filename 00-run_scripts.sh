#!/bin/sh
# This script:
#	Runs a collection of sub-scripts that help with organisation of the Gnofract 4D Repositories.

# Debug Mode
set -x
set -e

if [ ! -d "./fract4d-reorganisation_helpers/" ]; then
	set +x
	tput bold; tput setaf 1;
	echo -e "\n Error! \n"
	tput sgr0
	echo -e "Must be run in the direct subfolder of scripts!\n"
	exit 1
fi

# run cvs to git scripts
./fract4d-reorganisation_helpers/10-cvs_to_git/11-create_git_repo.sh

# two option:
#	first (do conversion)
./fract4d-reorganisation_helpers/10-cvs_to_git/12_convert-reposurgeon_cvs_to_git.sh

#	second (use pre-packaged)
#./fract4d-reorganisation_helpers/10-cvs_to_git/12_pre_packaged-reposurgeon_cvs_to_git.sh

./fract4d-reorganisation_helpers/10-cvs_to_git/13-create_cvs_repo.sh
./fract4d-reorganisation_helpers/10-cvs_to_git/14-create_rebase_repo.sh
./fract4d-reorganisation_helpers/10-cvs_to_git/15-rebase_repo_unto_master.sh

# run rewrite repo scripts
./fract4d-reorganisation_helpers/20-rewrite_history/21-create_rewrite_repo.sh
./fract4d-reorganisation_helpers/20-rewrite_history/22-rewrite_repo.sh

# run extract website and manual scripts
./fract4d-reorganisation_helpers/30-extract_subprojects/33-create_website_repo.sh
./fract4d-reorganisation_helpers/30-extract_subprojects/36-create_documentation_repo.sh
./fract4d-reorganisation_helpers/30-extract_subprojects/37-create_library_repo.sh

# run library rebase scripts
./fract4d-reorganisation_helpers/40-rebase_library/41-create_library_repo.sh
./fract4d-reorganisation_helpers/40-rebase_library/44-create_rebase_repo.sh
./fract4d-reorganisation_helpers/40-rebase_library/45-rebase_repo_unto_master.sh

# run verifcation
./fract4d-reorganisation_helpers/70-verify/71-create-fract4d-repo-and-verify.sh


if [ -d "./fract4d/" ]; then
	set +x
	tput bold; tput setaf 1;
	echo -e "\n Error! \n"
	tput sgr0
	echo -e "The './fract4d/' folder must not exist before creating clones!\n"
	exit 1
fi

mkdir fract4d

# now that we are finished, lets clone the results
git clone temp/gnofract4d_rewrite fract4d/gnofract4d
git clone temp/gnofract4d_documentation fract4d/documentation
git clone temp/gnofract4d_website fract4d/website
git clone temp/gnofract4d_library_rebase fract4d/library

# and exit with a message

set +x

tput bold; tput setaf 2;
echo -e "\n Completed Scripts!\n"
tput sgr0

echo -e "\n Please find the updated repos in the 'fract4d' subfolder this folder."
echo -e "\n Run 'rm -rf ./temp' to remove tempory data.\n"

#DONE!

