#!/usr/bin/env python3
"""Validate every skill under skills/ against the Agent Skills format.

Checks:
- SKILL.md has frontmatter with name and description
- name follows the naming rules and matches the directory name
- description is 1-1024 characters
- metadata values are strings
- SKILL.md is shorter than 500 lines
- relative links in SKILL.md and references/*.md point to existing files
- skill paths listed in .claude-plugin/plugin.json exist

Standard library only. Usage: python3 scripts/validate_skills.py
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = ROOT / "skills"
NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
LINK_RE = re.compile(r"\[[^\]]*\]\(([^)#\s]+)(?:#[^)]*)?\)")


def parse_frontmatter(text: str) -> tuple[dict[str, object], list[str]]:
    """Parse simple YAML frontmatter: top-level key: value pairs and one level of nested mappings."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        raise ValueError("missing frontmatter (the first line must be ---)")
    try:
        end = next(i for i, line in enumerate(lines[1:], start=1) if line.strip() == "---")
    except StopIteration as exc:
        raise ValueError("frontmatter has no closing ---") from exc

    data: dict[str, object] = {}
    current: str | None = None
    for raw in lines[1:end]:
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        if raw.startswith((" ", "\t")):
            if current is None or not isinstance(data.get(current), dict):
                raise ValueError(f"cannot parse indented line: {raw!r}")
            key, _, value = raw.strip().partition(":")
            data[current][key.strip()] = value.strip()  # type: ignore[index]
            continue
        key, sep, value = raw.partition(":")
        if not sep:
            raise ValueError(f"cannot parse line: {raw!r}")
        key, value = key.strip(), value.strip()
        if value:
            data[key] = value
            current = None
        else:
            data[key] = {}
            current = key
    return data, lines[end + 1 :]


def unquote(value: str) -> tuple[str, bool]:
    if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
        return value[1:-1], True
    return value, False


def check_links(md_file: Path, errors: list[str]) -> None:
    for target in LINK_RE.findall(md_file.read_text(encoding="utf-8")):
        if re.match(r"^[a-z]+:", target):
            continue
        if not (md_file.parent / target).exists():
            errors.append(f"{md_file.relative_to(ROOT)}: linked file does not exist: {target}")


def check_skill(skill_dir: Path, errors: list[str]) -> None:
    skill_md = skill_dir / "SKILL.md"
    rel = skill_md.relative_to(ROOT)
    if not skill_md.is_file():
        errors.append(f"{skill_dir.relative_to(ROOT)}: missing SKILL.md")
        return

    text = skill_md.read_text(encoding="utf-8")
    try:
        meta, body = parse_frontmatter(text)
    except ValueError as exc:
        errors.append(f"{rel}: {exc}")
        return

    name = meta.get("name")
    if not isinstance(name, str) or not name:
        errors.append(f"{rel}: missing name")
    else:
        name, _ = unquote(name)
        if len(name) > 64 or not NAME_RE.match(name):
            errors.append(f"{rel}: name does not follow the naming rules: {name}")
        if name != skill_dir.name:
            errors.append(f"{rel}: name ({name}) differs from the directory name ({skill_dir.name})")

    description = meta.get("description")
    if not isinstance(description, str) or not description:
        errors.append(f"{rel}: missing description")
    else:
        description, _ = unquote(description)
        if not 1 <= len(description) <= 1024:
            errors.append(f"{rel}: description is {len(description)} characters; it must be 1-1024")

    metadata = meta.get("metadata")
    if metadata is not None:
        if not isinstance(metadata, dict):
            errors.append(f"{rel}: metadata must be a mapping")
        else:
            for key, value in metadata.items():
                if not unquote(value)[1]:
                    errors.append(f"{rel}: quote the value of metadata.{key} so it is a string")

    total_lines = len(text.splitlines())
    if total_lines >= 500:
        errors.append(f"{rel}: {total_lines} lines; it must be shorter than 500")
    if not "".join(body).strip():
        errors.append(f"{rel}: no body")

    check_links(skill_md, errors)
    for ref in sorted((skill_dir / "references").glob("*.md")):
        check_links(ref, errors)


def check_plugin(errors: list[str]) -> None:
    plugin = ROOT / ".claude-plugin" / "plugin.json"
    if not plugin.is_file():
        return
    data = json.loads(plugin.read_text(encoding="utf-8"))
    for path in data.get("skills", []):
        if not (ROOT / path / "SKILL.md").is_file():
            errors.append(f".claude-plugin/plugin.json: skill path does not exist: {path}")


def main() -> int:
    errors: list[str] = []
    skill_dirs = sorted(p for p in SKILLS_DIR.iterdir() if p.is_dir())
    if not skill_dirs:
        errors.append("no skills found under skills/")
    for skill_dir in skill_dirs:
        check_skill(skill_dir, errors)
    check_plugin(errors)

    if errors:
        print("\n".join(f"✗ {e}" for e in errors))
        return 1
    print(f"✓ {len(skill_dirs)} skill(s) passed: " + ", ".join(p.name for p in skill_dirs))
    return 0


if __name__ == "__main__":
    sys.exit(main())
