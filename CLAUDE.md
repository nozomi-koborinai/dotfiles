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
| `configs/raycast/` | Raycast settings | Manual import |
| `bin/` | Custom CLI scripts | Added to PATH |

## Conventions

- File and directory names are lowercase (except tool conventions like `Brewfile`).
- Only items under `configs/` and `bin/` are managed by `setup.sh`.
- Claude Code settings are managed in two layers: reproducible configurations (`env`, `permissions.allow`, `hooks`, `enabledPlugins`, `extraKnownMarketplaces`, `language`) reside in `configs/claude/settings-base.json`. Machine-local preferences (`model`, `theme`, `effortLevel`, `tui`) stay in `~/.claude/settings.json` and are preserved across syncs.

## Commands

- `dotfiles sync` — Pull latest changes and run `setup.sh`
- `dotfiles update` — Update all managed tools, Homebrew packages, and CLI extensions
- WezTerm Command Palette (`Cmd+P`) → `nzm: Dev` / `nzm: Workspace` to launch workspaces
