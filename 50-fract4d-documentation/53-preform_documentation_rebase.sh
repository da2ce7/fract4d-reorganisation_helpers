#!/bin/sh
# This script:
#	Preforms rebase, keeping as much structure intact as possible.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# Debug Mode
set -x
set -e

if [[ ! -d "./${rebase_repo_dir}/.git" ]]; then echo "canot find './${rebase_repo_dir}/.git' folder"; exit 1; fi

cd ${rebase_repo_dir}

# switch to new branch for rebase
git switch --force-create "${rebase_branch}" "${rebase_top_branch}"

# Do Rebase

# Please Note: This is a somewhat lossy operation as the committer is rewritten to be the user running this operation.

# In particular, some time information, and the committer "GitHub <noreply@github.com>" will be lost.
# However, personally, I (Cameron) think it is worth the cost as it gives a much more clear history of the changes.

# Skip Errors
set +e

git rebase --root --no-keep-empty --strategy-option=patience --strategy-option=diff-algorithm=histogram --strategy-option=renormalize --rebase-merges=rebase-cousins --onto ${rebase_base_branch}

# fe5c88d... python3 # Merge branch 'python3' of https://github.com/edyoung/gnofract4d into python3
git checkout fe5c88d manual/gnofract4d-manual.xml
git rebase --continue

# Enable Errors
set -e

# Finished Rebase.

#DONE!

