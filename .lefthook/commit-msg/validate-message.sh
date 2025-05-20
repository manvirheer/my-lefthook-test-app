#!/usr/bin/env bash
#
FILE="$1"
FIRST_LINE="$(head -n1 "$FILE")"

# Pattern: <Type>: <lowercase summary>
PATTERN='^(Task|Feature|Bug|Fix|Test|Refactor):[[:space:]][a-z0-9].+$'

if [[ ! "$FIRST_LINE" =~ $PATTERN ]]; then
  echo -e "\e[31m⛔  Invalid commit header:\e[0m \"$FIRST_LINE\""
  echo "👉  Use one of: Task|Feature|Bug|Fix|Test|Refactor, followed by a semi-color and then the lowercase summary."
  echo "💡  Example: \"Fix: handle null input in auth service\""
  exit 1
fi

exit 0
