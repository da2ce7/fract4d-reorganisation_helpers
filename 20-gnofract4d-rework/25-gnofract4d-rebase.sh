#!/bin/sh
# This script:
#	Rebases the modern Git repo onto the converted CVS to Git repo
#	Rewrites the committer to be the same as the author.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline


# Debug Mode
set -x
set -e

if [[ -z ${rebase_top_branch+x} ]];  then echo "Error: 'rebase_top_branch' is unset. "; exit 1; fi
if [[ -z ${rebase_base_branch+x} ]]; then echo "Error: 'rebase_base_branch' is unset."; exit 1; fi
if [[ -z ${rebase_repo_dir+x} ]];    then echo "Error: 'rebase_repo_dir' is unset.   "; exit 1; fi
if [[ -z ${rebase_branch+x} ]];      then echo "Error: 'rebase_branch' is unset.     "; exit 1; fi

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

# b30d2c71... initial checkin
git rebase --skip

# e6c09516... a bunch more files
git checkout e6c09516 -- fract4d/test_3d.py fract4d/test_fractalsite.py fract4d/test_image.py fractutils/makemap.py
git rm --cached fract4d/frm_docbook.kid
#git commit --no-edit
git rebase --continue

# c2d0ffd5... added map files
git checkout c2d0ffd5 scripts/vmrunner.py
#git commit --no-edit
git rebase --continue

# 597a64ab... missing file needed by tests
git rebase --skip

# 3c0191d9... add missing test file
git rebase --skip

# c298ffc6... missing test file
git rebase --skip

# 3a090d36... ignoring stuff
git checkout 3a090d36 -- .gitignore
git rm --cached website/.gitignore fractutils/.gitignore fract4dgui/.gitignore fract4d/c/.gitignore fract4d/.gitignore buildtools/.gitignore
#git commit --no-edit
git rebase --continue

# 20e2e483... master-2 # Merge branch 'master' of ssh://gnofract4d.git.sourceforge.net/gitroot/gnofract4d/gnofract4d
git checkout 20e2e483 -- debian/changelog debian/control debian/files
git rm --cached debian/gnofract4d.install debian/gnofract4d.manpages
#git commit --no-edit
git rebase --continue

# 8790025c... python3 # Merge branch 'python3' of https://github.com/edyoung/gnofract4d into python3
git checkout 8790025c -- doc/gnofract4d-manual/C/gnofract4d-manual.xml
git rm doc/gnofract4d-manual/C/commands.xml doc/gnofract4d-manual/C/gnofract4d-manual.html doc/gnofract4d-manual/C/stdlib.xml
#git commit --no-edit
git rebase --continue

# 93537461... python3-2 # Merge branch 'python3'
git checkout 93537461 -- setup.py
#git commit --no-edit
git rebase --continue

# 7a7d7aa3... master-4 # Merge branch 'master' of https://github.com/edyoung/gnofract4d
git checkout 7a7d7aa3 -- README
#git commit --no-edit
git rebase --continue

# Enable Errors
set -e

# Finished Rebase.

#DONE!

