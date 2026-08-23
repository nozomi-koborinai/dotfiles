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
dotfiles prune     # Uninstall packages not declared in the Brewfile
```

`sync` only ever adds. When it finds Homebrew packages that this machine has but
the `Brewfile` does not declare, it lists them and leaves them alone — declare
them in the `Brewfile` to keep them, or run `prune` to remove them. Neovim
plugins are an exception: they are fully declared in `configs/nvim`, so `sync`
drops any that are no longer listed.

Launch workspaces via WezTerm Command Palette (`Cmd+P`):
- **nzm: Dev** — nvim + Claude Code + Terminal x2
- **nzm: Workspace** — nvim + Claude Code + Terminal (`~/dotfiles`)

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
| `Leader → D` | Split pane downward |
| `Leader → R` | Split pane to the right |
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

| Key | Action |
|-----|--------|
| `Ctrl+A → Z` | Maximize window |
| `Ctrl+A → H/J/K/L` | Focus the window in that direction |
| `Ctrl+A → Shift+H/J/K/L` | Move the window to the display in that direction |
| `Ctrl+A → 1/2/3` | Split the two frontmost windows left/right at 1:1, 2:1, 3:1 |
| `Ctrl+A → B` | Google Chrome |
| `Ctrl+A → Q` | WezTerm |
| `Ctrl+A → S` | Cursor |
| `Ctrl+A → E` | Ableton Live |
| `Ctrl+A → G` | Grok Bot |
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
  dotfiles       → dotfiles sync / update / prune CLI
lib.sh           → Shell helpers shared by setup.sh and bin/dotfiles
```
