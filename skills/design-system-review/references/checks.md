# Checks

The commands below use `rg` (ripgrep); without it, use `grep -rnE`. Paths come from the Design system block in the project's `AGENTS.md` / `CLAUDE.md`.

## 0. Deterministic checks

| Check | Command | What it catches |
|---|---|---|
| design-check | `scripts/design-check.sh` | Hex values and color functions outside the tokens file, Tailwind default palette classes, arbitrary values, leftover `TODO(design)`, colors that differ between `DESIGN.md` and the tokens file |
| DESIGN.md lint | `npx @google/design.md lint DESIGN.md` | Broken token references, contrast, section order, unreferenced colors |
| DESIGN.md diff | See B below | Added, removed and modified tokens |
| impeccable | `npx impeccable detect --json <path>` | Common AI-default styles, cramped spacing, skipped heading levels and more |
| Visual regression | `npx playwright test visual.spec.ts` | Story screenshots that differ from the baseline |

If the project has no `scripts/design-check.sh`, at least search by hand:

```bash
# Hex values and color functions outside the tokens file
rg -n --glob '!<tokens file>' -e '#[0-9a-fA-F]{3,8}\b' -e '\b(rgba?|hsla?|oklch|oklab|lab|lch)\(' src
# Tailwind default palette classes
rg -n '\b(bg|text|border|ring|fill|stroke|from|via|to|outline|divide|decoration|placeholder|caret|accent)-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-[0-9]{2,3}\b' src
# Arbitrary values (matches ending in ":" are variants such as data-[state=open]: and do not count)
rg -no '[a-z][a-z0-9-]*-\[[^\]]+\]:?' src | rg -v '\]:$'
```

## A. Code → rules

Check every changed file for:

- **Bypassed tokens**: hardcoded colors, Tailwind default palette classes, arbitrary values, inline styles with literal values, `font-family` written directly.
- **Reference layer usage**: `--ref-*` outside the tokens file.
- **Bypassed components**: a page hand-builds something a shared component already provides (for example the project has `Button`, but the page writes `<button className="...">`).
- **Rhythm**: spacing multiples that differ from the rhythm roles in the Layout section of `DESIGN.md`; one kind of gap written as `gap` in one place and `margin` in another.
- **Page type rules**: the page's density, type usage, brand color usage and motion follow the rules for its page type in `DESIGN.md`.
- **New shared components**: they have stories, every applicable state, and an entry in the Components section of `DESIGN.md`.
- **Right value, wrong source**: a hand-written value that happens to equal a token. It is correct today, but it breaks as soon as the token changes and gets copied into the next page. Report it as P2.

## B. Rules → code

Run only when the tokens file or `DESIGN.md` changed.

1. Extract the previous version:

   ```bash
   git show <base>:DESIGN.md > /tmp/DESIGN.before.md
   git show <base>:<tokens file> > /tmp/tokens.before.css
   ```

2. Compare tokens:

   ```bash
   npx @google/design.md diff /tmp/DESIGN.before.md DESIGN.md
   ```

   Without the CLI, run `git diff <base> -- DESIGN.md <tokens file>` and list additions, removals and modifications by hand.

3. **Removed or renamed tokens**: search every usage (`var(--name)`, `bg-name`, `text-name`, `border-name` and so on). There must be none left.
4. **Modified values**: list the affected components and pages. Visual regression differences should appear only there.
5. **Added tokens**: something in this change must use them; otherwise report them as unused.
6. **Documents**: places in the `DESIGN.md` prose that mention these values were updated too.

## C. Documents ↔ tokens

- Colors: `design-check.sh` compares `colors` in the `DESIGN.md` YAML with the same-named variables in `:root` of the tokens file.
- Typography, radius and spacing: compare `typography`, `rounded` and `spacing` in the YAML with `--text-*`, `--radius-*` and `--spacing` in the tokens file by hand.
- Components: every component in the Components section of `DESIGN.md` exists in code, and every component in the shared components directory is listed in `DESIGN.md`.
- Unused tokens: count the usages of every semantic token and report the ones with zero as info.

## D. Judgment checks

- **New pattern?** Compare new structures with existing components. If purpose and behavior match, the existing component should be reused.
- **Extract a component?** When the same structure appears 3 or more times, propose a shared component.
- **Signature element**: it appears only where `DESIGN.md` says. Using it everywhere dilutes it.
- **Voice and wording**: copy matches the brand personality in `PRODUCT.md`, and one action keeps one name from the button to the result message.
- **States**: new data regions have loading, empty and error states.
- **Accessibility**: focus styles, labels, contrast in both light and dark mode.
- **Screenshots**: when possible, capture the changed pages at 375 and 1280 px wide in light and dark mode, and compare them with other pages of the same type.
