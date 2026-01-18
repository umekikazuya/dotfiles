#!/bin/bash
#
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles

# dotfiles directory
DOTFILES_DIR=~/src/github.com/umekikazuya/dotfiles

# Create symlink for .gitconfig
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~

# Create symlink for .zshrc
ln -sfv "$DOTFILES_DIR/zsh/.zshrc" ~

# Create symlink for .tmux.conf
ln -sfv "$DOTFILES_DIR/tmux/.tmux.conf" ~

# Create symlink for alacritty
ln -sfv "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

# Create symlink for nvim
ln -sfvn "$DOTFILES_DIR/nvim" ~/.config/nvim

# Create symlink for bat
ln -sfvn "$DOTFILES_DIR/bat" ~/.config/bat

# Create symlink for mise
ln -sfvn "$DOTFILES_DIR/mise" ~/.config/mise