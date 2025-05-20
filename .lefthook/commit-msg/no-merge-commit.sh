#!/usr/bin/env bash
# no-merge-commit.sh — disallow merge commits in your branch

if git rev-parse --verify -q MERGE_HEAD >/dev/null; then
  echo "⛔  Merge commit detected!"
  echo "    Please rebase first: git fetch origin && git rebase origin/dev"
  echo "    Abort this merge:  git merge --abort"
  exit 1
fi

# nothing to do if no merge in progress
exit 0
