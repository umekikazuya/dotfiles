# ------------------------------------------------------------------------------
# MAIN .zshrc
# ------------------------------------------------------------------------------
#
# This file sources all the config files in the `lib` directory.
#
# ------------------------------------------------------------------------------

# vimモード
bindkey -v
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^W' backward-kill-word
bindkey '^U' backward-kill-line

# 1. コマンドライン編集機能を読み込む
autoload -Uz edit-command-line
# 2. その機能を「エディタ呼び出し」として登録
zle -N edit-command-line
# 3. ノーマルモード（vicmd）のときに「v」でそれを実行するように紐付け
bindkey -M vicmd 'v' edit-command-line

export PATH="$HOME/.local/bin:$PATH"

autoload -Uz compinit
compinit


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

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
eval "$(gh completion -s zsh)"
eval "$(starship init zsh)"

unset ZSH_CONFIG_DIR ZSH_LIB_DIR file