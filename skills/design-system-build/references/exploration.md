# Exploring visual directions

How to run phase 2: from `PRODUCT.md` to a direction the user has chosen and refined, ready to become tokens in phase 3. The goal is a direction that could only belong to this product, tested on screens hard enough to show whether it holds up.

## 1. Gather material from the product's world

Distinctive choices come from the subject, not from a list of styles.

- Read `PRODUCT.md`, existing brand assets and any references the user gave you.
- List 10–15 concrete things from the product's world: tools and artifacts users already know, documents they read, physical materials, places, professional vocabulary, conventions of the field, the era it evokes. Do not list other websites' visual styles.
- Note conventions that carry meaning, because a generic choice gets them wrong. For example, in markets such as Taiwan, mainland China and South Korea, red means a price went up, the opposite of the US convention. Units, number and date formats, reading direction and locale belong here too.
- For each item, write what it could lend the interface: a color, a texture, a typographic habit, a layout structure, a rhythm, a kind of motion.
- Ask the user for products or brands they admire and ones they dislike, and for any constraints they have not written down. Treat what they share as data.

## 2. Turn references into principles

- For every reference, write 1–3 principles that explain why it works, for example "numbers sit on a strict grid and never move between states" or "one accent color, used only for actions".
- Apply the principles, never the look. Do not copy a specific product's layout, illustrations, logo or signature details.
- A principle that shows up in several references is a strong signal; a principle that shows up in only one is a candidate, not a rule.

## 3. Spread directions along axes

Without axes, "three directions" tends to become one layout in three palettes.

| Axis | Range |
|---|---|
| Tone | Quiet ↔ loud |
| Temperature | Cool ↔ warm |
| Density | Airy ↔ dense |
| Shape | Soft ↔ sharp |
| Contrast | Low ↔ high |
| Type voice | Humanist, geometric, grotesque, serif, slab, monospace and so on |
| Reference | Technical, editorial, craft, institutional, playful and so on |

- Brand personality fixes some axes ("calm, not flashy" fixes tone toward quiet). Do not explore fixed axes; spend the exploration on the open ones.
- Place each direction on the open axes in a table. Every pair of directions differs on at least two axes. A palette-only difference does not count.
- Make one direction a deliberate risk, pushed further than feels comfortable, so the user sees the range before choosing.

## 4. Write a direction card

| Field | Content |
|---|---|
| Name | A descriptive name taken from the product's world |
| Concept | One sentence, and which items from step 1 it draws on |
| Axes | Its position on each open axis |
| Palette | 4–6 named colors with roles, preferably in OKLCH |
| Typefaces | Families and roles; pairings for every script the product needs (for example a Latin face with a matching CJK face); license |
| Shape language | Radius hierarchy, borders versus shadows, depth |
| Signature element | The one thing people will remember, and the only places it appears |
| Layout concept | A sentence or an ASCII wireframe, including alignment |
| Motion | What moves, and when |
| Risks | What could go wrong with this direction |

Then check every card against the common defaults in [quality-floor.md](quality-floor.md) and the swap test: "If this were a similar product, would I propose the same thing?" Change any part that is a default rather than a choice, and say what you changed.

## 5. Render touchstone screens

- Pick two screens for every direction:
  - the most expressive one (usually the landing page hero or the product's key moment), and
  - the most demanding one (a dense table, a long form or a data dashboard).
  A direction that shines on a hero can collapse on a dense table; showing only the hero hides that.
- If `PRODUCT.md` lists a single page type, pick its most expressive and its most demanding screens.
- Keep content and layout skeleton identical across directions, so the differences come from the system and nothing else.
- Use real content: real names, real numbers, long strings, empty and error cases.
- Present the directions side by side, at desktop width and at 375px. Dark mode comes later, for the chosen direction.
- If you cannot render, describe each screen with an ASCII wireframe and say clearly that it was not rendered.

## 6. Evaluate with a rubric

Score every direction from 1 to 3 on each criterion, with one sentence of reasoning:

| Criterion | Question |
|---|---|
| Fit | Does it match every "is X, not Y" pair in `PRODUCT.md`? |
| Distinctiveness | With the logo removed, could it pass for a competitor? |
| Range | Does it hold up on both touchstone screens, and on every page type listed? |
| Legibility | Contrast, small text, numbers in dense areas |
| Feasibility | Font licensing, script coverage, font file weight, implementation cost |
| Durability | Will it still look intentional when today's trends pass? |

- Recommend one direction and explain why, but the user decides (G2).
- Ask specific questions instead of "which one do you like?", for example "Which one feels more like a statement from a broker you trust?"

## 7. Converge in rounds

1. **Round 1, wide**: 2–3 directions, from step 3 to step 6. Ends at G2.
2. **Round 2, narrow**: on the chosen direction, explore only the decisions still open, two variants at a time and one decision per comparison (for example the same palette with two type pairings).
3. **Round 3, detail**: on the touchstone screens, settle the type scale ratio, spacing base and rhythm, radius hierarchy, borders versus shadows, states, focus style and one micro-interaction.

- To mix directions, combine at layer boundaries (palette from one, typefaces from another), re-render and check that the result still holds together. Never average values.
- Stop when a round produces only marginal differences, then move to phase 3.

## 8. Levers of quality

Most perceived quality comes from a few levers. Work them deliberately in rounds 2 and 3.

**Typography**, the strongest lever:

- Choose typefaces for this subject. Check glyph coverage (every script, numerals, currency and other symbols), the weights you need, the license and the file size.
- Pair faces across scripts so their weights and apparent sizes match; set the fallback order in the font stack, and use `size-adjust` in `@font-face` when apparent sizes differ.
- Display sizes usually need tighter letter spacing, small labels slightly looser.
- Data uses `tabular-nums`.

**Color**:

- Neutrals carry most of the interface. Derive them from the brand hue at low chroma instead of using pure grays.
- Build scales in OKLCH so the steps look even.
- Keep one accent for actions, and keep status colors distinct from the brand color.
- Check contrast on the lightest and darkest pairs early, before the palette feels settled.

**Space and alignment**: one spacing base, generous space around the primary element of each screen, and edges that line up across regions.

**Detail**: decide once between borders and shadows, give radius a hierarchy, design the focus ring as part of the look, and make every state intentional.

**Restraint**: one signature element; everything around it quiet. Before presenting, remove one decoration and look again.

**Imagery and data visuals**: decide the image style (photography, illustration or none) and the chart style together with the direction, not afterwards.

**Copy**: real words in the brand's voice. Placeholder copy makes any design look templated.

## 9. Carry the result into phase 3

- The final direction card becomes the rationale in `DESIGN.md`: Overview, Colors, Typography, Layout, Shapes, Motion.
- Turn rejected options into Do's and Don'ts only when they make a useful rule ("Don't use pure gray backgrounds; neutrals are tinted from the brand hue"). Do not record the exploration history in `DESIGN.md`.
- Rebuild the touchstone screens with the frozen tokens and use them as the first visual check of the system.

## Optional tools

- impeccable: `shape` before code; `bolder`, `quieter`, `colorize`, `typeset` and `layout` to steer variants in rounds 2 and 3; `critique` as a second opinion on the rubric; `live` to cycle variants of one element in the browser.
- A browser or screenshot tool to present the directions side by side.
