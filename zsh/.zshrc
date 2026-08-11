# ------------------------------------------------------------------------------
# MAIN .zshrc
# ------------------------------------------------------------------------------
#
# This file sources all the config files in the `lib` directory.
#
# ------------------------------------------------------------------------------

# vimモード
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

# 1. コマンドライン編集機能を読み込む
autoload -Uz edit-command-line
# 2. その機能を「エディタ呼び出し」として登録
zle -N edit-command-line
# 3. ノーマルモード（vicmd）のときに「v」でそれを実行するように紐付け
bindkey -M vicmd 'v' edit-command-line

# vi モードに応じてカーソル形状を変更（ノーマル: block / インサート: beam）
function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne '\e[2 q' ;;
    viins|main) echo -ne '\e[6 q' ;;
  esac
}
zle -N zle-keymap-select

function zle-line-init() {
  echo -ne '\e[6 q'
}
zle -N zle-line-init

# コマンド実行後にカーソル形状が変わるツール対策（vim等）で、プロンプト表示前に beam へ戻す
function _reset_cursor_shape_precmd() {
  echo -ne '\e[6 q'
}
precmd_functions+=(_reset_cursor_shape_precmd)

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
eval "$(/Users/umekikazuya/.local/bin/mise activate zsh)" # added by https://mise.run/zsh