#!/usr/bin/env bash
# design-check.sh: deterministic design system checks for local runs and CI.
#
# Checks
#   1. Hex colors and color functions (rgb(), hsl(), oklch(), ...) outside the tokens file
#   2. Tailwind default palette classes (bg-blue-500, text-white, ...)
#   3. Tailwind arbitrary values (p-[13px]; variants such as data-[state=open]: do not count)
#   4. Leftover TODO(design) placeholders
#   5. DESIGN.md YAML values that differ from the tokens file: colors, typography, rounded, spacing
#      (spacing roles without their own token must be whole multiples of spacing.base)
#
# Usage
#   scripts/design-check.sh [--src <dir>]... [--tokens <file>] [--design <file>] [--product <file>] [--warn-only]
#   Defaults: --src src --tokens src/styles/tokens.css --design DESIGN.md --product PRODUCT.md
#
# To exempt a single line, add design-check-ignore to it with a reason.
# The tokens file is read from :root and @theme blocks, one declaration per line.
# Exit codes: 0 pass; 1 findings (0 with --warn-only); 2 bad arguments or paths.

set -euo pipefail

SRC_DIRS=()
TOKENS="src/styles/tokens.css"
DESIGN="DESIGN.md"
PRODUCT="PRODUCT.md"
WARN_ONLY=0

