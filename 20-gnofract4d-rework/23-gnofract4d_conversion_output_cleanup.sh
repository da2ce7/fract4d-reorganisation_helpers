#!/bin/sh
# This script:
#	Creates a temporary repository that contains the newly converted cvs-to-git version.
#	Removes the files that were never included in the modern git repository.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline


# Debug Mode
set -x
set -e

if [[ -z ${conversion_output_cleanup_dir+x} ]]; then echo "Error: 'conversion_output_cleanup_dir' is unset."; exit 1; fi

# check if we have git repo to use:
if [[ ! -d "./${conversion_output_cleanup_dir}/.git" ]]; then
	echo "canot find './${conversion_output_cleanup_dir}/.git' folder"
	exit 1
fi

cd ${conversion_output_cleanup_dir}

# remove elephant_valley folder
git rm --cached -r elephant-valley/
git commit -m "remove 'elephant-valley' website testing ground"

# remove prams folder
git rm --cached -r params/
git commit -m "remove old fractal parameter files"

# remove utility folder
git rm --cached -r utils/
git commit -m "remove old utility files"

# remove translation folder
git rm --cached -r po/
git commit -m "remove old translation files"

# now we will use git.
git rm --cached CVS_IS_DEAD_USE_GIT
git commit -m "now we use git"

#DONE!

