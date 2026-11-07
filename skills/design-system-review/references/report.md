# Report format

Use the structure below. Write "None" in sections with no content instead of deleting them, so readers know the item was checked.

```markdown
## Design review: <scope, for example PR #12 or main...feature/x>

**Result**: <Pass / N items to fix / M system proposals need your decision>
**Basis**: `DESIGN.md` (<commit>), `<tokens file>`, scope <base>...<head>

### Deterministic checks

| Check | Result |
|---|---|
| design-check.sh | Pass / N findings / Not run (reason) |
| DESIGN.md lint | Pass / N errors, M warnings / Not run (reason) |
| DESIGN.md diff | No changes / a added, b removed, c modified / Not run (reason) |
| impeccable detect | Pass / N findings / Not installed |
| Visual regression | Pass / N stories differ / Not run (reason) |

### To fix (violations)

| Priority | Location | Problem | Basis | Suggested fix |
|---|---|---|---|---|
| P1 | `src/app/pricing/page.tsx:42` | Hand-built button instead of `Button` | DESIGN.md › Components › Button | Use `<Button variant="secondary">` |

### System proposals (your decision)

| Type | Proposal | Reason and evidence | Impact |
|---|---|---|---|
| System gap | Add a `Stepper` component | Three pages hand-build their own step indicator (files listed) | New component; existing components unchanged |

### Impact of rule changes

Fill in only when the tokens file or `DESIGN.md` changed.

| Token | Change | Usages | Status |
|---|---|---|---|
| `primary` | Value modified | 14 files | Visual differences only in the expected stories |
| `brand-accent` | Removed | Still used in 2 files | Needs migration |

### Questions

- <Things you could not decide that need the user's answer>

### Not checked

- <Checks that did not run and why, for example "no screenshot tool, no visual comparison">
```

## Rules

- Always write locations as `file:line`.
- Point the basis at something specific: a `DESIGN.md` section, a token name or a `PRODUCT.md` section.
- Sort violations by priority, P0 first.
- When one problem appears in many places, merge it into one row and list every location.
