# Hand-off between the skills

What `design-system-build` gives this skill, what this skill gives a partner, and what comes back. A fixed package is what lets the visual work change partners without changing the rest of the design system.

## In: from design-system-build

| Item | Source |
|---|---|
| Product, users, primary tasks | `PRODUCT.md` |
| Brand personality, as "is X, not Y" pairs | `PRODUCT.md` |
| Page types and their rules | `PRODUCT.md`, and `DESIGN.md` when it exists |
| Constraints: stack, accessibility standard, languages and scripts, performance | `PRODUCT.md` |
| What must not be claimed or invented | `PRODUCT.md`, Constraints and Content sources |
| References the user admires and dislikes | `PRODUCT.md`, Content sources |
| The two touchstone screens and their real content | Chosen in phase 2: the most expressive screen and the most demanding one |
| The frozen tokens and components, after gate G3 | The tokens file, `DESIGN.md` |

Pass a partner the same items in whatever form it reads. When a partner has its own context file format, let it read `PRODUCT.md` as it is; do not rewrite `PRODUCT.md` into the partner's format.

## Out: back to design-system-build

### Direction card

One per direction shown, and a final one for the direction chosen.

| Field | Content |
|---|---|
| Name | A descriptive name taken from the product's world |
| Concept | One sentence: the idea the product owns, and the category default it refuses |
| Source | What in the product's world it draws on |
| Palette | 4–6 named colors with roles, preferably in OKLCH, and the color strategy (how much of the surface each owns) |
| Typefaces | Families and roles for every script the product needs, with licenses |
| Shape language | Radius hierarchy, borders versus shadows, depth |
| Signature element | The one thing people will remember, and the only places it appears |
| Layout concept | The first viewport of the most expressive screen: what is where, at what scale, and where the primary action sits |
| Motion | The one authored moment, and what else is allowed to move |
| Risks | What could go wrong with this direction |
| Selection | How this direction was selected over the others, and by whom |

### Touchstone screens

- The two screens, rendered, for the chosen direction.
- Screenshots at 375, 768 and 1280 px.
- The content used, with synthetic data labeled as synthetic.

### Review

- Who reviewed the screens, and that they did not build them.
- Findings fixed, and findings left open.

### Not verified

Every state, width, mode or behavior that was not looked at.

### Working files

Paths of anything the partner left in the project, and whether the user chose to commit or ignore them.

## What design-system-build does with it

- The final direction card becomes the rationale in `DESIGN.md`: Overview, Colors, Typography, Layout, Shapes, Motion.
- Palette, typefaces, shape language and motion become reference and semantic tokens in phase 3.
- The touchstone screens are rebuilt with the frozen tokens and become the first visual check of the system.
- Rejected directions are not recorded in `DESIGN.md`; a rejected option becomes a Do or Don't only when it makes a useful rule.

## After the freeze

After gate G3 this skill works inside the system:

- It uses semantic tokens and shared components only.
- A look that needs a new value, component or page type is returned as a proposal for the `extend` or `update` process of `design-system-build`, with the screens that show why.
- A partner's suggestion that contradicts `DESIGN.md` is a proposal, not an edit.
