# Classifying findings

When code and the system disagree, the code is not necessarily wrong. Classify every finding before deciding what to do. Without this step, review keeps forcing new needs back into the old system; the system never grows, and iteration stalls.

## Three types

| Type | How to recognize it | What to do | Needs user approval? |
|---|---|---|---|
| Violation | The system already has an answer and the code did not use it | Fix the code | No (but change code only when the user asks) |
| System gap | The need is legitimate, but the system has no matching token, component or page type rule | Propose an extension and hand it to `extend` in `design-system-build` | Yes |
| Outdated system | A system rule no longer fits the product's current direction | Propose an update and hand it to `update` in `design-system-build` | Yes |

## How to decide

Answer in order:

1. **Does the system have a token or component that meets this need?**
   - Yes, and its purpose and behavior fit → **violation**.
   - No → go to question 2.
2. **Is the need legitimate and likely to recur?**
   - It appears in two or more places, or it is clearly a real product requirement → **system gap**.
   - It is a one-off → ask the user whether it is really needed. If it is, still treat it as a system gap; never solve it with a one-off style inside the page.
3. **Is the same "violation" spread across many files, recent and clearly intentional? Or did the user say the direction is changing?**
   - Yes → **outdated system**.

If you cannot decide, report it as a question, not as a violation.

## Priority

| Level | Meaning | Examples |
|---|---|---|
| P0 | Harms usability or the brand; must be fixed before merging | Insufficient contrast, text disappearing in dark mode, the wrong theme |
| P1 | An inconsistency users can see | Wrong button variant, spacing off the rhythm, a hand-built component that looks different from the shared one |
| P2 | Invisible today, but it causes drift | A hand-written value that equals a token, a missing story, a missing state |
| P3 | Polish | Inconsistent wording, a structure that could be simpler |

## Writing a proposal

Proposals for system gaps and outdated systems include:

- **Proposal**: which token, component or rule to add or change.
- **Reason and evidence**: which files need it and how often it appears.
- **Impact**: which existing components or pages it changes.
- **Until it is approved**: usually, use the closest existing component and mark it as pending. Never slip a one-off style into the page.
