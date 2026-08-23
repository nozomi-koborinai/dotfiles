#!/bin/bash

# dotfiles setup script

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$DOTFILES_DIR/configs"

source "$DOTFILES_DIR/lib.sh"

echo "Setting up dotfiles..."

# Ensure config directories exist
mkdir -p ~/.config
mkdir -p ~/.config/gh

# Install Brewfile dependencies
if command -v brew &> /dev/null; then
  trust_declared_taps

  if ! HOMEBREW_BUNDLE_NO_UPGRADE=1 HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$DOTFILES_DIR/Brewfile" &> /dev/null; then
    echo "Installing missing Brewfile packages..."
    # A formula added to a tap since this machine last updated would otherwise
    # look like it does not exist, and one unknown name aborts the whole install.
    brew update --quiet || true
    trust_declared_taps
    HOMEBREW_BUNDLE_NO_UPGRADE=1 brew bundle install --file="$DOTFILES_DIR/Brewfile" || echo "  brew bundle: partially failed (check log above)"
  fi
  echo "✓ Brewfile"

  # Reported, never removed here: a routine sync must not uninstall anything.
  undeclared=$(undeclared_brew_packages)
  if [ -n "$undeclared" ]; then
    echo ""
    echo "  Undeclared packages (installed but missing from the Brewfile):"
    echo "$undeclared" | sed 's/^/    /'
    echo "    Add them to the Brewfile, or run 'dotfiles prune' to uninstall them."
    echo ""
  fi
fi

# Function to link files / directories
link_file() {
  local src=$1
  local dst=$2

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    rm -rf "$dst"
  fi

  ln -sf "$src" "$dst"
  echo "✓ $(basename "$dst")"
}

# zsh
link_file "$CONFIGS_DIR/zshrc" ~/.zshrc

# git
link_file "$CONFIGS_DIR/gitconfig" ~/.gitconfig
mkdir -p ~/.config/git
link_file "$CONFIGS_DIR/gitignore" ~/.config/git/ignore

# gh (GitHub CLI)
link_file "$CONFIGS_DIR/gh/config.yml" ~/.config/gh/config.yml

# gh-stack
if command -v gh &> /dev/null && ! gh extension list 2>/dev/null | grep -q 'github/gh-stack'; then
  echo "Installing gh-stack..."
  gh extension install github/gh-stack
fi

# deno (zeno.zsh dependency)
if ! command -v deno &> /dev/null; then
  echo "Installing deno..."
  brew install deno
fi

# zeno.zsh
if [ ! -d "$HOME/.zeno" ]; then
  echo "Installing zeno.zsh..."
  git clone https://github.com/yuki-yano/zeno.zsh.git "$HOME/.zeno"
fi

# zeno config
mkdir -p ~/.config/zeno
link_file "$CONFIGS_DIR/zeno/config.yml" ~/.config/zeno/config.yml

# nvim
link_file "$CONFIGS_DIR/nvim" ~/.config/nvim
sync_nvim_plugins

# wezterm
link_file "$CONFIGS_DIR/wezterm" ~/.config/wezterm

# hammerspoon
link_file "$CONFIGS_DIR/hammerspoon" ~/.hammerspoon

# cursor-agent
if ! command -v cursor-agent &> /dev/null; then
  echo "Installing cursor-agent..."
  curl https://cursor.com/install -fsSL | bash
fi

# vde-layout, pinned to Homebrew's node so switching nvm versions can't hide it
if command -v brew &> /dev/null; then
  BREW_PREFIX="$(brew --prefix)"
  stale_vde=$(command -v vde-layout 2>/dev/null || true)
  if [ -n "$stale_vde" ] && [ "$stale_vde" != "$BREW_PREFIX/bin/vde-layout" ]; then
    npm uninstall -g vde-layout &> /dev/null || true
    echo "  removed vde-layout from $(dirname "$stale_vde")"
  fi
  if [ ! -x "$BREW_PREFIX/bin/vde-layout" ] && [ -x "$BREW_PREFIX/bin/npm" ]; then
    echo "Installing vde-layout..."
    "$BREW_PREFIX/bin/npm" install -g vde-layout
  fi
