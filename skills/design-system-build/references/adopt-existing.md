# Adopting an existing project (adopt)

Use this when the project already has UI but no system. The goal is to collect scattered values into tokens and shared components without changing what the screens look like, and then continue with the freeze in phase 3.

## Principles

- Existing code already is a system that nobody wrote down. Understand it before deciding what to keep.
- When the code contradicts itself, prefer in this order: a reference page the user names → components already extracted → what most files do. Report every decision with its basis and counts, for example "field spacing: 5 of 6 files use `gap-4`".
- Screens must not change during migration. Any visual change is a migration bug, not a design adjustment.

## 1. Inventory

List the values actually in use, and in how many files each appears:

| Category | What to look for |
|---|---|
| Color | Hex values, color functions, Tailwind palette classes (`bg-*`, `text-*`, `border-*`, `ring-*`, gradients) |
| Typography | Combinations of size, weight, line height and letter spacing |
| Spacing | Common padding, margin and gap values and where they appear |
| Radius | Every `rounded-*` or `border-radius` |
| Shadows | Every `shadow-*` or `box-shadow` |
| Repeated structures | Identical or near-identical class combinations appearing 3 or more times (component candidates) |
| Arbitrary values | Every `[...]` value, marking those that can map to a scale value |

Report the results to the user as tables. This inventory is the basis for every later decision.

## 2. Consolidate

- Group similar values (for example five nearly identical grays); each group maps to one semantic token.
- Turn type sizes into roles; find the spacing base and its multiples.
- List the naming proposal and which old values each token covers, and **ask the user to confirm**.

## 3. Create tokens

- Write the tokens file following [tokens.md](tokens.md). New tokens live alongside the old values for now; do not delete anything yet.
- Write `DESIGN.md` at the same time.

## 4. Extract shared components

- Pick component candidates by repetition and complexity, and let the user decide which to extract.
- Start with the ones with the fewest dependencies, and add stories for each.

## 5. Migrate

1. If Storybook or a page screenshot tool is available, capture a baseline before migrating.
2. Change one file at a time: replace old values with semantic tokens and hand-built structures with shared components.
3. Build after every file and compare with the baseline.
4. When everything is migrated, search to confirm nothing references the old values, then delete them.

## 6. Join the main process

After migration, return to phase 3 in SKILL.md: install the checks, ask the user to confirm and freeze (G3), then continue with phases 4–6. If the project has no `PRODUCT.md`, write it as in phase 1 first, inferring as much as possible from the existing product, because phase 3 needs its page types.

If the user also wants a new visual direction, finish the migration and freeze the current state first, then change things one by one with the `update` process. Do not redesign during migration, or you will not be able to tell a migration bug from an intentional change.
