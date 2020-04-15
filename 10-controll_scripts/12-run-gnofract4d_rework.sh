#!/bin/sh
#
# 10-controll_scripts/12-run-gnofract4d_rework.sh
#
# This script:
#	Runs the scripts within for completing the CVS conversion.

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
readonly gnofract4d_rework_script_dir="${this_repo_name}/20-gnofract4d-rework"

readonly build_ref_script="${helper_script_dir}/91-build_reference_repository.sh"
readonly build_temp_script="${helper_script_dir}/92-build_temporary_working_repository.sh"
readonly filter_script="${helper_script_dir}/94_filter_repository_author_is_committer.sh"

readonly reposurgeon_conversion_script="${gnofract4d_rework_script_dir}/22-gnofract4d-reposurgeon_conversion.sh"
readonly conversion_output_cleanup_script="${gnofract4d_rework_script_dir}/23-gnofract4d_conversion_output_cleanup.sh"
readonly rebase_script="${gnofract4d_rework_script_dir}/25-gnofract4d-rebase.sh"
readonly verify_script="${gnofract4d_rework_script_dir}/29-gnofract4d-rework_verify.sh"


#------------
# Gnofract 4D Original Repository (Reference)

readonly ref_gnofract4d_repo="fract4d"
readonly ref_gnofract4d_name="gnofract4d"
readonly ref_gnofract4d_url="https://github.com/${ref_gnofract4d_repo}/${ref_gnofract4d_name}.git"
readonly ref_gnofract4d_branch="master"
readonly ref_gnofract4d_dir="ref/${ref_gnofract4d_repo}-${ref_gnofract4d_name}"
readonly ref_gnofract4d_out_branch="${ref_gnofract4d_repo}_${ref_gnofract4d_branch}"

./"${build_ref_script}" \
	-r "${ref_gnofract4d_repo}"   \
	-n "${ref_gnofract4d_name}"   \
	-u "${ref_gnofract4d_url}"    \
	-b "${ref_gnofract4d_branch}"


#------------
# Reposurgeon Conversion Recipe (Reference)

readonly ref_reposurgeon_conversion_repo="da2ce7"
readonly ref_reposurgeon_conversion_name="fract4d-reposurgeon_conversion"
readonly ref_reposurgeon_conversion_url="https://github.com/${ref_reposurgeon_conversion_repo}/${ref_reposurgeon_conversion_name}.git"
readonly ref_reposurgeon_conversion_branch="master"
readonly ref_reposurgeon_conversion_dir="ref/${ref_reposurgeon_conversion_repo}-${ref_reposurgeon_conversion_name}"
readonly ref_reposurgeon_conversion_out_branch="${ref_reposurgeon_conversion_repo}_${ref_reposurgeon_conversion_branch}"

./"${build_ref_script}" \
	-r "${ref_reposurgeon_conversion_repo}"   \
	-n "${ref_reposurgeon_conversion_name}"   \
	-u "${ref_reposurgeon_conversion_url}"    \
	-b "${ref_reposurgeon_conversion_branch}"

#------------
# Reposurgeon Conversion (Working Temp)

readonly temp_reposurgeon_conversion_dir="temp/local-${ref_reposurgeon_conversion_repo}-${ref_reposurgeon_conversion_name}"
readonly temp_reposurgeon_conversion_out_branch="local-${ref_reposurgeon_conversion_repo}_${ref_reposurgeon_conversion_out_branch}"

./"${build_temp_script}" \
	-r "${ref_reposurgeon_conversion_repo}"   \
	-n "${ref_reposurgeon_conversion_name}"   \
	-u "${ref_reposurgeon_conversion_dir}"    \
	-b "${ref_reposurgeon_conversion_out_branch}"


#-----------
# Reposurgeon Conversion Output (Sub-Dir)

readonly generated_reposurgeon_dir="${temp_reposurgeon_conversion_dir}/gnofract4d-git"
readonly generated_reposurgeon_out_branch="master"

export reposurgeon_conversion_dir="${temp_reposurgeon_conversion_dir}"
export reposurgeon_conversion_use_prepackaged="true"

./"${reposurgeon_conversion_script}"

unset reposurgeon_conversion_dir; unset reposurgeon_conversion_use_prepackaged

#------------
# Reposurgeon Output (Working Temp)

readonly temp_reposurgeon_output_repo="generated"
readonly temp_reposurgeon_output_name="reposurgeon_output"
readonly temp_reposurgeon_output_dir="temp/local-${temp_reposurgeon_output_repo}-${temp_reposurgeon_output_name}"
readonly temp_reposurgeon_output_out_branch="local-${temp_reposurgeon_output_repo}_${generated_reposurgeon_out_branch}"

./"${build_temp_script}" \
	-r "${temp_reposurgeon_output_repo}"   \
	-n "${temp_reposurgeon_output_name}"   \
	-u "${generated_reposurgeon_dir}"    \
	-b "${generated_reposurgeon_out_branch}"

