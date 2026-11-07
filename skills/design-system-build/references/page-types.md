# Page types

Different kinds of pages share one brand, one set of tokens and one component library, but each kind has its own page rules. The rules live in the Page Types section of the project's `DESIGN.md`, one subsection per type.

## Layers

| Layer | Contents | Shared across page types? |
|---|---|---|
| Brand core | Primary color, typefaces, shape language, voice | Shared |
| Semantic tokens + components | Button, Input, Card and so on | Shared |
| Page type rules | Density, type usage, layout, motion, color proportions | One set per type |

Write rules per page *type*, not per page. One override file per page drifts as the number of pages grows; a fixed number of types stays manageable.

## Fields for every page type

| Field | Meaning |
|---|---|
| Primary task | What users come to this kind of page to do |
| Density | Comfortable, medium or compact, and the matching `data-density` value |
| Type usage | Which type roles are used, and the largest and smallest |
| Layout | Columns, maximum width, alignment, layout template name |
| Brand color usage | Where the brand color appears and roughly how much of the page it covers |
| Motion | Which motion is allowed |
| Key components | Components this kind of page always uses |
| Required states | Loading, empty, error, long content, no permission and so on |
| Performance focus | For example first paint, font loading, rendering large data sets |
| Common mistakes | What most often goes wrong on this kind of page |

## Landing page

- **Primary task**: make a first impression, explain the product and get people to act.
- **Density**: comfortable, with generous white space.
- **Type usage**: large, expressive headlines; the typeface itself is part of the design.
- **Layout**: sections, one point per section; images and content may bleed to the edge.
- **Brand color usage**: the most of any page type, but still concentrated in one or two places rather than spread evenly across sections.
- **Motion**: one deliberate signature moment (for example the first-screen entrance). Do not fade and slide up every section.
- **Key components**: hero, content sections, call to action, social proof, footer.
- **Required states**: form submitting, success, failure.
- **Performance focus**: first-screen image size, font loading strategy, layout shift (CLS).
- **Common mistakes**:
  - A generic hero such as "big number + small label + gradient"
  - Every section turned into the same rounded card
  - An uppercase eyebrow label above every heading
  - 01 / 02 / 03 numbering on content that is not a sequence

## Blog

- **Primary task**: comfortable long-form reading.
- **Density**: medium.
- **Type usage**: body text is the star. 60–75 characters per line (about 30–40 characters for CJK text) with generous line height; a clear heading hierarchy that does not compete with the body.
- **Layout**: a single reading column; table of contents and supporting information in a sidebar or at the end.
- **Brand color usage**: low, reserved for links, emphasis and a few markers.
- **Motion**: almost none.
- **Key components**: article typography (Tailwind Typography's `prose`, rewritten to reference the project's tokens), code blocks, images with captions, quotes, table of contents, author and date, previous and next post.
- **Required states**: images loading, a category with no posts, no search results.
- **Performance focus**: image sizes and lazy loading, font subsetting (especially important for CJK fonts).
- **Common mistakes**:
  - Using `prose` defaults that have nothing to do with the brand
  - Lines that are too long
  - Code block colors that clash with the rest of the palette

## Dashboard

- **Primary task**: scan data quickly, spot anomalies and act.
- **Density**: compact (`data-density="compact"`).
- **Type usage**: smaller type sizes; numbers always use `tabular-nums`; few heading levels.
- **Layout**: sidebar plus content area on a grid; the most important metrics at the top left.
- **Brand color usage**: minimal. Color is reserved for data and status; the interface itself is mostly neutral.
- **Motion**: only in response to user actions (expanding, sorting, filtering, switching).
- **Key components**: tables, charts, filters, metric cards, pagination, date ranges, sidebar navigation.
- **Required states**: loading (skeletons that reserve layout space), empty (explain how to get started), error (explain how to fix it), partial data failure, no permission, very large data sets.
- **Performance focus**: virtualized long lists, chart redraws, avoiding full-page re-renders.
- **Common mistakes**:
  - Brand colors used as data colors, so data and interface blur together
  - Metric cards that all look the same, with nothing standing out
  - No empty or error states
  - Chart colors that do not map to the `chart-*` tokens

When a data visualization skill is available, hand chart colors and specs to it and write the results back to the `chart-*` tokens.

## Adding other page types

Common additions are docs, settings / forms, auth and checkout. To add one:

1. Add a row to the page types table in `PRODUCT.md`.
2. Add a subsection to Page Types in `DESIGN.md` and fill in every field above.
3. If it needs a new layout template or density, follow the `extend` process.

## One product, several page types

- Keep the header, footer and navigation consistent across page types so users know they are still in the same product.
- When page types live in different apps (for example a marketing site, a blog and a product dashboard in one monorepo), put the tokens, components and Storybook in a shared package that every app consumes.
