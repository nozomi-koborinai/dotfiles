# Repository Instructions

## Purpose

This repository defines a reproducible personal development environment for
macOS on Apple silicon. Keep machine state explainable from version-controlled
files rather than from one-off manual installation.

## Sources of Truth

- `Brewfile` declares Homebrew taps, formulae, and casks.
- `setup.sh` installs missing dependencies and deploys managed configuration.
- `lib.sh` contains shell helpers shared by setup and maintenance commands.
- `bin/dotfiles` implements the `sync`, `update`, and `prune` workflows.
- `configs/` contains tool configuration; Neovim plugin versions are pinned in
  `configs/nvim/lazy-lock.json`.
- `README.md` is the human-facing guide. Keep it focused on capabilities,
  setup, daily use, and discoverability.

Read the implementation rather than copying volatile package or keybinding
lists into this file.

## Change Rules

- Declare anything intentionally retained on a machine in `Brewfile`,
  `setup.sh`, or `configs/`.
- Keep `setup.sh` repeatable. Routine `sync` may install or restore state but
  must not uninstall Homebrew packages; destructive package cleanup belongs to
  `dotfiles prune`.
- Put shell logic shared by `setup.sh` and `bin/dotfiles` in `lib.sh`.
- When adding a managed config, add its source under `configs/`, deploy it from
  `setup.sh`, and update the README when users need to know about it.
- Keep shared Agent Skills under `configs/skills/<skill-name>/SKILL.md`; setup
  deploys them to both Claude Code and Cursor.
- Keep reproducible Claude Code settings in
  `configs/claude/settings-base.json`. Do not add machine-local preferences
  such as model, theme, effort level, or TUI settings there.
- Update the README when changing user-visible commands, workspace presets,
  keybindings, core tools, or setup behavior.
- Do not commit credentials, tokens, company information, private URLs, or
  machine-local identifiers. Treat encrypted exports as unreviewable and keep
  them outside the repository.
- Use lowercase file and directory names except where a tool convention
  requires otherwise, such as `Brewfile`, `AGENTS.md`, or `SKILL.md`.

## Validation

Run checks relevant to the files changed:

```bash
git diff --check
bash -n setup.sh lib.sh bin/dotfiles bin/nzm-cursor-split
stylua --check configs/
deno task validate
```

- `scripts/validate.ts` parses JSON, YAML, and TOML, checks repository-local
  Markdown links, and verifies the `AGENTS.md` / `CLAUDE.md` adapter.
- When changing `Brewfile`, run `brew bundle check --file=Brewfile` on macOS.
- When changing Neovim or WezTerm configuration, load it with the corresponding
  application when available.
- Run `setup.sh` as an integration check only on a disposable or intended macOS
  environment. It replaces live configuration targets and is not a Linux CI
  test.