usage() {
  sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
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

# Informational lines: shown, but not counted as findings
note() {
  local title="$1" body="$2"
  [ -z "$body" ] && return
  printf 'ℹ %s\n' "$title"
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

# 5. DESIGN.md YAML ↔ tokens file
# Prints findings as plain lines and informational lines prefixed with "INFO ".
value_sync() {
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
    function isnum(s) { return s ~ /^-?[0-9]*\.?[0-9]+$/ }
    # A length in px, or "" when it is not a px or rem length
    function topx(s) {
      s = tolower(trim(s))
      if (s ~ /^-?[0-9]*\.?[0-9]+px$/) return substr(s, 1, length(s) - 2) + 0
      if (s ~ /^-?[0-9]*\.?[0-9]+rem$/) return (substr(s, 1, length(s) - 3) + 0) * 16
      return ""
    }
    # Comparable form: px for px/rem lengths, fixed decimals for numbers, normalized text otherwise
    function canon(s,   p, u, n) {
      s = tolower(trim(s)); gsub(/[[:space:]]+/, " ", s); gsub(/\( /, "(", s); gsub(/ \)/, ")", s)
      if (s ~ /^#[0-9a-f][0-9a-f][0-9a-f]$/) s = "#" substr(s,2,1) substr(s,2,1) substr(s,3,1) substr(s,3,1) substr(s,4,1) substr(s,4,1)
      p = topx(s); if (p != "") return sprintf("%.4fpx", p)
      if (isnum(s)) return sprintf("%.4f", s + 0)
      if (s ~ /^-?[0-9]*\.?[0-9]+(em|%)$/) { u = s; sub(/^-?[0-9]*\.?[0-9]+/, "", u); n = substr(s, 1, length(s) - length(u)); return sprintf("%.4f", n + 0) u }
      return s
    }
    # Replace var(--x) with the value of --x; "" when a reference cannot be resolved
    function subst(v, depth,   s0, l0, ref, rv, guard) {
      if (depth > 10) return ""
      for (guard = 0; guard < 20 && match(v, /var\(--[A-Za-z0-9_-]+\)/); guard++) {
        s0 = RSTART; l0 = RLENGTH
        ref = substr(v, s0 + 6, l0 - 7)
        if (!(ref in tok)) return ""
        rv = subst(tok[ref], depth + 1)
        if (rv == "") return ""
        v = substr(v, 1, s0 - 1) rv substr(v, s0 + l0)
      }
      return v
    }
    # Evaluate calc(a op b) for px/rem lengths; "" when it cannot be evaluated
    function evalcalc(v,   inner, parts, n, pa, pb) {
      v = trim(v)
      if (v !~ /^calc\(.*\)$/) return v
      inner = trim(substr(v, 6, length(v) - 6))
      n = split(inner, parts, /[[:space:]]+/)
      if (n != 3) return ""
      pa = topx(parts[1]); pb = topx(parts[3])
      if (parts[2] == "+" && pa != "" && pb != "") return (pa + pb) "px"
      if (parts[2] == "-" && pa != "" && pb != "") return (pa - pb) "px"
      if (parts[2] == "*" && pa != "" && isnum(parts[3])) return (pa * parts[3]) "px"
      if (parts[2] == "*" && pb != "" && isnum(parts[1])) return (pb * parts[1]) "px"
      if (parts[2] == "/" && pa != "" && isnum(parts[3]) && parts[3] + 0 != 0) return (pa / parts[3]) "px"
      return ""
    }
    function value(name,   v) {
      v = subst(tok[name], 0)
      if (v == "") return ""
      return evalcalc(v)
    }
    function compare(label, dv, tname,   tv) {
      if (!(tname in tok)) { printf "%s: %s has no --%s in the tokens file\n", design, label, tname; return }
      if (tok[tname] ~ /TODO\(design\)/) return
      tv = value(tname)
      if (tv == "" || tv ~ /var\(|calc\(|color-mix\(/) { printf "INFO %s: %s cannot be compared automatically (tokens value is %s)\n", design, label, tok[tname]; return }
      if (canon(dv) != canon(tv)) printf "%s: %s differs: DESIGN.md = %s, tokens = %s\n", design, label, dv, tv
    }

    # Tokens file: :root and @theme blocks
    FILENAME != design {
      if ($0 ~ /^[[:space:]]*(:root|@theme)[^{]*\{/) { inblock = 1; next }
      if (inblock && $0 ~ /\}/) { inblock = 0; next }
      if (inblock && $0 ~ /^[[:space:]]*--[A-Za-z0-9_-]+[[:space:]]*:/) {
        line = $0; sub(/^[[:space:]]*--/, "", line)
        name = line; sub(/[[:space:]]*:.*/, "", name)
        val = line; sub(/^[^:]*:/, "", val); sub(/;.*$/, "", val)
        tok[name] = trim(val)
      }
      next
    }

    # DESIGN.md: YAML front matter
    FNR == 1 && $0 == "---" { infm = 1; next }
    infm && $0 == "---" { infm = 0; next }
    infm {
      if ($0 ~ /^[[:space:]]*(#.*)?$/) next
      raw = $0; indent = match(raw, /[^ ]/) - 1
      line = trim(raw)
      key = line; sub(/:.*/, "", key)
      val = line; sub(/^[^:]*:/, "", val); val = unquote(val)
      if (indent == 0) { section = (val == "") ? key : ""; role = ""; next }
      if (section == "colors" || section == "rounded" || section == "spacing") {
        if (val != "") { dkey[++n] = section "." key; dval[n] = val }
      } else if (section == "typography") {
        if (indent <= 2) role = (val == "") ? key : ""
        else if (role != "" && val != "") { dkey[++n] = "typography." role "." key; dval[n] = val }
      }
    }

    END {
      base = ""
      for (i = 1; i <= n; i++) if (dkey[i] == "spacing.base") base = dval[i]
      if (base == "" && ("spacing" in tok)) base = value("spacing")

      for (i = 1; i <= n; i++) {
        k = dkey[i]; dv = dval[i]
        if (dv == "" || dv ~ /TODO\(design\)/) continue
        split(k, part, ".")
        if (part[1] == "colors") {
          name = part[2]
          compare(k, dv, ((name in tok) || !(("color-" name) in tok)) ? name : "color-" name)
        } else if (part[1] == "rounded") {
          compare(k, dv, "radius-" part[2])
        } else if (part[1] == "spacing") {
          if (part[2] == "base") compare(k, dv, "spacing")
          else if (("spacing-" part[2]) in tok) compare(k, dv, "spacing-" part[2])
          else {
            pv = topx(dv); pb = topx(base)
            if (pv == "" || pb == "" || pb == 0) { printf "INFO %s: %s cannot be checked against the spacing base\n", design, k; continue }
            r = pv / pb
            if (r - int(r) > 0.0001 && int(r) + 1 - r > 0.0001) printf "%s: %s (%s) is not a whole multiple of the spacing base (%s)\n", design, k, dv, base
          }
        } else if (part[1] == "typography") {
          role = part[2]; prop = part[3]
          if (prop == "fontFamily") {
            fam = dv; sub(/,.*/, "", fam); fam = unquote(fam)
            found = 0
            for (t in tok) if (t ~ /^font-/ && index(tolower(tok[t]), tolower(fam)) > 0) found = 1
            if (!found) printf "%s: %s \"%s\" is not in any --font-* token\n", design, k, fam
          }
          else if (prop == "fontSize") compare(k, dv, "text-" role)
          else if (prop == "lineHeight") compare(k, dv, "text-" role "--line-height")
          else if (prop == "letterSpacing") compare(k, dv, "text-" role "--letter-spacing")
          else if (prop == "fontWeight") compare(k, dv, "text-" role "--font-weight")
        }
      }
    }
  ' "$TOKENS" "$DESIGN"
}
SYNC="$(value_sync)"
report "DESIGN.md values match the tokens file" "$(printf '%s\n' "$SYNC" | grep -v '^INFO ' || true)"
note "Not compared automatically" "$(printf '%s\n' "$SYNC" | grep '^INFO ' | sed 's/^INFO //' || true)"

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
