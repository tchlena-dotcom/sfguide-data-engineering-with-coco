#!/bin/bash
# validate-bash.sh — PreToolUse hook for the bash tool.
# Blocks dbt commands that target production (--target prod / --target=prod / -t prod).

INPUT=$(cat)

# Extract tool_input.command; fall back to the raw payload if jq is unavailable.
if command -v jq >/dev/null 2>&1; then
  CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')
else
  CMD="$INPUT"
fi

if printf '%s' "$CMD" | grep -Eq '(^|[^[:alnum:]_-])dbt([^[:alnum:]_-]|$)|dbt\.cli\.main' &&
   printf '%s' "$CMD" | grep -Eq '(--target|-t)([[:space:]]+|=)["'\'']?prod["'\'']?([^[:alnum:]_-]|$)'; then
  echo "Blocked: direct production dbt runs are not allowed (--target prod). Run against the dev target locally, and deploy to production through the CI/CD pipeline instead." >&2
  exit 2
fi

exit 0
