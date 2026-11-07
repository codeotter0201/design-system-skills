#!/usr/bin/env bash
# design-check.sh: deterministic design system checks for local runs and CI.
#
# Checks
#   1. Hex colors and color functions (rgb(), hsl(), oklch(), ...) outside the tokens file
#   2. Tailwind default palette classes (bg-blue-500, text-white, ...)
#   3. Tailwind arbitrary values (p-[13px]; variants such as data-[state=open]: do not count)
#   4. Leftover TODO(design) placeholders
#   5. Colors in the DESIGN.md YAML that differ from the same-named variables in :root of the tokens file
#
# Usage
#   scripts/design-check.sh [--src <dir>]... [--tokens <file>] [--design <file>] [--product <file>] [--warn-only]
#   Defaults: --src src --tokens src/styles/tokens.css --design DESIGN.md --product PRODUCT.md
#
# To exempt a single line, add design-check-ignore to it with a reason.
# Exit codes: 0 pass; 1 findings (0 with --warn-only); 2 bad arguments or paths.

set -euo pipefail

SRC_DIRS=()
TOKENS="src/styles/tokens.css"
DESIGN="DESIGN.md"
PRODUCT="PRODUCT.md"
WARN_ONLY=0

usage() {
  sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
  case "$1" in
    --src) SRC_DIRS+=("${2:?--src requires a path}"); shift 2 ;;
    --tokens) TOKENS="${2:?--tokens requires a path}"; shift 2 ;;
    --design) DESIGN="${2:?--design requires a path}"; shift 2 ;;
    --product) PRODUCT="${2:?--product requires a path}"; shift 2 ;;
    --warn-only) WARN_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [ ${#SRC_DIRS[@]} -eq 0 ]; then
  SRC_DIRS=("src")
fi

for dir in "${SRC_DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Source directory not found: $dir (set it with --src)" >&2
    exit 2
  fi
done

strip_dot() {
  printf '%s' "${1#./}"
}
TOKENS_N="$(strip_dot "$TOKENS")"

INCLUDES=(
  --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx'
  --include='*.mjs' --include='*.cjs' --include='*.vue' --include='*.svelte'
  --include='*.astro' --include='*.html' --include='*.mdx'
  --include='*.css' --include='*.scss' --include='*.sass' --include='*.less'
)
EXCLUDES=(
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=dist --exclude-dir=build
  --exclude-dir=out --exclude-dir=.next --exclude-dir=.nuxt --exclude-dir=.svelte-kit
  --exclude-dir=.astro --exclude-dir=storybook-static --exclude-dir=coverage
)

FINDINGS=0

# Search the source, skipping the tokens file and exempted lines. Output: file:line:content
scan() {
  grep -rnIE "${INCLUDES[@]}" "${EXCLUDES[@]}" -e "$1" "${SRC_DIRS[@]}" 2>/dev/null \
    | grep -v 'design-check-ignore' \
    | awk -v t="$TOKENS_N" '{ f = $0; sub(/:.*/, "", f); sub(/^\.\//, "", f); if (f != t) print }' \
    || true
}

report() {
  local title="$1" body="$2" count
  if [ -z "$body" ]; then
    printf '✓ %s\n' "$title"
    return
  fi
  count="$(printf '%s\n' "$body" | grep -c '')"
  FINDINGS=$((FINDINGS + count))
  printf '✗ %s (%s)\n' "$title" "$count"
  printf '%s\n' "$body" | cut -c1-220 | sed 's/^/    /'
}

# 1. Hex colors and color functions
HEX='(^|[^&0-9A-Za-z_])#[0-9A-Fa-f]{3,8}([^0-9A-Za-z_]|$)'
COLOR_FN='(^|[^0-9A-Za-z_-])(rgba?|hsla?|hwb|oklch|oklab|lab|lch)\('
report "No hex colors outside the tokens file" "$(scan "$HEX")"
report "No color functions outside the tokens file" "$(scan "$COLOR_FN")"

# 2. Tailwind default palette
PREFIX='(bg|text|border|border-[xytrblse]|ring|ring-offset|fill|stroke|from|via|to|outline|divide|decoration|placeholder|caret|accent|shadow)'
PALETTE='(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)'
TW_PALETTE="(^|[^0-9A-Za-z_-])${PREFIX}-${PALETTE}-(50|[1-9]00|950)([^0-9A-Za-z_-]|$)"
TW_BW="(^|[^0-9A-Za-z_-])${PREFIX}-(white|black)([^0-9A-Za-z_-]|$)"
report "No Tailwind default palette classes" "$( { scan "$TW_PALETTE"; scan "$TW_BW"; } | sort -u )"

# 3. Arbitrary values (matches ending in ":" are variants and are skipped)
ARB='[a-z][a-z0-9-]*-\[[^]]+\]:?'
arbitrary_hits() {
  local line content
  scan '[a-z][a-z0-9-]*-\[[^]]+\]' | while IFS= read -r line; do
    content="${line#*:*:}"
    if printf '%s\n' "$content" | grep -oE "$ARB" | grep -qvE '\]:$'; then
      printf '%s\n' "$line"
    fi
  done
}
report "No Tailwind arbitrary values" "$(arbitrary_hits)"

# 4. Leftover TODO(design)
todo_hits() {
  local targets=("${SRC_DIRS[@]}")
  [ -f "$DESIGN" ] && targets+=("$DESIGN")
  [ -f "$PRODUCT" ] && targets+=("$PRODUCT")
  [ -f "$TOKENS" ] && targets+=("$TOKENS")
  grep -rnIF "${EXCLUDES[@]}" -e 'TODO(design)' "${targets[@]}" 2>/dev/null | sort -u || true
}
report "No leftover TODO(design)" "$(todo_hits)"

# 5. DESIGN.md colors ↔ :root of the tokens file
color_sync() {
  if [ ! -f "$DESIGN" ]; then
    printf '%s not found (set it with --design)\n' "$DESIGN"
    return
  fi
  if [ ! -f "$TOKENS" ]; then
    printf 'Tokens file %s not found (set it with --tokens)\n' "$TOKENS"
    return
  fi
  awk -v design="$DESIGN" -v q="'" '
    function trim(s) { sub(/^[[:space:]]+/, "", s); sub(/[[:space:]]+$/, "", s); return s }
    function unquote(s,   a, rest, p) {
      s = trim(s); a = substr(s, 1, 1)
      if (a == "\"" || a == q) {
        rest = substr(s, 2); p = index(rest, a)
        if (p > 0) return substr(rest, 1, p - 1)
      }
      sub(/[[:space:]]+#.*$/, "", s)
      return s
    }
    function norm(s) {
      s = tolower(trim(s)); gsub(/[[:space:]]+/, " ", s); gsub(/\( /, "(", s); gsub(/ \)/, ")", s)
      if (s ~ /^#[0-9a-f][0-9a-f][0-9a-f]$/) s = "#" substr(s,2,1) substr(s,2,1) substr(s,3,1) substr(s,3,1) substr(s,4,1) substr(s,4,1)
      return s
    }
    function resolve(name,   v, i, ref) {
      v = tok[name]
      for (i = 0; i < 10; i++) {
        if (v ~ /^var\(--[A-Za-z0-9_-]+\)$/) {
          ref = substr(v, 7, length(v) - 7)
          if (!(ref in tok)) return v
          v = tok[ref]
        } else break
      }
      return v
    }
    FILENAME != design {
      if ($0 ~ /^[[:space:]]*:root[[:space:]]*\{/) { inroot = 1; next }
      if (inroot && $0 ~ /\}/) { inroot = 0; next }
      if (inroot && $0 ~ /^[[:space:]]*--[A-Za-z0-9_-]+[[:space:]]*:/) {
        line = $0; sub(/^[[:space:]]*--/, "", line)
        name = line; sub(/[[:space:]]*:.*/, "", name)
        val = line; sub(/^[^:]*:/, "", val); sub(/;.*$/, "", val)
        tok[name] = trim(val)
      }
      next
    }
    FNR == 1 && $0 == "---" { infm = 1; next }
    infm && $0 == "---" { infm = 0; next }
    infm {
      if ($0 ~ /^colors:[[:space:]]*$/) { incolors = 1; next }
      if (incolors && $0 ~ /^[^[:space:]#]/) incolors = 0
      if (incolors && $0 ~ /^[[:space:]]+[A-Za-z0-9_-]+:/) {
        line = trim($0)
        name = line; sub(/:.*/, "", name)
        val = line; sub(/^[^:]*:/, "", val)
        dname[++n] = name; dval[n] = unquote(val)
      }
    }
    END {
      for (i = 1; i <= n; i++) {
        name = dname[i]; dv = dval[i]
        if (dv == "" || dv ~ /TODO\(design\)/) continue
        if (!(name in tok)) { printf "%s: colors.%s has no --%s in :root of the tokens file\n", design, name, name; continue }
        tv = resolve(name)
        if (tv ~ /TODO\(design\)/) continue
        if (tv ~ /var\(|calc\(|color-mix\(/) { printf "%s: colors.%s cannot be compared automatically (tokens value is %s)\n", design, name, tv; continue }
        if (norm(dv) != norm(tv)) printf "%s: colors.%s differs: DESIGN.md = %s, tokens = %s\n", design, name, dv, tv
      }
    }
  ' "$TOKENS" "$DESIGN"
}
report "DESIGN.md colors match the tokens file" "$(color_sync)"

echo
if [ "$FINDINGS" -eq 0 ]; then
  echo "design-check: passed"
  exit 0
fi
echo "design-check: ${FINDINGS} finding(s) (to exempt a line, add design-check-ignore with a reason)"
if [ "$WARN_ONLY" -eq 1 ]; then
  exit 0
fi
exit 1
