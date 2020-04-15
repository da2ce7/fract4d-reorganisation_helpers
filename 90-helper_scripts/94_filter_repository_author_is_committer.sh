#!/bin/sh
# This script:
#	Filters the Repository replacing the committer commit (name, email, date) with the author commit info.
#	Filters the Repository according to the .mailmap file. (if existing).

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


# Finished Rebase, now filter the committer author, email, and times.
# This operation will set the committer to be identical to the author.
# For almost all of the commits this is the same as it used to be prior to the rebase.
git filter-repo --commit-callback '
commit.committer_name  = commit.author_name
commit.committer_email = commit.author_email
commit.committer_date  = commit.author_date
' --force

# Do filter with git filter-repo, updating the authors from the pre-existing mailmap file.
if [[ -f "./.mailmap" ]]; then
	git filter-repo --mailmap .mailmap --force
fi

# Switch to master, ready for clone.
git switch --create="master" "${filter_repo_branch}"

