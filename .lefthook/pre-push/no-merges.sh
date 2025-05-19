#!/bin/bash
#
# Pre-push Git hook to enforce a linear history by disallowing merge commits.
# This script is intended to be used with Lefthook.
#
# Inputs (from Git pre-push hook environment):
# $1: Name of the remote (e.g., "origin").
# $2: URL of the remote.
# Stdin: Lines in the format "<local_ref> <local_sha> <remote_ref> <remote_sha>"

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Script Main Logic ---

# Read each ref being pushed from stdin.
while read -r local_ref local_sha remote_ref remote_sha; do
  # Only process branches (refs/heads/).
  if [[ ! "$local_ref" =~ ^refs/heads/ ]]; then
    continue # Skip non-branch refs (e.g., tags).
  fi

  # Handle branch deletions (local_sha is all zeros).
  if [ "$local_sha" = "0000000000000000000000000000000000000000" ]; then
    continue # Skip branch deletions, nothing to check.
  fi

  is_new_branch=false
  merge_commit_count=0
  branch_name=${local_ref#refs/heads/} # Get the simple branch name

  # Determine if it's a new branch or an update to an existing one.
  if [ "$remote_sha" = "0000000000000000000000000000000000000000" ]; then
    # Scenario B: Pushing a new branch to the remote.
    is_new_branch=true
    # Check all commits on this new branch that are not yet on any ref on the target remote.
    # The `|| true` handles cases where rev-list might error if no such commits exist (though --count should prevent this).
    merge_commit_count=$(git rev-list --merges --count "$local_sha" --not --remotes="$1") || true
  else
    # Scenario A: Updating an existing remote branch.
    # Check commits in the range being pushed (remote_sha..local_sha).
    # The `|| true` handles cases where rev-list might error if the range is invalid (e.g. remote_sha is not an ancestor).
    merge_commit_count=$(git rev-list --merges --count "${remote_sha}..${local_sha}") || true
  fi

  # Evaluate merge commit count and report errors.
  if [ "$merge_commit_count" -gt 0 ]; then
    error_message=""
    guidance_message=""

    if [ "$is_new_branch" = true ]; then
      error_message="Error: Push rejected for new branch '${branch_name}'. Found ${merge_commit_count} merge commit(s)."
      guidance_message="Guidance: New branches must have a linear history. Please rebase your changes locally (e.g., 'git rebase -i <commit_before_merges>') and try pushing again."
    else
      remote_branch_name=${remote_ref#refs/heads/}
      error_message="Error: Push rejected for branch '${branch_name}'. Found ${merge_commit_count} merge commit(s) in the update."
      guidance_message="Guidance: Please rebase your branch onto '${1}/${remote_branch_name}' (e.g., 'git rebase ${1}/${remote_branch_name}') to resolve and maintain a linear history."
    fi

    # Output messages to stderr for visibility.
    echo >&2 "$error_message"
    echo >&2 "$guidance_message"
    exit 1 # Abort the push.
  fi
done

# If all checks passed for all refs.
exit 0 # Allow the push.
