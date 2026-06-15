#!/usr/bin/env bash
#
# This script creates symlinks from the home directory to dotfiles.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

link_file() {
  local source_path="$1"
  local target_path="$2"
  mkdir -p "$(dirname "$target_path")"
  ln -sfnv "$source_path" "$target_path"
}

link_dir() {
  local source_path="$1"
  local target_path="$2"
  mkdir -p "$(dirname "$target_path")"
  ln -sfnv "$source_path" "$target_path"
}

link_dir "$DOTFILES_DIR/git" "$CONFIG_DIR/git"
link_file "$CONFIG_DIR/git/.gitconfig" "$HOME/.gitconfig"

link_dir "$DOTFILES_DIR/zsh" "$CONFIG_DIR/zsh"
link_file "$CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$CONFIG_DIR/zsh/.zprofile" "$HOME/.zprofile"

link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

link_file "$DOTFILES_DIR/alacritty/alacritty.toml" "$CONFIG_DIR/alacritty/alacritty.toml"
link_dir "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"
link_dir "$DOTFILES_DIR/bat" "$CONFIG_DIR/bat"
link_dir "$DOTFILES_DIR/mise" "$CONFIG_DIR/mise"
link_dir "$DOTFILES_DIR/gh" "$CONFIG_DIR/gh"
link_dir "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"
link_file "$DOTFILES_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
