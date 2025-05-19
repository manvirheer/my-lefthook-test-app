#!/usr/bin/env bash
# Abort if a merge is in progress (MERGE_HEAD exists).
if git rev-parse --verify -q MERGE_HEAD >/dev/null; then
  echo "⛔  Merge commits are not allowed. Rebase your branch instead."
  echo "    Example: git fetch origin && git rebase origin/dev"
  exit 1
fi
exit 0
