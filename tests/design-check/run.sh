#!/usr/bin/env bash
# Regression tests for design-check.sh: "good" must pass and "bad" must report the expected findings.
# Usage: tests/design-check/run.sh [bash binary] (default: bash; pass /bin/bash to test the bash 3.2 that ships with macOS)
set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$HERE/../../skills/design-system-build/assets/scripts/design-check.sh"
SHELL_BIN="${1:-bash}"
FAIL=0

check() {
  local name="$1" expected_code="$2" out code
  shift 2
  out="$(cd "$HERE/fixtures/$name" && "$SHELL_BIN" "$SCRIPT" 2>&1)"
  code=$?
  if [ "$code" -ne "$expected_code" ]; then
    echo "FAIL $name: exit code $code, expected $expected_code"
    echo "$out" | sed 's/^/  | /'
    FAIL=1
    return
  fi
  for pattern in "$@"; do
    if [[ "$pattern" == !* ]]; then
      if printf '%s\n' "$out" | grep -qF -- "${pattern#!}"; then
        echo "FAIL $name: output must not contain \"${pattern#!}\""; FAIL=1
      fi
    elif ! printf '%s\n' "$out" | grep -qF -- "$pattern"; then
      echo "FAIL $name: output is missing \"$pattern\""; FAIL=1
    fi
  done
  echo "ok   $name"
}

check good 0 "design-check: passed"
check bad 1 \
  "✗ No hex colors outside the tokens file (1)" \
  "✗ No color functions outside the tokens file (1)" \
  "✗ No Tailwind default palette classes (2)" \
  "✗ No Tailwind arbitrary values (1)" \
  "✗ No leftover TODO(design) (1)" \
  "colors.primary differs: DESIGN.md = #1d4ed8, tokens = #2563eb" \
  "colors.accent has no --accent in :root of the tokens file" \
  "!colors.background" \
  "!#faq" \
  "!bg-[#fafafa]"

exit "$FAIL"
