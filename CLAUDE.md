# CLAUDE.md

## About

Personal development environment and dotfiles managed for macOS.

- `configs/` — Tool configuration files (symlinked by `setup.sh`)
- `bin/` — Custom CLI utilities added to PATH

## Directory Structure

| Directory | Purpose | Deployment Target |
|-----------|---------|-------------------|
| `configs/zshrc` | Zsh configuration | → `~/.zshrc` |
| `configs/gitconfig` | Git configuration | → `~/.gitconfig` |
| `configs/gitignore` | Global Git ignore rules | → `~/.config/git/ignore` |
| `configs/nvim/` | Neovim configuration | → `~/.config/nvim` |
| `configs/wezterm/` | WezTerm configuration | → `~/.config/wezterm` |
| `configs/hammerspoon/` | Hammerspoon configuration (window management) | → `~/.hammerspoon` |
| `configs/gh/` | GitHub CLI configuration | → `~/.config/gh/` |
| `configs/zeno/` | zeno.zsh configuration (abbreviations) | → `~/.config/zeno/` |
| `configs/lazygit/` | Lazygit configuration | → `~/Library/Application Support/lazygit/` |
| `configs/vde/` | vde-layout configuration (workspace layouts) | → `~/.config/vde/` |
| `configs/docker/` | Docker CLI configuration (merge mode) | → `~/.docker/` |
| `configs/colima/` | Colima VM configuration | → `~/.colima/default/` |
| `configs/karabiner/` | Karabiner-Elements configuration | → `~/.config/karabiner/` |
| `configs/skills/` | Shared Agent Skills (Claude Code & Cursor) | → `~/.claude/skills/` & `~/.cursor/skills/` |
| `configs/claude/` | Claude Code MCP & settings | → `~/.claude/` |
| `configs/cursor/` | Cursor MCP configuration | → `~/.cursor/mcp.json` |
| `configs/dotctor/` | dotctor configuration (health check) | → `~/.dotctor.toml` |
| `bin/` | Custom CLI scripts | Added to PATH |
| `docs/` | Images referenced by the README | Not deployed |

## Conventions

- File and directory names are lowercase (except tool conventions like `Brewfile`).
- Only items under `configs/` and `bin/` are managed by `setup.sh`.
- Shell helpers used by both `setup.sh` and `bin/dotfiles` live in `lib.sh`.
- Anything kept on a machine must be declared in the repository. `dotfiles sync` reports undeclared Homebrew packages but never uninstalls; `dotfiles prune` performs the removal.
- Claude Code settings are managed in two layers: reproducible configurations (`env`, `permissions.allow`, `hooks`, `enabledPlugins`, `extraKnownMarketplaces`, `language`) reside in `configs/claude/settings-base.json`. Machine-local preferences (`model`, `theme`, `effortLevel`, `tui`) stay in `~/.claude/settings.json` and are preserved across syncs.

## Commands

- `dotfiles sync` — Pull latest changes and run `setup.sh`
- `dotfiles update` — Update all managed tools, Homebrew packages, and CLI extensions
- `dotfiles prune` — Uninstall Homebrew packages not declared in the `Brewfile`
- WezTerm Command Palette (`Cmd+P`) → `nzm: Dev` / `nzm: Workspace` to launch workspaces
