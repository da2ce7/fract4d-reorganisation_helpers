#!/bin/sh
# This script:
#	Creates Gnofract 4D repository.
#	Verify that commited files are the same (at head commit of each branch).

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline


# Debug Mode
set -x
set -e


if [[ -z ${modern_git_dir+x} ]]; then echo "Error: 'modern_git_dir' is unset.";	exit 1; fi
if [[ -z ${reworked_git_dir+x} ]]; then echo "Error: 'reworked_git_dir' is unset.";	exit 1; fi

if [[ ! -d "./${modern_git_dir}/.git" ]]; then
	echo "canot find './${modern_git_dir}/.git' folder"
	exit 1
fi

if [[ ! -d "./${reworked_git_dir}/.git" ]]; then
	echo "canot find './${reworked_git_dir}/.git' folder"
	exit 1
fi

cd ${modern_git_dir}


readonly GIT_MODERN_MASTER_COMMIT_HASH="$(git rev-parse HEAD)"
readonly GIT_MODERN_MASTER_DATA_HASH="$(git show -s --format='%T' $GIT_MODERN_MASTER_COMMIT_HASH)"

cd ../../
cd ${reworked_git_dir}

readonly REWORKED_MASTER_COMMIT_HASH="$(git rev-parse HEAD)"
readonly REWORKED_MASTER_DATA_HASH="$(git show -s --format='%T' $REWORKED_MASTER_COMMIT_HASH)"


# compare hash and stop if error.

set +x
tput bold; printf "\n\n\n<Commit Hash> <Data Hash>\n"; tput sgr0;
printf "${GIT_MODERN_MASTER_COMMIT_HASH} "; tput setaf 4; printf $GIT_MODERN_MASTER_DATA_HASH; tput sgr0; printf "  (original)\n";
printf "${REWORKED_MASTER_COMMIT_HASH} "; tput setaf 4; printf $REWORKED_MASTER_DATA_HASH; tput sgr0; printf "  (rework)\n";


if [[ "$GIT_MODERN_MASTER_DATA_HASH" = "$REWORKED_MASTER_DATA_HASH" ]]; then
	tput bold; tput setaf 2;
	printf "\nSuccess: The data hash is the Same! :) \n\n"
	tput sgr0
else
	tput bold; tput setaf 1;
	printf "\nError: The data is not the same!\n\n"
	tput sgr0
	exit 1
fi


#DONE!


