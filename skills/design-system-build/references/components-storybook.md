# Components and Storybook

Storybook is the component workbench: components are developed apart from pages, with every variant and state laid out at once. It is also the baseline for visual regression and a specification the review can check.

## Scope

- Write stories only for shared components (for example `src/components/ui/`) and layout templates. Pages do not get stories.
- Each story shows exactly one state. No showcase pages.

## Component specification

Every shared component must answer these questions, in the stories next to it and in the Components section of `DESIGN.md`:

| Item | Content |
|---|---|
| Name | Named by structure, not by context ("Card", not "ProductCard") |
| Purpose | One sentence on the need it serves. If you cannot write it, the component may not be needed |
| Anatomy | The parts it is made of |
| Variants | At most 5. More means it should be split into separate components |
| States | See the next section |
| Accessibility | Role, keyboard behavior, what screen readers announce |
| Tokens used | Which semantic tokens it uses |

Deciding whether two things are the same component: if purpose and behavior match, it is one component even when they look different. If they look the same but serve different purposes, they are different components.

## Required states

Pick the states that apply to the component, one story each:

- default
- each variant
- hover and active (static rendering requires `storybook-addon-pseudo-states`)
- focus-visible (trigger it with Tab in a play function)
- disabled
- loading
- error and invalid
- empty (data components)
- long content, very long words, missing optional content
- dark mode
- compact density

## Writing stories

- Use CSF3 with one named export per state. Template: [../assets/storybook/Component.stories.tsx](../assets/storybook/Component.stories.tsx).
- Use real copy in `args`.
- Verify interactions with play functions so stories double as tests.
- Enable `@storybook/addon-a11y`.
- Wrap dark mode and density in a decorator that adds `class="dark"` or `data-density="compact"`, so no particular addon is required.

## Foundations

Create Foundations pages in Storybook for color, typography, spacing, radius and shadows. Render everything from the CSS variables; never restate the values inside the story, or Foundations will drift from the tokens file.

## Visual regression

- Default approach: Playwright reads the `index.json` produced by `storybook build`, takes a screenshot of every story and compares it with the committed baseline. Template: [../assets/storybook/visual.spec.ts](../assets/storybook/visual.spec.ts).
- A hosted service such as Chromatic works too.
- Commit the baseline screenshots. Update them only when the change is expected and the user has confirmed it.
- Tag stories that should not be compared (for example pure motion demos) with `skip-visual`.

Playwright can start a static Storybook by itself:

```ts
// part of playwright.config.ts
webServer: {
  command: "npx http-server storybook-static -p 6006 --silent",
  port: 6006,
  reuseExistingServer: true,
},
```

## When to extract a shared component

- The same structure appears 3 or more times, or
- The logic is complex enough (accordion, tabs, combobox) to be worth maintaining in one place.

Do not extract something that appears only once or twice, or that is tightly bound to its page's logic.

## Iteration loop

1. Change the component in its story.
2. Take screenshots and compare them with the baseline.
3. Only the expected stories changed → ask the user to confirm → update the baseline.
4. Unexpected stories changed → fix them before moving on.

## Storybook MCP (optional)

Storybook's official `@storybook/addon-mcp` lets agents read the component list, generate stories and run tests. It is still in preview, mainly supports React, and its API may change. When it is enabled, use it to look up components; otherwise read the component source and stories directly.
