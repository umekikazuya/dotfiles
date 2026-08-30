# ------------------------------------------------------------------------------
# MAIN .zshrc
# ------------------------------------------------------------------------------
#
# This file sources all the config files in the `lib` directory.
#
# ------------------------------------------------------------------------------

export PATH="$HOME/.local/bin:$PATH"

autoload -Uz compinit
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

if [ ! -d "$ZSH_CACHE_DIR" ]; then
  mkdir -p "$ZSH_CACHE_DIR"
fi

# Use cached completion dump to skip compaudit on startup.
compinit -C -d "$ZSH_COMPDUMP"


# Completion improvements
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# Prefer XDG config path first to keep dotfiles location independent.
ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
ZSH_LIB_DIR="$ZSH_CONFIG_DIR/lib"

# Backward-compatible fallback for direct .zshrc symlink layout.
if [ ! -d "$ZSH_LIB_DIR" ]; then
  ZSH_LIB_DIR="${${(%):-%N}:A:h}/lib"
fi

# Source all .zsh files in the lib directory
for file in "$ZSH_LIB_DIR"/*.zsh; do
  if [ -r "$file" ]; then
    source "$file"
  fi
done

# Load local settings if they exist
if [ -f "$ZSH_CONFIG_DIR/.zshrc.local" ]; then
  source "$ZSH_CONFIG_DIR/.zshrc.local"
fi

if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi
eval "$(gh completion -s zsh)"
eval "$(starship init zsh)"

unset ZSH_CONFIG_DIR ZSH_LIB_DIR ZSH_CACHE_DIR ZSH_COMPDUMP file
