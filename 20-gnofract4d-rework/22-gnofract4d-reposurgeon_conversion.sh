#!/bin/sh
# This script:
#	Checkouts the Gnofract 4d reposurgeon cvs to git recipe.
#	Runs the reposurgeon conversion.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline


# Debug Mode
set -x
set -e

if [[ -z ${reposurgeon_conversion_dir+x} ]]; then echo "Error: 'reposurgeon_conversion_dir' is unset.";	exit 1; fi

if [[ ! -d "./${reposurgeon_conversion_dir}/.git" ]]; then
	echo "canot find './${reposurgeon_conversion_dir}/.git' folder"
	exit 1
fi

cd ${reposurgeon_conversion_dir}

if [[ ! "${reposurgeon_conversion_use_prepackaged}" = "true" ]]; then
	# speedup download, extract backup
	tar --extract --file=gnofract4d-mirror-backup.tar.lzo
	# run makefile
	make
else
	# skip making new git repo, instead extract pre-packaged.
	tar --extract --file=gnofract4d-git.tar.lzo
fi

#DONE!

