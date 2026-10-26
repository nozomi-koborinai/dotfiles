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

brew_bundle_cleanup() {
  HOMEBREW_NO_AUTO_UPDATE=1 brew bundle cleanup --file="$DOTFILES_DIR/Brewfile" "$@"
}

brew_cleanup_heading() {
  local line="$1"
  local heading
  case "$line" in
    "Would uninstall casks:")
      printf '%s\n' "Homebrew casks"
      ;;
    "Would uninstall formulae:")
      printf '%s\n' "Homebrew formulae"
      ;;
    "Would untap:")
      printf '%s\n' "Homebrew taps"
      ;;
    "Would uninstall "*)
      heading=${line#"Would uninstall "}
      heading=${heading%:}
      printf '%s\n' "Homebrew $heading"
      ;;
    *)
      heading=${line#Would }
      heading=${heading%:}
      printf '%s\n' "Homebrew $heading"
      ;;
  esac
}

brew_cleanup_records() {
  local output status group heading line records cache_heading
  if ! command -v brew &> /dev/null; then
    return 0
  fi

  status=0
  output=$(brew_bundle_cleanup) || status=$?
  group=""
  records=""
  cache_heading="Would \`brew cleanup\`:"

  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      "$cache_heading")
        group=""
        ;;
      Would\ *:)
        heading=$(brew_cleanup_heading "$line")
        group=$heading
        ;;
      Run\ *)
        group=""
        ;;
      "")
        ;;
      *)
        if [ -n "$group" ]; then
          records="${records}brew"$'\t'"${group}"$'\t'"${line}"$'\n'
        fi
        ;;
    esac
  done <<< "$output"

  # Exit 1 with names is Homebrew's "would uninstall" status, not a failed preview.
  if [ "$status" -eq 0 ]; then
    printf '%s' "$records"
    return 0
  fi
  if [ "$status" -eq 1 ] && [ -n "$records" ]; then
    printf '%s' "$records"
    return 0
  fi

  echo "warning: could not preview Homebrew cleanup ('brew bundle cleanup' exited ${status}); leaving Homebrew packages alone." >&2
  return 1
}

# Packages installed on this machine that the Brewfile does not declare.
undeclared_brew_packages() {
  local records status
  status=0
  records=$(brew_cleanup_records) || status=$?
  if [ "$status" -ne 0 ] || [ -z "$records" ]; then
    return 0
  fi
  prune_plan_print "$records"
}

nvim_cleanup_records() {
  local output status line name last records bad_name
  if ! command -v nvim &> /dev/null; then
    return 0
  fi

  status=0
  output=$(DOTFILES_NVIM_CLEAN_PREVIEW=1 nvim --headless +qa) || status=$?
  last=""
  records=""
  bad_name=0

  while IFS= read -r line || [ -n "$line" ]; do
    last=$line
    case "$line" in
      ok)
        ;;
      clean$'\t'*)
        name=${line#clean$'\t'}
        case "$name" in
          *$'\t'*)
            bad_name=1
            ;;
          *)
            records="${records}nvim"$'\t'"Neovim plugins"$'\t'"${name}"$'\n'
            ;;
        esac
        ;;
    esac
  done <<< "$output"

  if [ "$status" -ne 0 ] || [ "$last" != "ok" ] || [ "$bad_name" -ne 0 ]; then
    echo "warning: could not preview Neovim plugins; leaving Neovim plugins alone." >&2
    return 1
  fi
  printf '%s' "$records"
}

prune_plan() {
  local brew_status nvim_status
  brew_status=0
  nvim_status=0
  brew_cleanup_records || brew_status=$?
  nvim_cleanup_records || nvim_status=$?
  if [ "$brew_status" -ne 0 ] || [ "$nvim_status" -ne 0 ]; then
    return 1
  fi
  return 0
}

prune_plan_print() {
  local plan="$1"
  local source group item previous
  previous=""
  while IFS=$'\t' read -r source group item; do
    [ -n "$source" ] || continue
    if [ "$group" != "$previous" ]; then
      printf '%s\n' "$group"
      previous=$group
    fi
    printf '  %s\n' "$item"
  done <<< "$plan"
}

plan_has() {
  local plan="$1"
  local source="$2"
  local line
  while IFS= read -r line; do
    case "$line" in
      "$source"$'\t'*)
        return 0
        ;;
    esac
  done <<< "$plan"
  return 1
}

prune_apply() {
  local plan="$1"
  if plan_has "$plan" brew; then
    trust_declared_taps
    brew_bundle_cleanup --force
  fi
  if plan_has "$plan" nvim; then
    sync_nvim_plugins
  fi
}

# Bring nvim plugins in line with configs/nvim: the versions pinned in
# lazy-lock.json, minus anything the config no longer declares.
sync_nvim_plugins() {
  if command -v nvim &> /dev/null; then
    nvim --headless "+Lazy! restore" +qa &> /dev/null || true
    nvim --headless "+Lazy! clean" +qa &> /dev/null || true
    echo "✓ nvim plugins"
  fi
}
