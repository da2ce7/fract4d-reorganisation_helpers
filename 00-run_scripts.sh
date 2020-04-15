#!/bin/sh
# This script:
#	Runs a collection of sub-scripts that help with organisation of the Gnofract 4D Repositories.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# Debug Mode
set -x
set -e


export this_repo_name="fract4d-reorganisation_helpers"

if [[ ! -d "./${this_repo_name}/" ]]; then
	set +x
	tput bold; tput setaf 1;
	echo -e "\n Error! \n"
	tput sgr0
	echo -e "Must be run in the direct subfolder of scripts!\n"
	exit 1
fi


readonly controll_scripts_dir="${this_repo_name}/10-controll_scripts"

# Gnofract 4D Rework
./${controll_scripts_dir}/12-run-gnofract4d_rework.sh

# Fract 4D Library Rework
./${controll_scripts_dir}/14-run-fract4d_library_rework.sh

# Fract 4D Documentation Rework
./${controll_scripts_dir}/15-run-fract4d_documentation_rework.sh

# Fract 4D Website Rework
./${controll_scripts_dir}/16-run-fract4d_website_rework.sh


# now make the Fract 4D folder to hold the results:


if [[ -d "./fract4d/" ]]; then
	set +x
	tput bold; tput setaf 1;
	echo -e "\n Error! \n"
	tput sgr0
	echo -e "The './fract4d/' folder must not exist before creating clones!\n"
	exit 1
fi

mkdir fract4d

# now that we are finished, lets clone the results
git clone ref/reworked-gnofract4d fract4d/gnofract4d
git clone ref/reworked-fract4d-library fract4d/library
git clone ref/reworked-fract4d-documentation fract4d/documentation
git clone ref/reworked-fract4d-website fract4d/website

# and exit with a message

set +x

tput bold; tput setaf 2;
echo -e "\n Completed Scripts!\n"
tput sgr0

echo -e "\n Please find the updated repos in the 'fract4d' subfolder this folder."
echo -e "\n Run 'rm -rf ./temp' to remove tempory data.\n"

#DONE!

