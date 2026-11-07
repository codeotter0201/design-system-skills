# design-system-skills

**Agent skills that make any coding agent work like a UI/UX designer and frontend engineer: build, extend and review a custom design system for your project, with DESIGN.md, design tokens, Tailwind CSS v4, shadcn/ui and Storybook.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Agent Skills](https://img.shields.io/badge/Agent%20Skills-compatible-black.svg)](https://agentskills.io)

Works with Claude Code, OpenAI Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode, Windsurf and any other agent that supports the open [Agent Skills](https://agentskills.io) format.

## Why

Ask a coding agent for UI and you usually get the average of every project it has seen: the same typeface, the same gradient, the same rounded cards. Ask it again next week and it hardcodes a color your theme already defines, hand-builds a button your component library already has, and invents a fourth way to show an error. Nothing fails a build, so the drift piles up until someone fixes it by hand.

design-system-skills gives the agent a designer's process instead of a designer's taste:

- **Custom, not templated.** The skills define *how* to decide, never *what* to decide. No typeface, palette or layout is built in; every project gets its own visual direction.
- **Consistent.** Design tokens are the single source of truth. Pages may only use tokens and shared components, and every change is reviewed against the system.
- **Maintainable.** `DESIGN.md` mirrors the tokens and records the reasoning, so humans and agents read the same rules. A check script keeps the two in sync.
- **Iterable.** Change one token and the whole product follows. Polish one component in Storybook and visual regression shows exactly what changed.

## How it works

Two skills form a loop:

| Skill | Role | What it does |
|---|---|---|
| [`design-system-build`](skills/design-system-build/SKILL.md) | Designer | Clarifies the product, explores visual directions, freezes design tokens, builds components with Storybook, builds pages by page type, and extends or updates the system |
| [`design-system-review`](skills/design-system-review/SKILL.md) | Gatekeeper and synchronizer | Reviews every change against the system and classifies each finding as a violation, a system gap or an outdated system |

```
design-system-build ──▶ PRODUCT.md / DESIGN.md / tokens / components
         ▲                                │
         │                                ▼
 system proposals (approved by you) ◀── design-system-review ◀── every pull request
```

### Six phases, four gates

| Phase | What happens | Gate (your decision) |
|---|---|---|
| 1. Clarify | Write `PRODUCT.md`: product, users, brand personality, page types | G1: confirm the product |
| 2. Explore | 2–3 directions grounded in the product's world, rendered on the same expressive and dense screens, scored on a rubric, then refined in rounds | G2: pick a direction |
| 3. Systematize | Design tokens, `DESIGN.md`, base components and stories, checks installed | G3: confirm and freeze |
| 4. Build pages | Pages composed only from existing components, following their page type | |
| 5. Polish | Quality floor checklist, screenshots at several widths in light and dark mode | G4: accept the result |
| 6. Review | `design-system-review` checks every change | |

Existing projects use `adopt` mode: inventory the values already in use, consolidate them into tokens, extract shared components, migrate with zero visual change, then freeze.

## What it generates in your project

| File | Contents |
|---|---|
| `PRODUCT.md` | Product, users, brand personality, page types, constraints |
| `DESIGN.md` | Rules and rationale, signature element, components, page type rules, in the [Google DESIGN.md](https://github.com/google-labs-code/design.md) format |
| Tokens file | Tailwind CSS v4 `@theme` tokens with semantic variables compatible with shadcn/ui, dark mode and density modes |
| Design system block in `AGENTS.md` | The same rules and paths for every agent session |
| Shared components + stories | A Storybook component workbench, one story per state |
| `scripts/design-check.sh` | Deterministic checks for local runs and CI |
| Visual regression test | Playwright screenshots of every story, compared with the previous baseline |

Every project gets the same structure with its own content. The fixed structure is what lets the review know what to compare.

## Page types: landing page, blog, dashboard

Page types share one brand, one set of tokens and one component library, but each has its own rules:

| | Landing page | Blog | Dashboard |
|---|---|---|---|
| Primary task | First impression, conversion | Long-form reading | Scanning data, taking action |
| Density | Comfortable | Medium | Compact (`data-density="compact"`) |
| Brand color | The most | Little | Minimal; color is reserved for data |
| Motion | One signature moment | Almost none | Only in response to actions |

Rules are written per page type, not per page, so they stay manageable as the product grows. Add docs, settings, checkout or any other type with the same fields.

## Installation

### With the skills CLI (recommended, most agents)

```bash
npx skills add codeotter0201/design-system-skills
```

The CLI detects your installed agents and asks where to install. Skills go into the current project by default; add `-g` to make them available in every project.

### As a Claude Code plugin

```
/plugin marketplace add codeotter0201/design-system-skills
/plugin install design-system-skills@design-system-skills
```

### Manually

Copy (or symlink) `skills/design-system-build` and `skills/design-system-review` into your agent's skills directory:

| Agent | Project | Global |
|---|---|---|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| OpenAI Codex | `.agents/skills/` | `~/.agents/skills/` |
| Cursor | `.agents/skills/` | `~/.cursor/skills/` |
| Gemini CLI | `.agents/skills/` | `~/.gemini/skills/` |
| GitHub Copilot | `.agents/skills/` | `~/.copilot/skills/` |
| OpenCode | `.agents/skills/` | `~/.config/opencode/skills/` |
| Windsurf | `.windsurf/skills/` | `~/.codeium/windsurf/skills/` |

### Agents without skills support

Add this to the project's `AGENTS.md` (or whatever rules file the agent reads):

```markdown
Before building any UI users will see, read <path>/skills/design-system-build/SKILL.md and follow its process.
When reviewing UI changes, read <path>/skills/design-system-review/SKILL.md.
```

## Usage

There are no commands to remember. Describe what you want and the agent loads the right skill from its description:

- "Set up a design system for this new project. It's a backtesting tool for retail traders."
- "This project already has lots of pages. Adopt a design system without changing how anything looks."
- "Build a strategy performance page following the dashboard rules."
- "Make the primary color feel calmer."
- "Review this pull request against the design system."
- "Are DESIGN.md and the tokens out of sync?"

## Optional integrations

Used when available; without them, the skills explain how to do the same work by hand:

| Tool | Used for |
|---|---|
| [impeccable](https://github.com/pbakaus/impeccable) | Direction exploration, critique, audit, polish, and detecting common AI-default styles |
| [shadcn/ui](https://ui.shadcn.com/docs/skills) skill and CLI | Base components |
| [Storybook MCP](https://storybook.js.org/docs/ai/mcp/overview) | Letting agents read the component list, write stories and run tests |
| [@google/design.md](https://github.com/google-labs-code/design.md) CLI | `lint`, `diff` and `export` for `DESIGN.md` |
| [Playwright](https://playwright.dev) | Visual regression and screenshots |

## FAQ

**Does it choose a visual style for me?**
No. It proposes 2–3 directions based on your product and you pick one. The templates contain only structure and `TODO(design)` placeholders, never default colors or fonts.

**Do I need Tailwind CSS and shadcn/ui?**
They are the default stack for the templates. The process, layers and naming work with any stack; only the implementation of the tokens file changes.

**How do DESIGN.md and the tokens stay in sync?**
The tokens file is the single source of values and `DESIGN.md` mirrors it. `scripts/design-check.sh` compares the colors automatically, and `design-system-review` checks the rest on every change.

**What happens when the code needs something the system doesn't have?**
The review classifies it as a system gap and writes a proposal. Once you approve it, `design-system-build` extends the system instead of adding a one-off style to a page.

**Can I use it on an existing project?**
Yes. `adopt` mode inventories what the code already does, turns it into tokens and components, and migrates without visual changes before anything is redesigned.

## Repository layout

```
skills/
  design-system-build/
    SKILL.md
    references/    exploring directions, tokens, page types, components and Storybook, quality floor, adopting existing projects
    assets/        PRODUCT.md, DESIGN.md, tokens.css, agent-rules.md, Storybook templates, design-check.sh
  design-system-review/
    SKILL.md
    references/    checks, classifying findings, report format
tests/design-check/  regression tests for design-check.sh
scripts/             validation for this repository
.claude-plugin/      Claude Code plugin and marketplace manifests
```

## Contributing

Issues and pull requests are welcome. Before submitting, run:

```bash
python3 scripts/validate_skills.py   # SKILL.md format, names, description length, links
tests/design-check/run.sh            # design-check.sh
tests/design-check/run.sh /bin/bash  # again with the bash 3.2 that ships with macOS
```

Editing rules are in [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE)
