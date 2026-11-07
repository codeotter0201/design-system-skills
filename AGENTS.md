# AGENTS.md

For agents and developers maintaining this repository.

## What this repository is

Two skills in the [Agent Skills](https://agentskills.io/specification) format:

- `skills/design-system-build`: creates, adopts, extends and updates a design system, and builds pages by page type.
- `skills/design-system-review`: reviews UI changes against the design system and keeps the two in sync.

## Editing rules

### Skill format

- `name`: lowercase letters, digits and hyphens, 1–64 characters, no leading or trailing hyphen, no consecutive hyphens, identical to the directory name.
- `description`: 1–1024 characters, covering both what the skill does and when to use it, with the keywords users are likely to say.
- `metadata` values are always strings.
- `SKILL.md` stays under 500 lines. Details go in `references/`, linked only one level deep.
- Templates and scripts live in the skill's own `assets/` or `scripts/`. Installers copy only the skill directory, so files anywhere else in the repository are missing after installation.

### Content

- Everything is written in English.
- Do not name tools from a particular agent harness (such as a specific Read or Edit tool); any agent must be able to follow the instructions. External tools are always optional: "use it when available; otherwise do this by hand".
- Templates contain only structure and `TODO(design)` placeholders, never aesthetic defaults (typefaces, palettes, radius values).
- Documents describe the current state only. No "previously…" notes or version comparisons; history lives in git.
- Both skills must describe shared concepts the same way (path conventions, the `TODO(design)` marker, how findings are classified). When you change one, search the other for the same content.

### design-check.sh

- Must run on the bash 3.2 that ships with macOS (BSD grep, BSD awk) and on Linux (bash 5, GNU grep, mawk or gawk): no associative arrays, no `grep -P`, no awk interval expressions (`{3}`).
- When you add or change a check, update `tests/design-check/fixtures/` and the expectations in `run.sh`.

## Validation

Run after every change:

```bash
python3 scripts/validate_skills.py
tests/design-check/run.sh
tests/design-check/run.sh /bin/bash
```

With Docker, also run the tests on Linux:

```bash
docker run --rm -v "$PWD":/repo:ro -w /repo debian:stable-slim tests/design-check/run.sh
```