fi
mkdir -p ~/.config/vde/layout
link_file "$CONFIGS_DIR/vde/layout/config.yml" ~/.config/vde/layout/config.yml

# lazygit
link_file "$CONFIGS_DIR/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"

# dotctor (the binary itself comes from the Brewfile)
link_file "$CONFIGS_DIR/dotctor/dotctor.toml" ~/.dotctor.toml

# docker config (merge base settings into existing config)
mkdir -p ~/.docker
DOCKER_CONFIG="$HOME/.docker/config.json"
DOCKER_BASE="$CONFIGS_DIR/docker/config-base.json"
if [ -f "$DOCKER_CONFIG" ]; then
  jq -s '.[0] * .[1]' "$DOCKER_CONFIG" "$DOCKER_BASE" > "$DOCKER_CONFIG.tmp" \
    && mv "$DOCKER_CONFIG.tmp" "$DOCKER_CONFIG"
  echo "  merged docker config-base.json"
else
  cp "$DOCKER_BASE" "$DOCKER_CONFIG"
  echo "  created docker config.json"
fi

# docker context cleanup
for ctx in desktop-linux orbstack; do
  if docker context inspect "$ctx" &>/dev/null; then
    docker context rm "$ctx" &>/dev/null && echo "  removed docker context: $ctx"
  fi
done

# colima config
if [ -d "$HOME/.colima/default" ]; then
  cp "$CONFIGS_DIR/colima/colima.yaml" "$HOME/.colima/default/colima.yaml"
  echo "✓ colima"
fi

# colima docker context
if command -v colima &>/dev/null && colima status &>/dev/null 2>&1; then
  docker context use colima &>/dev/null && echo "  docker context: colima"
fi

# karabiner-elements (copy instead of symlink due to Karabiner overwrite behavior)
mkdir -p ~/.config/karabiner
rm -f ~/.config/karabiner/karabiner.json
cp "$CONFIGS_DIR/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json
echo "✓ karabiner"

# agent skills (shared between Claude Code and Cursor)
mkdir -p ~/.claude/skills
mkdir -p ~/.cursor/skills

# Clean up stale skill symlinks in ~/.claude/skills and ~/.cursor/skills
for target_dir in ~/.claude/skills ~/.cursor/skills; do
  for skill_link in "$target_dir"/*; do
    if [ -L "$skill_link" ]; then
      skill_target=$(readlink "$skill_link")
      case "$skill_target" in
        "$DOTFILES_DIR"/*)
          if [ ! -e "$skill_link" ]; then
            rm "$skill_link"
            echo "  removed stale skill: $(basename "$skill_link")"
          fi
          ;;
      esac
    fi
  done
done

# Link shared skills from configs/skills/
for skill_dir in "$CONFIGS_DIR"/skills/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  link_file "$skill_dir" ~/.claude/skills/"$skill_name"
  link_file "$skill_dir" ~/.cursor/skills/"$skill_name"
done

# cursor mcp
link_file "$CONFIGS_DIR/cursor/mcp.json" ~/.cursor/mcp.json

# claude code mcp servers
if command -v claude &> /dev/null; then
  while IFS= read -r name; do
    config=$(jq -c ".mcpServers[\"$name\"]" "$CONFIGS_DIR/claude/mcp.json")
    claude mcp add-json "$name" "$config" -s user 2>/dev/null || true
  done < <(jq -r '.mcpServers | keys[]' "$CONFIGS_DIR/claude/mcp.json")
fi

# claude code settings (merge permissions into existing settings)
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
CLAUDE_BASE="$CONFIGS_DIR/claude/settings-base.json"
if [ -f "$CLAUDE_SETTINGS" ]; then
  jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS" "$CLAUDE_BASE" > "$CLAUDE_SETTINGS.tmp" \
    && mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
  echo "  merged settings-base.json"
else
  cp "$CLAUDE_BASE" "$CLAUDE_SETTINGS"
  echo "  created settings.json"
fi

echo ""
echo "Setup complete!"

# dotctor health check
if command -v dotctor &> /dev/null; then
  echo ""
  dotctor
fi
