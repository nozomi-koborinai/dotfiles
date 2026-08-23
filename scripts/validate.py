#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["pyyaml"]
# ///

"""Validate structured configuration and repository-local Markdown links."""

from __future__ import annotations

import json
import re
import sys
import tomllib
from pathlib import Path
from urllib.parse import unquote, urlsplit

import yaml

ROOT = Path(__file__).resolve().parent.parent
MARKDOWN_LINK = re.compile(r"!?\[[^\]]*]\(([^)]+)\)")


def repository_files(suffixes: set[str]) -> list[Path]:
    return sorted(
        path
        for path in ROOT.rglob("*")
        if path.is_file()
        and path.suffix.lower() in suffixes
        and ".git" not in path.parts
    )


def validate_structured_files(errors: list[str]) -> dict[str, int]:
    loaders = {
        ".json": lambda text: json.loads(text),
        ".toml": lambda text: tomllib.loads(text),
        ".yaml": lambda text: list(yaml.safe_load_all(text)),
        ".yml": lambda text: list(yaml.safe_load_all(text)),
    }
    counts = {suffix: 0 for suffix in loaders}

    for path in repository_files(set(loaders)):
        suffix = path.suffix.lower()
        counts[suffix] += 1
        try:
            loaders[suffix](path.read_text(encoding="utf-8"))
        except Exception as error:
            errors.append(f"{path.relative_to(ROOT)}: {error}")

    return counts


def local_link_path(markdown: Path, raw_target: str) -> Path | None:
    target = raw_target.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    else:
        target = target.split(maxsplit=1)[0]

    parsed = urlsplit(target)
    if parsed.scheme or parsed.netloc or target.startswith("#"):
        return None

    path = unquote(parsed.path)
    if not path:
        return None
    return (markdown.parent / path).resolve()


def validate_markdown_links(errors: list[str]) -> int:
    checked = 0
    for markdown in repository_files({".md"}):
        text = markdown.read_text(encoding="utf-8")
        for match in MARKDOWN_LINK.finditer(text):
            target = local_link_path(markdown, match.group(1))
            if target is None:
                continue
            checked += 1
            if not target.exists():
                errors.append(
                    f"{markdown.relative_to(ROOT)}: missing local link "
                    f"{match.group(1)!r}"
                )
    return checked


def validate_agent_instructions(errors: list[str]) -> None:
    agents = ROOT / "AGENTS.md"
    claude = ROOT / "CLAUDE.md"

    if not agents.is_file():
        errors.append("AGENTS.md: canonical agent instructions are missing")
    elif agents.stat().st_size > 32 * 1024:
        errors.append("AGENTS.md: exceeds Codex's default 32 KiB instruction limit")

    if not claude.is_file() or claude.read_text(encoding="utf-8").strip() != "@AGENTS.md":
        errors.append("CLAUDE.md: expected the single adapter line '@AGENTS.md'")


def main() -> int:
    errors: list[str] = []
    counts = validate_structured_files(errors)
    links = validate_markdown_links(errors)
    validate_agent_instructions(errors)

    if errors:
        print("Validation failed:", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    structured = sum(counts.values())
    print(f"Validated {structured} structured files and {links} local links.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
