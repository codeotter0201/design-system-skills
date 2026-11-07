<!--
Template: fill in every TODO(design), then paste this block into the project's AGENTS.md.
If the project uses CLAUDE.md, reference AGENTS.md from it or paste the same block.
design-system-review reads the paths from this block.
-->

## Design system

The UI of this project is governed by a design system. Before writing any code users will see, read:

- `PRODUCT.md`: product, users, brand personality, page types
- `DESIGN.md`: rules, rationale, components and page type rules
- The tokens file: the single source of every value

### Paths

- Tokens file: `TODO(design)` (for example `src/styles/tokens.css`)
- Shared components: `TODO(design)` (for example `src/components/ui/`)
- Stories: `*.stories.tsx` next to each component
- Check script: `scripts/design-check.sh`
- Visual regression: `TODO(design)` (for example `tests/visual.spec.ts`)

### Rules

1. Colors, type, spacing, radius and shadows use semantic tokens only (for example `bg-primary`, `text-muted-foreground`, `p-4`). No hex values, no Tailwind default palette classes (`bg-blue-500`, `text-white`), no arbitrary values (`p-[13px]`).
2. Use shared components first. When one is missing, propose adding it; do not hand-build it inside a page.
3. Every page belongs to a page type and follows that type's rules in the Page Types section of `DESIGN.md`.
4. New shared components have stories covering every applicable state.
5. When tokens change, update `DESIGN.md` too. Values that differ between the two are errors.
6. `DESIGN.md` describes the current state only; describe changes in commits and pull requests.
7. Run `scripts/design-check.sh` before committing.
8. When the `design-system-build` and `design-system-review` skills are available, use the first to build UI and the second to review changes.
