#!/usr/bin/env bash
# Abort if the commit that is being finalised is a merge commit.
# HEAD exists for everything except the first commit.
if git rev-parse --verify -q HEAD >/dev/null 2>&1; then
  # If HEAD^2 resolves, this commit has a second parent ⇒ it's a merge.
  if git rev-parse --verify -q HEAD^2 >/dev/null 2>&1; then
    echo "⛔  Merge commits are not allowed. Rebase your branch instead."
    echo "    Example: git fetch origin && git rebase origin/dev"
    exit 1
  fi
fi
exit 0
