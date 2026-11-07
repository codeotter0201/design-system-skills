# Quality floor

Quality comes from two places: a few project-specific decisions (the signature) and a large number of details done right (the floor). This checklist covers the floor, which is the same for every project.

## Common defaults

AI-generated interfaces keep landing on the combinations below. None of them is wrong in itself, but unless it was chosen for this project, it is a default rather than a decision. If `PRODUCT.md` or the user explicitly asks for one, follow the request.

- One common sans-serif typeface for all text
- Purple-to-blue gradients, or large gradients used as decoration
- An off-white background with a high-contrast serif headline and a terracotta accent
- A near-black background with a single neon green or vermilion accent
- A newspaper layout: hairline rules, zero radius, dense columns
- All content split into identical rounded cards, each with the same faint gray shadow
- Cards nested inside cards
- A letter-spaced uppercase eyebrow label above every heading
- One word in a headline set in a different color or in italics
- 01 / 02 / 03 numbering on content that is not a sequence
- An arrow ("→") appended to every link and button
- Emoji used as icons
- Every section fading and sliding up on entrance, every card animating on hover
- Gray text on a colored background

## Checklist

### Layout

- [ ] No horizontal scrolling at 375px wide
- [ ] Pages of the same type share the same maximum content width
- [ ] Consistent alignment; left alignment is the default and centering needs a reason
- [ ] All spacing sits on the rhythm roles, and one kind of gap is never `gap` in one place and `margin` in another
- [ ] Fixed headers never cover content

### Text

- [ ] Body lines are 60–75 characters long (about 30–40 characters for CJK text)
- [ ] Body line height is about 1.5–1.75; serif text gets slightly more
- [ ] No more than 4–5 type roles on one screen
- [ ] Numeric columns use `tabular-nums`
- [ ] Long strings and names wrap or truncate correctly

### Color

- [ ] Body text contrast is at least 4.5:1, large text and UI boundaries at least 3:1, in both light and dark mode
- [ ] Information is never conveyed by color alone (status also has an icon or text)
- [ ] Brand color usage follows the page type rules

### Interaction

- [ ] Every interactive element has a clear focus-visible style
- [ ] Targets are at least 24×24px; 44×44px is recommended on touch devices
- [ ] Hover never shifts the layout
- [ ] Buttons cannot be clicked twice during async work and show progress
- [ ] Actions keep one name throughout: a button labeled "Publish" leads to a "Published" message

### States

- [ ] Loading reserves layout space (skeletons) so content does not jump
- [ ] Empty states explain what to do next
- [ ] Errors say what happened and how to fix it, without vagueness or apologies
- [ ] Disabled states are recognizable and their reason can be explained

### Motion

- [ ] Micro-interactions take about 150–300ms
- [ ] Animations change only `transform` and `opacity`
- [ ] `prefers-reduced-motion` is respected

### Accessibility

- [ ] Every form field has a label, and error messages are associated with their fields
- [ ] Meaningful images have alt text; decorative images have an empty alt
- [ ] Heading levels never skip, and pages have landmarks
- [ ] Everything works with the keyboard, and tab order matches visual order
- [ ] Icon-only buttons have an `aria-label`

### Performance

- [ ] Images have suitable sizes and formats and load lazily
- [ ] Fonts have a loading strategy; CJK fonts are subset
- [ ] No noticeable layout shift

### Content

- [ ] Real or realistic content, no lorem ipsum
- [ ] Words users understand, not internal system names
- [ ] Calls to action say what will happen ("Save changes", not "Submit")

## Screenshot self-review

1. Take screenshots at 375, 768 and 1280 px wide, once in light mode and once in dark mode.
2. Squint at the whole page first: where does the eye land? Is that what you want people to see first?
3. Then check the details: alignment, spacing rhythm, type hierarchy, states.
4. Remove one unnecessary decoration and look again.
5. If you cannot take screenshots, write "not visually verified" in your report.
