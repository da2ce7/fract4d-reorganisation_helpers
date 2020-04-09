#!/bin/sh
# This script:
#	Rebases the extracted library ontop of the moden library.
#	Rewrites the committer to be the same as the author.

# Debug Mode
set -x
set -e

if [ ! -d "./temp/gnofract4d_library_rebase/.git" ]; then
	echo "canot find './temp/gnofract4d_library_rebase/.git' folder"
	exit 1
fi

cd temp/gnofract4d_library_rebase

git switch --force-create rebase_master library_old_master

# Do Rebase

# Please Note: This is a somewhat lossy operation as the committer is rewritten to be the user running this operation.

# In particular, some time information, and the committer "GitHub <noreply@github.com>" will be lost.
# However, personally, I (Cameron) think it is worth the cost as it gives a much more clear history of the changes.

git rebase --root --no-keep-empty --strategy-option=patience --strategy-option=diff-algorithm=histogram --strategy-option=renormalize --rebase-merges=rebase-cousins --onto library_modern_master

# Finished Rebase, now rewrite the committer author, email, and times.

# This operation will set the committer to be identical to the author.
# For almost all of the commits this is the same as it used to be prior to the rebase.

git filter-repo --commit-callback '
commit.committer_name  = commit.author_name
commit.committer_email = commit.author_email
commit.committer_date  = commit.author_date
' --force

git switch --force-create=master

#DONE!

