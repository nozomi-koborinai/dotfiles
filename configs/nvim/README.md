# Neovim Configuration

Clean and fast configuration for Neovim + WezTerm.

## Plugins

| Plugin | Purpose |
|--------|---------|
| `tokyonight.nvim` | Color scheme |
| `snacks.nvim` | Explorer / Picker / Terminal / LazyGit / Dashboard / Indent / Notifier |
| `nvim-treesitter` | Syntax highlighting |
| `gitsigns.nvim` | In-buffer Git diff & hunk actions |
| `bufferline.nvim` | Buffer tabs |
| `lualine.nvim` | Status line |
| `which-key.nvim` | Keybinding hints |

## Keymaps

Leader key is `<Space>`.

### General

| Key | Action |
|-----|--------|
| `<Space>w` | Save file |
| `<Space>x` | Close buffer |
| `<Space>X` | Force close buffer (discard changes) |
| `<Space>wx` | Save and close buffer |
| `<Space>q` | Quit Neovim |
| `Shift+l` / `Shift+h` | Next / previous buffer |

### File Operations & Picker

| Key | Action |
|-----|--------|
| `<Space>e` | Toggle file explorer |
| `<Space>o` | Reveal current file in explorer |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Buffer list |
| `<Space>fs` | Search word under cursor |
| `<Space>fr` | Recent files |
| `<Space>fk` | Search keymaps |

### Git

| Key | Action |
|-----|--------|
| `<Space>gg` | Open LazyGit |
| `<Space>gB` | Open file in GitHub |
| `]c` / `[c` | Next / previous Git hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |
| `<Space>hb` | Blame line |
| `<Space>hd` | Diff this buffer |

### Terminal

| Key | Action |
|-----|--------|
| `<Space>t` | Toggle floating terminal |
| `<Esc><Esc>` | Exit terminal insert mode |

### Miscellaneous

| Key | Action |
|-----|--------|
| `<Space>un` | Notification history |

## Editor Settings

- Indent: 2 spaces
- Line numbers: Hybrid (Absolute + Relative)
- Clipboard: Shared with system
- Background: Transparent (matches WezTerm opacity)
