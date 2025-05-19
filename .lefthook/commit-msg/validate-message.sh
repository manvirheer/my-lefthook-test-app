#!/usr/bin/env bash
#
FILE="$1"
FIRST_LINE="$(head -n1 "$FILE")"

# Pattern: <Type>: <lowercase summary>
PATTERN='^(Fix|Bug|Docs|Refactor|Test|Task|Chore|PR):[[:space:]][a-z0-9].+$'

if [[ ! "$FIRST_LINE" =~ $PATTERN ]]; then
  echo -e "\e[31m⛔  Invalid commit header:\e[0m \"$FIRST_LINE\""
  echo "👉  Use one of: Fix|Bug|Docs|Refactor|Test|Task|Chore|PR, followed by a lowercase summary."
  echo "💡  Example: \"Fix: handle null input in auth service\""
  exit 1
fi

exit 0
