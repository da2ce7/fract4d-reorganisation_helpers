#!/bin/sh
# This script:
#	Creates Gnofract 4D repository.
#	Verify that commited files are the same (at head commit of each branch).

# Debug Mode
set -x
set -e

if [ ! -d "./temp/gnofract4d_rewrite/.git" ]; then
	echo "canot find './temp/gnofract4d_rewrite/.git' folder"
	exit 1
fi


rm -rf temp/gnofract4d_verify
mkdir -p temp/gnofract4d_verify
cd temp/gnofract4d_verify

git init

git remote add rewrite_origin ../gnofract4d_rewrite
git remote add git_modern_origin ../../ref/gnofract4d_git_modern/
git fetch --all

git switch --create rewrite_master rewrite_origin/rewrite_master
git switch --create git_modern_master git_modern_origin/git_modern_master



# compare hash and stop if error.
GIT_MODERN_MASTER_COMMIT_HASH="$(git rev-parse git_modern_master)"
REWRITE_MASTER_COMMIT_HASH="$(git rev-parse rewrite_master)"

GIT_MODERN_MASTER_DATA_HASH="$(git show -s --format='%T' $GIT_MODERN_MASTER_COMMIT_HASH)"
REWRITE_MASTER_DATA_HASH="$(git show -s --format='%T' $REWRITE_MASTER_COMMIT_HASH)"

set +x
tput bold; printf "\n\n\n<Commit Hash> <Data Hash>\n"; tput sgr0;
printf "${GIT_MODERN_MASTER_COMMIT_HASH} "; tput setaf 4; printf $GIT_MODERN_MASTER_DATA_HASH; tput sgr0; printf "  (original)\n";
printf "${REWRITE_MASTER_COMMIT_HASH} "; tput setaf 4; printf $REWRITE_MASTER_DATA_HASH; tput sgr0; printf "  (rework)\n";


if [ "$GIT_MODERN_MASTER_DATA_HASH" = "$REWRITE_MASTER_DATA_HASH" ]; then
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


