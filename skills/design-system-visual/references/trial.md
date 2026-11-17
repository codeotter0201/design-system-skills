# Trialing partner skills

How to trial one partner skill, or compare several, on the same brief, and how the result updates [partners.md](partners.md). A trial is what makes an entry "Trialed"; nothing else does.

Run a trial when a candidate enters the list, when an entry is out of date by the freshness rule in [partners.md](partners.md), when a partner is to be used for a need it was not trialed on, or when the user wants partners compared.

## 1. Agree the trial with the user

1. Name the partners to trial and the need under trial (from the need-to-partner table in [partners.md](partners.md)).
2. For each partner, tell the user the install command, whether it runs its own program, what it writes into the project and the home directory, and what it sends. Wait for a yes.
3. Agree where the trial runs: a separate branch, worktree or copy of the project, one per partner, so no partner sees another's output.

## 2. Fix the brief

Every partner in a trial gets exactly the same inputs:

| Fixed input | Rule |
|---|---|
| `PRODUCT.md` | The same file, confirmed at gate G1, unchanged during the trial. A partner may read it; it may not rewrite it. |
| Touchstone screens | The same two: the most expressive screen and the most demanding one. For a trial of working screens, the most demanding one is a working screen of that kind. |
| Content | The same real content on both screens, with synthetic data labeled as synthetic. Nothing a partner produced for an earlier run goes into the brief. |
| References | The same products or sites the user admires and dislikes, from `PRODUCT.md`. |
| Need | The same need: a new direction, a refinement of a given direction, working screens, motion, or review. A refinement trial starts every partner from the same chosen direction card. |
| Environment | The same capabilities for every partner: image generation, starting a sub-agent, a browser for screenshots. Note which are missing. |

## 3. Run each partner

For each partner, in its own branch, worktree or copy:

1. Install it with the agreed command.
2. Run steps 3 to 5 of the `design-system-visual` `SKILL.md`: brief the partner with [handoff.md](handoff.md), follow its full flow, show directions before building, build the two touchstone screens, review with fresh eyes.
3. Where the partner's flow cannot run as designed, use the nearest substitute and record it: for example a structured question in place of a decision page, a code-led build in place of image comps, an in-thread review in place of a sub-agent.
4. Take screenshots of both screens at 375, 768 and 1280 px, in light and dark mode when the product has both.
5. Fill in the record below before starting the next partner.

## 4. Record

| Field | Content |
|---|---|
| Partner | Name and source |
| Version | The installed version, read as the freshness rule in [partners.md](partners.md) describes |
| Date | The date of the trial |
| Need | The need under trial, and the brief in one line |
| Installed | The install command and what it put where |
| Ran | Every program the partner ran, and anything it downloaded or sent |
| Left in the project | Every file and directory it wrote, and anything in the home directory |
| Full flow not used | Each part of its flow that could not be used, why, and the substitute |
| Screens | Paths to the screenshots, per screen and width |
| Scores | The rubric below, per criterion, with one line of evidence each |
| Findings | The reviewer's findings |
| Decision | The user's decision |

## 5. Score from the rendered screenshots

Score with this repository's own rubric below. Judge only from the screenshots, never from the code or the partner's own description. When comparing several partners, label the screenshot sets A, B, C without partner names until the user has decided.

| Criterion | 0 | 1 | 2 |
|---|---|---|---|
| Fits the brief | Contradicts the brand personality or page type | Fits in part | Every "is X, not Y" pair in `PRODUCT.md` is visible |
| Owned | Fails the swap test: a similar product would get the same result | Partly specific | Draws on the product's world in a way no similar product would |
| Free of defaults | Three or more items from [common-defaults.md](common-defaults.md) not chosen for this project | One or two | None |
| Holds on the demanding screen | The direction breaks or disappears on the demanding screen | Holds with visible strain | Holds, and the screen stays usable at every width |
| Craft | Broken layout, unreadable text or clashing hierarchy at some width | Sound but uneven | Type, spacing, hierarchy and states are consistent at every width |

A total is a summary for the user, not the decision.

## 6. Judge

- **The user decides**: accept, reject, or ask for another round, for each partner, and which one wins when several were compared.
- **A reviewer who did not build the screens** gives findings and proposed scores per criterion, from the screenshots alone. When no such reviewer is available, step out of the build context and review from the screenshots, and record that the reviewer saw the build.
- **Whoever built the screens** does not score them; they report what was not verified.

## 7. Update partners.md

1. Set the entry's Verified field to "Trialed with version X on YYYY-MM-DD", with the trial scope: the need, the brief in one line, the path used, the parts of the full flow not used, and the user's decision.
2. Record what was not trialed, such as other needs, screens or commands.
3. Correct the entry's facts and its row in the comparison table from the record: what it runs, what it leaves behind, what it needs for its full flow, how it picks a direction. Replace "Not recorded" where the trial established the fact.
4. Set its confidence in the need-to-partner table: "Trialed for this need" only for the need the trial covered and only when the user accepted the result. A rejected result is recorded in the trial scope, and the partner is not recommended for that need.
5. Change the default only when the user accepted the trialed partner's result for a new or replacement direction, and preferred it over the current default when both were trialed on the same brief, or the current default is out of date.

## 8. Clean up

Ask the user before deleting anything, and list what will go.

1. Uninstall each partner the user does not keep, with the installer's remove command when it has one, otherwise by removing the skill directory it created.
2. Remove what each partner left in the project and the home directory, unless the user keeps it.
3. Check `PRODUCT.md`, `DESIGN.md`, the tokens file and `AGENTS.md` with the version control diff, and restore any change a partner made.
4. Remove the trial branches, worktrees or copies the user does not keep.
5. Unset any environment variable set only for the trial.
6. Keep the screenshots and the record where the user chooses, and say where.
