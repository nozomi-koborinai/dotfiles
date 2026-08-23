# dotfiles

An opinionated, reproducible development environment for macOS on Apple
silicon. It combines terminal-first editing, AI-assisted development,
declarative workspace layouts, and package management in one repository.

## Core Toolchain

| Area | Tools | Role |
|------|-------|------|
| Terminal & shell | [WezTerm](https://wezterm.org/), [Zsh](https://www.zsh.org/), [Zeno](https://github.com/yuki-yano/zeno.zsh) | Terminal, shell integration, and abbreviations |
| Editor | [Neovim](https://neovim.io/), [Cursor](https://www.cursor.com/) | Editing and IDE workflows |
| AI development | [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview), [Codex](https://github.com/openai/codex) | Coding agents, shared skills, and MCP servers |
| Workspace | [vde-layout](https://www.npmjs.com/package/vde-layout), [Hammerspoon](https://www.hammerspoon.org/) | Reproducible pane layouts and macOS window management |
| Runtimes | [fnm](https://github.com/Schniz/fnm), [uv](https://docs.astral.sh/uv/), Go, Rust, Dart/FVM | Language runtimes and SDKs |
| Containers | [Colima](https://github.com/abiosoft/colima), [Docker](https://www.docker.com/) | Local container runtime and CLI |
| Cloud & IaC | Google Cloud CLI, Terraform, OPA | Cloud development and infrastructure tooling |
| Git | GitHub CLI, [Lazygit](https://github.com/jesseduffield/lazygit) | Repository and pull request workflows |

See the [`Brewfile`](./Brewfile) for the complete package list.

## Quick Start

Prerequisites:

- macOS on Apple silicon
- Xcode Command Line Tools
- [Homebrew](https://brew.sh/)

> `setup.sh` replaces the configuration targets listed below with symlinks.
> Review the repository before running it on an existing machine.

```bash
git clone https://github.com/nozomi-koborinai/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script installs missing Brewfile packages, links the managed
configuration, installs Node.js 22 through fnm, and restores the Neovim plugin
versions pinned in `lazy-lock.json`.

### Optional: Start Colima

```bash
colima start --cpu 2 --memory 4 --disk 150
dotfiles sync
```

After the VM has been created, use `colima start` and `colima stop` as needed.

## Daily Workflow

| Command | What it does |
|---------|--------------|
| `dotfiles sync` | Pull changes, install missing dependencies, apply symlinks, and restore pinned Neovim plugins |
| `dotfiles update` | Upgrade Homebrew packages, CLI extensions, Zeno, vde-layout, and Neovim plugins |
| `dotfiles prune` | Uninstall Homebrew packages absent from the Brewfile and clean Neovim plugins |

For Homebrew, `sync` reports packages that are installed locally but absent
from the Brewfile; it does not uninstall them. Add a package to the Brewfile to
keep it, or run `dotfiles prune` to remove it explicitly.

When `dotfiles update` changes `configs/nvim/lazy-lock.json`, commit that file
so every machine receives the same plugin versions.

## Workspace Layouts

Open the WezTerm Command Palette with `Cmd+P`:

| Preset | Layout |
|--------|--------|
| **nzm: Dev** | Neovim + Claude Code + two terminals |
| **nzm: Dev (Cursor)** | Cursor on the left; Claude Code + two terminals on the right |
| **nzm: Workspace** | The Dev layout rooted at `~/dotfiles` |
| **nzm: Workspace (Cursor)** | The Cursor layout rooted at `~/dotfiles` |

The presets are declared in
[`configs/vde/layout/config.yml`](./configs/vde/layout/config.yml).

## Keybindings

<details>
<summary><strong>WezTerm</strong> — leader: <code>Ctrl+Q</code></summary>

### Workspaces and tabs

| Key | Action |
|-----|--------|
| `Leader → W` | Switch workspace |
| `Leader → Shift+W` | Create workspace |
| `Leader → $` | Rename workspace |
| `Cmd+T` / `Cmd+W` | Create / close tab |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tab |
| `Cmd+1-9` | Select tab 1-9 |
| `Leader → {` / `}` | Move tab position |

### Panes

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

### Selection and copy

| Key | Action |
|-----|--------|
| `Leader → Space` | QuickSelect URLs, hashes, and other detected text |
| `Leader → U` | Select a URL and open it in a browser |
| `Leader → E` | Emoji / Nerd Font picker |
| `Leader → [` | Copy mode with Vim keys |
| `Shift+↑/↓` | Jump between shell prompts |

</details>

<details>
<summary><strong>Hammerspoon</strong> — leader: <code>Ctrl+A</code></summary>

| Key | Action |
|-----|--------|
| `Ctrl+A → Z` | Maximize window |
| `Ctrl+A → H/J/K/L` | Focus the window in that direction |
| `Ctrl+A → Shift+H/J/K/L` | Move the window to the display in that direction |
| `Ctrl+A → 1/2/3` | Split the two frontmost windows at 1:1, 2:1, or 3:1 |
| `Ctrl+A → B` | Toggle Google Chrome |
| `Ctrl+A → Q` | Toggle WezTerm |
| `Ctrl+A → S` | Toggle Cursor |
| `Ctrl+A → E` | Toggle Ableton Live |
| `Ctrl+A → G` | Toggle Grok Bot |
| `Ctrl+A → Esc` | Cancel |

</details>

## Repository Structure

```text
.
├── Brewfile              # Homebrew packages, casks, and taps
├── setup.sh              # Initial setup and configuration linking
├── lib.sh                # Shared setup and maintenance helpers
├── bin/
│   ├── dotfiles          # sync / update / prune command
│   └── nzm-cursor-split  # Cursor + WezTerm split launcher
└── configs/
    ├── claude/           # Claude Code MCP and base settings
    ├── colima/           # Colima VM configuration
    ├── cursor/           # Cursor MCP configuration
    ├── docker/           # Docker CLI configuration
    ├── dotctor/          # Dotfiles health checks
    ├── gh/               # GitHub CLI
    ├── hammerspoon/      # macOS window management
    ├── nvim/             # Neovim configuration and plugin lockfile
    ├── skills/           # Shared Claude Code and Cursor skills
    ├── vde/              # WezTerm workspace layouts
    ├── wezterm/          # Terminal configuration and keybindings
    ├── zeno/             # Shell abbreviations and completions
    ├── gitconfig         # ~/.gitconfig
    ├── gitignore         # ~/.config/git/ignore
    └── zshrc             # ~/.zshrc
```
