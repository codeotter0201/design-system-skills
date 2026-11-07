---
version: alpha
name: "TODO(design): system name"
description: "TODO(design): one sentence describing this visual language"
colors:
  background: "TODO(design)"
  foreground: "TODO(design)"
  card: "TODO(design)"
  card-foreground: "TODO(design)"
  popover: "TODO(design)"
  popover-foreground: "TODO(design)"
  primary: "TODO(design)"
  primary-foreground: "TODO(design)"
  secondary: "TODO(design)"
  secondary-foreground: "TODO(design)"
  muted: "TODO(design)"
  muted-foreground: "TODO(design)"
  accent: "TODO(design)"
  accent-foreground: "TODO(design)"
  destructive: "TODO(design)"
  destructive-foreground: "TODO(design)"
  success: "TODO(design)"
  success-foreground: "TODO(design)"
  warning: "TODO(design)"
  warning-foreground: "TODO(design)"
  border: "TODO(design)"
  input: "TODO(design)"
  ring: "TODO(design)"
  chart-1: "TODO(design)"
  chart-2: "TODO(design)"
  chart-3: "TODO(design)"
  chart-4: "TODO(design)"
  chart-5: "TODO(design)"
typography:
  display:
    fontFamily: "TODO(design)"
    fontSize: "TODO(design)"
    fontWeight: "TODO(design)"
    lineHeight: "TODO(design)"
    letterSpacing: "TODO(design)"
  headline:
    fontFamily: "TODO(design)"
    fontSize: "TODO(design)"
    fontWeight: "TODO(design)"
    lineHeight: "TODO(design)"
  title:
    fontFamily: "TODO(design)"
    fontSize: "TODO(design)"
    fontWeight: "TODO(design)"
    lineHeight: "TODO(design)"
  body:
    fontFamily: "TODO(design)"
    fontSize: "TODO(design)"
    fontWeight: "TODO(design)"
    lineHeight: "TODO(design)"
  body-sm:
    fontFamily: "TODO(design)"
    fontSize: "TODO(design)"
    fontWeight: "TODO(design)"
    lineHeight: "TODO(design)"
  label:
    fontFamily: "TODO(design)"
    fontSize: "TODO(design)"
    fontWeight: "TODO(design)"
    lineHeight: "TODO(design)"
  caption:
    fontFamily: "TODO(design)"
    fontSize: "TODO(design)"
    fontWeight: "TODO(design)"
    lineHeight: "TODO(design)"
rounded:
  sm: "TODO(design)"
  md: "TODO(design)"
  lg: "TODO(design)"
  xl: "TODO(design)"
spacing:
  base: "TODO(design)"
  field-gap: "TODO(design)"
  field-to-actions: "TODO(design)"
  card-padding: "TODO(design)"
  section-gap: "TODO(design)"
  page-padding: "TODO(design)"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
  button-secondary:
    backgroundColor: "{colors.secondary}"
    textColor: "{colors.secondary-foreground}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
  input:
    backgroundColor: "{colors.background}"
    textColor: "{colors.foreground}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
  card:
    backgroundColor: "{colors.card}"
    textColor: "{colors.card-foreground}"
    rounded: "{rounded.lg}"
---

<!--
Template notes (delete this comment when done):
- Follows the Google DESIGN.md format (https://github.com/google-labs-code/design.md). Keep the order of the first eight sections.
- The YAML mirrors the tokens file: names identical to the tokens file, values equal to light mode in :root.
- The prose explains why and how; do not restate the YAML numbers.
- Describe the current state only. No changelog; history lives in git.
- When done, run: npx @google/design.md lint DESIGN.md
-->

## Overview

TODO(design): the one-sentence concept of this visual language and how it relates to the product and its users.

**Signature element**: TODO(design): the one thing people will remember, and the only places it appears.

**Brand personality**: see `PRODUCT.md`.

## Colors

TODO(design): the color strategy (the ratio of neutrals to brand color, and where the brand color appears).

- **primary**: TODO(design): purpose and when to use it.
- **accent**: TODO(design)
- **destructive / success / warning**: TODO(design)
- **chart-1 to chart-5**: TODO(design): the ordering rule for data colors, and how they stay distinct from interface colors.

**Dark mode**: TODO(design): the dark mode value of each semantic color and the principles behind the adjustments.

## Typography

TODO(design): why these typefaces, what each type role is for, and the ratio (modular scale).

- **display**: TODO(design): the only places it is used.
- **body**: TODO(design): reading width and line height.
- Numeric columns use `tabular-nums`.

## Layout

TODO(design): grid, maximum content width, alignment.

**Rhythm roles** (matching `spacing` in the YAML):

| Role | Where it is used |
|---|---|
| field-gap | Between form fields |
| field-to-actions | Between the last field and the action row |
| card-padding | Inside cards |
| section-gap | Between sections |
| page-padding | Page padding |

**Who owns a gap**: TODO(design) (for example "gaps between siblings always come from the parent's gap").

**Density**: TODO(design): what changes under `data-density="compact"` and which page types use it.

## Elevation & Depth

TODO(design): how depth is expressed (shadows, borders, background tints) and what each level means.

**z-index**: TODO(design): the order of dropdown, sticky, overlay, modal and toast.

## Shapes

TODO(design): the shape language, including how radius changes by level (outer containers versus inner components) and when borders are used and how thick they are.

## Components

<!-- One subsection per shared component: purpose, variants and when to use each, path. The full set of states lives in Storybook. -->

### Button

- **Purpose**: TODO(design)
- **Variants**: TODO(design)
- **Path**: TODO(design)

## Do's and Don'ts

| Do | Don't |
|---|---|
| TODO(design) | TODO(design) |

## Motion

TODO(design): durations and easing, the kinds of motion allowed, and the signature motion if there is one. `prefers-reduced-motion` is always respected.

## Page Types

<!-- One subsection per page type listed in PRODUCT.md. Fields are described in references/page-types.md of design-system-build. -->

### TODO(design): page type name

- **Primary task**: TODO(design)
- **Density**: TODO(design)
- **Type usage**: TODO(design)
- **Layout**: TODO(design)
- **Brand color usage**: TODO(design)
- **Motion**: TODO(design)
- **Key components**: TODO(design)
- **Required states**: TODO(design)
- **Performance focus**: TODO(design)
- **Common mistakes**: TODO(design)
