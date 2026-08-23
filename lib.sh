#!/bin/bash

# Shared helpers for setup.sh and bin/dotfiles.

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Homebrew refuses to load formulae from untrusted taps, and that trust is reset
# by some Homebrew updates, so it has to be re-applied on every run.
trust_declared_taps() {
  local tap_name
  while IFS= read -r tap_name; do
    [ -n "$tap_name" ] || continue
    brew trust "$tap_name" > /dev/null || echo "  warning: could not trust tap $tap_name"
  done < <(sed -nE 's/^tap "([^"]+)".*/\1/p' "$DOTFILES_DIR/Brewfile")
}

# Packages installed on this machine that the Brewfile does not declare.
undeclared_brew_packages() {
  HOMEBREW_NO_AUTO_UPDATE=1 brew bundle cleanup --file="$DOTFILES_DIR/Brewfile" 2>/dev/null \
    | awk '/^Would uninstall/{p=1} /^Would `brew cleanup`/{p=0} /^Run /{p=0} p'
}

# Drop nvim plugins that are no longer declared in configs/nvim.
clean_nvim_plugins() {
  if command -v nvim &> /dev/null && [ -d "$HOME/.local/share/nvim/lazy" ]; then
    nvim --headless "+Lazy! clean" +qa &> /dev/null || true
    echo "✓ nvim plugins"
  fi
}