#------------
# Reposurgeon Output (Working Temp, Cleanup)

export conversion_output_cleanup_dir="${temp_reposurgeon_output_dir}"

./"${conversion_output_cleanup_script}"

unset conversion_output_cleanup_dir;


# ------------
# ------------
# Rebase

readonly temp_gnofract4d_rebase_repo="rebase"
readonly temp_gnofract4d_rebase_name="${ref_gnofract4d_name}"
readonly temp_gnofract4d_rebase_dir="temp/local-${temp_gnofract4d_rebase_repo}-${temp_gnofract4d_rebase_name}"
readonly temp_gnofract4d_rebase_out_branch_base="local-${temp_reposurgeon_output_repo}_${temp_reposurgeon_output_out_branch}"
readonly temp_gnofract4d_rebase_out_branch_top="local-${ref_gnofract4d_repo}_${ref_gnofract4d_out_branch}"
readonly temp_gnofract4d_rebase_out_branch="rebased-master"

export build_temp_repo_dir="local-${temp_gnofract4d_rebase_repo}-${temp_gnofract4d_rebase_name}" 

# Rebase (Working Temp, Create, Reposurgeon Output)
./"${build_temp_script}" \
	-r "${temp_reposurgeon_output_repo}"   \
	-n "${temp_reposurgeon_output_name}"   \
	-u "${temp_reposurgeon_output_dir}"    \
	-b "${temp_reposurgeon_output_out_branch}"

# Rebase (Working Temp, Append Original Repository)
export build_temp_repo_clean="false"

./"${build_temp_script}" \
	-r "${ref_gnofract4d_repo}"   \
	-n "${ref_gnofract4d_name}"   \
	-u "${ref_gnofract4d_dir}"    \
	-b "${ref_gnofract4d_out_branch}"

unset build_temp_repo_dir;
unset build_temp_repo_clean;

# Rebase (Do Rebase)
export rebase_repo_dir="${temp_gnofract4d_rebase_dir}"
export rebase_base_branch="${temp_gnofract4d_rebase_out_branch_base}"
export rebase_top_branch="${temp_gnofract4d_rebase_out_branch_top}"
export rebase_branch="${temp_gnofract4d_rebase_out_branch}"

./"${rebase_script}"

unset rebase_repo_dir; unset rebase_base_branch; unset rebase_top_branch; unset rebase_branch;


# ------------
# ------------
# Filter

readonly temp_gnofract4d_filter_repo="filter"
readonly temp_gnofract4d_filter_name="${ref_gnofract4d_name}"
readonly temp_gnofract4d_filter_dir="temp/local-${temp_gnofract4d_filter_repo}-${temp_gnofract4d_filter_name}"
readonly temp_gnofract4d_filter_out_branch="local-${temp_gnofract4d_rebase_repo}_${temp_gnofract4d_rebase_out_branch}"

export build_temp_repo_dir="local-${temp_gnofract4d_filter_repo}-${temp_gnofract4d_filter_name}" 

./"${build_temp_script}" \
	-r "${temp_gnofract4d_rebase_repo}"   \
	-n "${temp_gnofract4d_rebase_name}"   \
	-u "${temp_gnofract4d_rebase_dir}"    \
	-b "${temp_gnofract4d_rebase_out_branch}"

unset build_temp_repo_dir;

export filter_repo_dir="${temp_gnofract4d_filter_dir}"
export filter_repo_branch="${temp_gnofract4d_filter_out_branch}"

./"${filter_script}"

unset filter_repo_branch; unset filter_branch;


#########
# Make Rworked Reference Repository
#########

readonly ref_gnofract4d_reworked_repo="reworked"
readonly ref_gnofract4d_reworked_name="${ref_gnofract4d_name}"
readonly ref_gnofract4d_reworked_url="../../${temp_gnofract4d_filter_dir}"
readonly ref_gnofract4d_reworked_branch="master"
readonly ref_gnofract4d_reworked_dir="ref/${ref_gnofract4d_reworked_repo}-${ref_gnofract4d_reworked_name}"
readonly ref_gnofract4d_reworked_out_branch="${ref_gnofract4d_reworked_repo}_${ref_gnofract4d_reworked_branch}"

./"${build_ref_script}" \
	-r "${ref_gnofract4d_reworked_repo}"   \
	-n "${ref_gnofract4d_reworked_name}"   \
	-u "${ref_gnofract4d_reworked_url}"    \
	-b "${ref_gnofract4d_reworked_branch}"


#######
# Check if conversion didn't change files in the HEAD of the branch.
#######

export modern_git_dir="${ref_gnofract4d_dir}"
export reworked_git_dir="${ref_gnofract4d_reworked_dir}"

./"${verify_script}"

unset modern_git_dir; unset reworked_git_dir


#DONE!

