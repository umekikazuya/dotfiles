# ------------------------------------------------------------------------------
# MAIN .zshrc
# ------------------------------------------------------------------------------
#
# This file sources all the config files in the `lib` directory.
#
# ------------------------------------------------------------------------------

export PATH="$HOME/.local/bin:$PATH"

autoload -Uz compinit
compinit

# Completion improvements
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# Define the lib directory, assuming .zshrc is in the zsh directory of the dotfiles repo
ZSH_LIB_DIR="${ZDOTDIR:-$HOME}/src/github.com/umekikazuya/dotfiles/zsh/lib"

# Source all .zsh files in the lib directory
for file in "$ZSH_LIB_DIR"/*.zsh; do
  if [ -r "$file" ]; then
    source "$file"
  fi
done

# Load local settings if they exist
if [ -f "${HOME}/.zshrc.local" ]; then
  source "${HOME}/.zshrc.local"
fi

eval "$(~/.local/bin/mise activate zsh)"
eval "$(gh completion -s zsh)"

unset ZSH_LIB_DIR file
