#!/bin/sh
# This script:
#	Creates and Refreshes a Reference Repository.

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

set +x
if [[ -d "./ref/${repo}-${name}/" ]]; then
	tput setaf 4; printf "\n\nUpdating Existing Reference Repository." ; tput sgr0; printf "\n\n";
else
	tput setaf 3; tput bold; printf "\n\nCreating New Reference Repository." ; tput sgr0; printf "\n\n";
fi

printf "$(pwd)/"; tput setaf 3; printf  ref/${repo}-${name}; tput sgr0; printf "\n\n";
set -x


mkdir -p "ref/${repo}-${name}"
cd "ref/${repo}-${name}"

if [[ ! -d ".git/" ]]; then
	git init
fi

git config remote.${repo}.url >&- && git remote set-url ${repo} ${repo_url}
git config remote.${repo}.url >&- || git remote add ${repo} ${repo_url}

git fetch --all
git clean -ffxd

git switch --force-create ${repo}_${branch} ${repo}/${branch}

set +x
branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)"; branch_name=${branch_name##refs/heads/}
printf "\n Created and Switched to Local Branch::  "; tput setaf 3; printf ${branch_name}  ; tput sgr0; printf "\n";
set -x


#DONE!

