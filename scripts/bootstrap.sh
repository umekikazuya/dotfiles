#!/usr/bin/env bash
#
# Dotfiles bootstrap is managed by mise.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
link_dir() {
  local source_path="$1"
  local target_path="$2"
  mkdir -p "$(dirname "$target_path")"
  ln -sfnv "$source_path" "$target_path"
}
link_dir "$DOTFILES_DIR/mise" "$CONFIG_DIR/mise"
exec mise bootstrap --only dotfiles --yes "$@"