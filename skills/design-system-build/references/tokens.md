# Tokens: structure, naming and rules

The default stack is Tailwind CSS v4 with semantic variables compatible with shadcn/ui. Other stacks keep the same layers and names and change only the implementation.

## Three layers

| Layer | Purpose | Who may reference it | Example |
|---|---|---|---|
| Reference | Raw palette and raw sizes | Only the semantic layer inside the tokens file | `--ref-ink-900` |
| Semantic | Values named by purpose | The only layer components and pages may use | `--primary`, `--muted-foreground` |
| Component | Values one component needs to tune on its own | Only that component | `--button-height` |

- Do not create the component layer by default. Add a component token only when a component must be tuned independently of the semantic layer, and record it in the Components section of `DESIGN.md`.
- A page that uses the reference layer directly bypasses the system and is always a violation.

## Color

Semantic color names are compatible with shadcn/ui, so shadcn components work unchanged:

| Role | Names |
|---|---|
| Page and surfaces | `background`, `foreground`, `card`, `card-foreground`, `popover`, `popover-foreground` |
| Interaction | `primary`, `primary-foreground`, `secondary`, `secondary-foreground`, `accent`, `accent-foreground` |
| Secondary information | `muted`, `muted-foreground` |
| Status | `destructive`, `destructive-foreground`, `success`, `success-foreground`, `warning`, `warning-foreground` |
| Borders and focus | `border`, `input`, `ring` |
| Data visualization | `chart-1` to `chart-5` |

Rules:

- Every surface color has a matching foreground color (`*-foreground`).
- Contrast: at least 4.5:1 for body text, at least 3:1 for large text and UI component boundaries. Check both light and dark mode.
- Dark mode gets its own semantic values; it is not an inversion of light mode.
- Brand color usage varies by page type (see [page-types.md](page-types.md)), but there is only one set of brand colors.
- Optionally add `--color-*: initial;` to `@theme` to turn off Tailwind's default palette, so classes like `bg-blue-500` are never generated. If you do, check whether values like `white` and `black` are still needed and add them to the semantic layer if so.

## Typography

Name type sizes by role, not by size: for example `display`, `headline`, `title`, `body`, `body-sm`, `label`, `caption`.

- Tailwind v4 uses the `--text-*` namespace, which produces utilities like `text-title`. Each role can also define `--text-{name}--line-height`, `--text-{name}--letter-spacing` and `--text-{name}--font-weight`.
- Derive the steps from one ratio (a modular scale): information-dense interfaces use a smaller ratio (about 1.125–1.2), expressive pages a larger one (about 1.25–1.333 or more). When page types need different ratios, cover them with extra roles (for example `display`) instead of a second scale.
- Body text meant for reading is at least 16px.
- Keep the number of type roles visible on one screen to about 4–5.
- If the project uses `tailwind-merge`, register custom type roles in the `font-size` group with `extendTailwindMerge`. Otherwise `cn("text-primary", "text-title")` wrongly drops one of them.

## Spacing

- Tailwind v4 spacing utilities are multiples of `--spacing` (`p-4` is `calc(var(--spacing) * 4)`). Choosing `--spacing` sets the rhythm of the whole project.
- Use multiples on the scale only; never arbitrary values (`p-[13px]`).
- In the Layout section of `DESIGN.md`, record the multiple used for each rhythm role: field to field, last field to the action row, section to section, page padding, card padding.
- Decide once, for the whole project, which side owns a given gap (the parent's `gap`, a child's `margin` or its own `padding`).

## Density

When the same components serve pages of different density (a dashboard is tighter than a landing page), switch density with scoped tokens; the components do not change:

```css
[data-density="compact"] {
  --spacing: TODO(design);
  --text-body: TODO(design);
}
```

- Values that need to be overridable (`--spacing`, `--text-*`) must live in `@theme` (without `inline`). `@theme inline` bakes the value into the utility, so scoped overrides stop working.
- Color mappings belong in `@theme inline` because they reference variables in `:root` and `.dark` that resolve at runtime.

## Radius, shadows and depth

- Radius: one `--radius` base, with the other steps derived from it. Vary the shape language by level (for example a larger radius outside, a smaller one inside); do not give everything the same radius.
- Shadows: 2–4 levels, each with a meaning (raised, overlay, modal). Shadows are not decoration.
- z-index: one fixed scale (for example dropdown, sticky, overlay, modal, toast), recorded in `DESIGN.md`.

## Motion

- Define 2–3 durations (fast, base, slow) and 1–2 easing curves.
- Motion triggered by the user (expanding, confirming, switching) is the default. Motion that is not triggered by the user is reserved for one deliberate moment.
- Always respect `prefers-reduced-motion`.

## Mapping to DESIGN.md

| Tokens file | DESIGN.md YAML |
|---|---|
| Semantic colors in `:root` (light mode) | `colors.<same name>` |
| `--text-<role>` with its line-height, letter-spacing and font-weight | `typography.<role>` |
| `--radius-*` | `rounded.<step>` |
| `--spacing` and rhythm roles | `spacing.<role>` |
| Component tokens or key component styles | `components.<component>` |

- Names are identical on both sides (kebab-case) so the review can compare them automatically.
- Dark mode values go in the prose of the Colors section of `DESIGN.md`; the YAML holds light mode only.

## Not allowed

- Color literals or color functions outside the tokens file (hex, `rgb()`, `hsl()`, `oklch()`).
- Tailwind default palette classes (`bg-blue-500`, `text-gray-600`, `bg-white`).
- Arbitrary values (`p-[13px]`, `text-[15px]`, `bg-[#fff]`). Add a token when a new value is needed.
- References to the reference layer (`--ref-*`) outside the tokens file.
- `font-family` written directly in components or pages.
