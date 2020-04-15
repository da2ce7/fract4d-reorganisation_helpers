#!/bin/sh
#
# 10-controll_scripts/14-run-fract4d_website_rework.sh
#
# This script:
#	Runs the scripts for extracting and creating the Fract 4D Library.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# Debug Mode
set -x
set -e


export this_repo_name="fract4d-reorganisation_helpers"
readonly helper_script_dir="${this_repo_name}/90-helper_scripts"
readonly website_rework_script_dir="${this_repo_name}/60-fract4d-website"

readonly build_ref_script="${helper_script_dir}/91-build_reference_repository.sh"
readonly build_temp_script="${helper_script_dir}/92-build_temporary_working_repository.sh"
readonly rebase_script="${helper_script_dir}/93-preform_rebase_repository.sh"
readonly filter_script="${helper_script_dir}/94_filter_repository_author_is_committer.sh"

readonly extract_script="${website_rework_script_dir}/61-fract4d-website-extract.sh"



# ------------
# Fract 4D Library Repository (Reference)

readonly ref_website_repo="da2ce7"
readonly ref_website_name="fract4d-website"
readonly ref_website_url="https://github.com/${ref_website_repo}/${ref_website_name}.git"
readonly ref_website_branch="master"
readonly ref_website_dir="ref/${ref_website_repo}-${ref_website_name}"
readonly ref_website_out_branch="${ref_website_repo}_${ref_website_branch}"

./"${build_ref_script}" \
	-r "${ref_website_repo}"   \
	-n "${ref_website_name}"   \
	-u "${ref_website_url}"    \
	-b "${ref_website_branch}"


# ------------
# Reworked Gnofract 4D Repository (Reference)

readonly ref_gnofract4d_reworked_repo="reworked"
readonly ref_gnofract4d_reworked_name="gnofract4d"
readonly ref_gnofract4d_reworked_branch="master"
readonly ref_gnofract4d_reworked_dir="ref/${ref_gnofract4d_reworked_repo}-${ref_gnofract4d_reworked_name}"
readonly ref_gnofract4d_reworked_out_branch="${ref_gnofract4d_reworked_repo}_${ref_gnofract4d_reworked_branch}"


# ------------
# ------------
# Extract from Gnofract4d

readonly temp_website_extracted_repo="extracted"
readonly temp_website_extracted_name="${ref_website_name}"
readonly temp_website_extracted_dir="temp/local-${temp_website_extracted_repo}-${temp_website_extracted_name}"
readonly temp_website_extracted_out_branch="local-${ref_gnofract4d_reworked_repo}_${ref_gnofract4d_reworked_out_branch}"

export build_temp_repo_dir="local-${temp_website_extracted_repo}-${temp_website_extracted_name}" 

./"${build_temp_script}" \
	-r "${ref_gnofract4d_reworked_repo}"   \
	-n "${ref_gnofract4d_reworked_name}"   \
	-u "${ref_gnofract4d_reworked_dir}"    \
	-b "${ref_gnofract4d_reworked_out_branch}"

unset build_temp_repo_dir;

export filter_repo_dir="${temp_website_extracted_dir}"
export filter_repo_branch="${temp_website_extracted_out_branch}"

./"${extract_script}"

unset filter_repo_branch; unset filter_branch;


# ------------
# ------------
# Rebase

readonly temp_website_rebase_repo="rebase"
readonly temp_website_rebase_name="${ref_website_name}"
readonly temp_website_rebase_dir="temp/local-${temp_website_rebase_repo}-${temp_website_rebase_name}"
readonly temp_website_rebase_out_branch_base="local-${ref_website_repo}_${ref_website_out_branch}"
readonly temp_website_rebase_out_branch_top="local-${temp_website_extracted_repo}_${temp_website_extracted_out_branch}"
readonly temp_website_rebase_out_branch="rebased-master"

export build_temp_repo_dir="local-${temp_website_rebase_repo}-${temp_website_rebase_name}" 

# Rebase (Working Temp, Create, Template (Base))
./"${build_temp_script}" \
	-r "${ref_website_repo}"   \
	-n "${ref_website_name}"   \
	-u "${ref_website_dir}"    \
	-b "${ref_website_out_branch}"

# Rebase (Working Temp, Extracted (Top))
export build_temp_repo_clean="false"

./"${build_temp_script}" \
	-r "${temp_website_extracted_repo}"   \
	-n "${temp_website_extracted_name}"   \
	-u "${temp_website_extracted_dir}"    \
	-b "${temp_website_extracted_out_branch}"

unset build_temp_repo_dir;
unset build_temp_repo_clean;

# Rebase (Do Rebase)
export rebase_repo_dir="${temp_website_rebase_dir}"
export rebase_base_branch="${temp_website_rebase_out_branch_base}"
export rebase_top_branch="${temp_website_rebase_out_branch_top}"
export rebase_branch="${temp_website_rebase_out_branch}"

./"${rebase_script}"

unset rebase_repo_dir; unset rebase_base_branch; unset rebase_top_branch; unset rebase_branch;

# Filter (Correct Committer After Rebase)
export filter_repo_dir="${temp_website_rebase_dir}"
export filter_repo_branch="${temp_website_rebase_out_branch}"

./"${filter_script}"

unset filter_repo_branch; unset filter_branch;


#########
# Make Rworked Reference Repository
#########

readonly ref_website_reworked_repo="reworked"
readonly ref_website_reworked_name="${ref_website_name}"
readonly ref_website_reworked_url="../../${temp_website_rebase_dir}"
readonly ref_website_reworked_branch="master"
readonly ref_website_reworked_dir="ref/${ref_website_reworked_repo}-${ref_website_reworked_name}"
readonly ref_website_reworked_out_branch="${ref_website_reworked_repo}_${ref_website_reworked_branch}"

./"${build_ref_script}" \
	-r "${ref_website_reworked_repo}"   \
	-n "${ref_website_reworked_name}"   \
	-u "${ref_website_reworked_url}"    \
	-b "${ref_website_reworked_branch}"

exit 0;

#DONE!

