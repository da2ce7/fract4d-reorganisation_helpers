#!/bin/sh
# This script:
#	Creates and Refreshes a Temporary Working Repository.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# Debug Mode
set -x
set -e

if [[ ! -d "./${this_repo_name}/" ]]; then
	set +x
	tput bold; tput setaf 1;
	echo -e "\n Error! \n"
	tput sgr0
	echo -e "Must be run in the direct subfolder of scripts!\n"
	exit 1
fi

set +x
while getopts ":r:n:u:b:" opt; do case $opt in
	r)  repo="${OPTARG}";     echo "-r 'repo'     was triggered, Parameter: ${repo}"     >&2 ;;
	n)  name="${OPTARG}";     echo "-n 'name'     was triggered, Parameter: ${name}"     >&2 ;;
	u)  repo_url="${OPTARG}"; echo "-u 'repo_url' was triggered, Parameter: ${repo_url}" >&2 ;;
	b)  branch="${OPTARG}";   echo "-b 'branch'   was triggered, Parameter: ${branch}"   >&2 ;;

	\?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
	:)  echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
esac
done
set -x

# we only create from local-folders
if [[ ! -d "./${repo_url}/.git" ]]; then
	echo "canot find './${repo_url}/.git' folder"
	exit 1
fi

repo="local-${repo}"

if [[ -z ${build_temp_repo_dir+x} ]]; then
	build_temp_repo_clean="true";
	build_temp_repo_dir="${repo}-${name}"
fi

# Note: Will clean by default.
if [[ ! -v build_temp_repo_clean ]]; then build_temp_repo_clean="true"; fi

if [[ ! "${build_temp_repo_clean}" = "false" ]]; then
	rm -rf "temp/${build_temp_repo_dir}"
fi

if [[ -d "./temp/${build_temp_repo_dir}/" ]]; then
	if [[ ! -d "./temp/${build_temp_repo_dir}/.git" ]]; then
		set +x
		tput bold; tput setaf 1;
		echo -e "\n Error! \n"
		tput sgr0
		echo -e "The folder Exists but isn't a Git Repo!\n"
		exit 1
	else
		set +x
		tput setaf 2; printf "\nAppending to Existing Temporary Repostory:" ; tput sgr0; printf "\n";
		printf "$(pwd)/"; tput setaf 3; printf "temp/${build_temp_repo_dir}"; tput sgr0; printf "\n\n";
		set -x
	fi
else
	set +x
	tput setaf 2; printf "\nCreating New Temporary Repostory:" ; tput sgr0; printf "\n";
	printf "$(pwd)/"; tput setaf 3; printf "temp/${build_temp_repo_dir}"; tput sgr0; printf "\n\n";
	set -x
fi

mkdir -p "temp/${build_temp_repo_dir}"
cd "temp/${build_temp_repo_dir}"

if [[ ! -d ".git/" ]]; then
	git init
fi

git config remote.${repo}.url >&- && git remote set-url ${repo} ../../${repo_url}
git config remote.${repo}.url >&- || git remote add ${repo} ../../${repo_url}

git fetch --all
git clean -ffxd

git switch --force-create ${repo}_${branch} ${repo}/${branch}

set +x
branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)"; branch_name=${branch_name##refs/heads/}
printf "\n Created and Swiched to Local Branch: "; tput setaf 3; printf ${branch_name}  ; tput sgr0; printf "\n";
set -x


#DONE!

