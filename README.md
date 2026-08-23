# dotfiles

Personal macOS development environment and configuration files.

## Setup

Prerequisites: Xcode Command Line Tools + [Homebrew](https://brew.sh/).

```bash
git clone https://github.com/nozomi-koborinai/dotfiles.git ~/dotfiles
brew bundle --file=~/dotfiles/Brewfile
cd ~/dotfiles && ./setup.sh
```

### Neovim Initial Setup

Clear cache/state before first launch to cleanly install plugins:

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim
```

### Container Setup (Colima)

```bash
colima start --cpu 2 --memory 4 --disk 150   # Create initial VM
dotfiles sync                                  # Apply colima.yaml + configure docker context
```

Subsequent runs only need `colima start` / `colima stop`.

### Raycast

Manual import: `Settings → Advanced → Import` → `configs/raycast/Raycast.rayconfig`.

---

## Daily Commands

```bash
dotfiles sync      # Pull latest changes and apply symlinks
dotfiles update    # Update all packages, CLI extensions, and tools
```

Launch workspaces via WezTerm Command Palette (`Cmd+P`):
- **nzm: Dev** — nvim + Claude Code + Terminal x2
- **nzm: Workspace** — nvim + Claude Code + Terminal (`~/dotfiles`)

---

## Document & Diff Viewers

Terminal-launched browser utilities for reading specs and reviewing diffs without an editor:

| Command | Description |
|---------|-------------|
| `mo README.md` | Preview Markdown in browser with live reload on save |
| `mo docs/` | Preview all Markdown files in directory |
| `mo --status` / `mo --shutdown` | Check status / stop background viewer server |
| `difit HEAD` | Review last commit diff in a GitHub-like UI |
| `difit main` | Review diff between current branch and `main` |
| `difit --pr <URL>` | Review a GitHub PR locally |

### Splitview: Auto Side-by-Side with WezTerm

Automatically docks `mo` / `difit` in Chrome app mode on the right half and WezTerm on the left half:

| Shortcut | Command | Action |
|----------|---------|--------|
| `svm` | `splitview mo <files>` | `mo` on right half, WezTerm on left half |
| `svd` | `splitview difit <args>` | `difit` on right half, WezTerm on left half |
| `svx` | `splitview-exit` | Close viewer and maximize WezTerm |

---

## Keybindings

### WezTerm

Leader key: `Ctrl+Q`

#### Workspace

| Key | Action |
|-----|--------|
| `Leader → W` | Switch workspace |
| `Leader → Shift+W` | Create workspace |
| `Leader → $` | Rename workspace |

#### Tabs

| Key | Action |
|-----|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tab |
| `Cmd+1-9` | Select tab 1-9 |
| `Leader → {` / `}` | Move tab position |

#### Panes

| Key | Action |
|-----|--------|
| `Leader → D` | Split vertically (right) |
| `Leader → R` | Split horizontally (down) |
| `Leader → X` | Close pane |
| `Leader → H/J/K/L` | Navigate panes |
| `Leader → Z` | Toggle pane zoom |
| `Leader → O` | Rotate panes |
| `Leader → Shift+S` | Swap panes |
| `Leader → 1-4` | Select pane by number |
| `Leader → S` | Resize mode (`H/J/K/L` to adjust, `Enter`/`Esc` to exit) |

#### QuickSelect & Copy

| Key | Action |
|-----|--------|
| `Leader → Space` | QuickSelect (copy URLs, hashes, etc. with a single key) |
| `Leader → U` | Select URL and open in browser |
| `Leader → E` | Emoji / NerdFont picker |
| `Leader → [` | Copy mode (Vim keys) |
| `Shift+↑/↓` | Jump between shell prompts |

### Window Management (Hammerspoon)

Leader key: `Ctrl+A` (hides app if already focused)

| Key | Target |
|-----|--------|
| `Ctrl+A → Z` | Maximize window |
| `Ctrl+A → B` | Google Chrome |
| `Ctrl+A → Q` | WezTerm |
| `Ctrl+A → S` | Cursor |
| `Ctrl+A → Esc` | Cancel |

---

## Repository Structure

```
configs/
  zshrc          → ~/.zshrc
  gitconfig      → ~/.gitconfig
  nvim/          → ~/.config/nvim
  wezterm/       → ~/.config/wezterm
  hammerspoon/   → ~/.hammerspoon (Window management)
  gh/            → ~/.config/gh
  zeno/          → ~/.config/zeno (Shell abbreviations)
  lazygit/       → ~/Library/Application Support/lazygit
  vde/           → ~/.config/vde (Workspace layouts)
  docker/        → ~/.docker (Merged JSON configuration)
  colima/        → ~/.colima/default (Colima VM configuration)
  skills/        → ~/.claude/skills/ & ~/.cursor/skills/ (Shared Agent Skills)
  claude/        → ~/.claude (MCP servers & base settings)
  cursor/        → ~/.cursor/mcp.json (Cursor MCP settings)
  dotctor/       → ~/.dotctor.toml (Health check configuration)
  raycast/       → Manual import
bin/
  dotfiles       → dotfiles sync / update CLI
```
