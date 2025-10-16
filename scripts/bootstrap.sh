#!/bin/bash
#
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles

# dotfiles directory
DOTFILES_DIR=~/.dotfiles

# Create symlink for .gitconfig
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~

# Create symlink for .zshrc
ln -sfv "$DOTFILES_DIR/zsh/.zshrc" ~
