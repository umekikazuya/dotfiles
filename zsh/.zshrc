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


# Define the lib directory, assuming .zshrc is in the zsh directory of the dotfiles repo
ZSH_LIB_DIR="${ZDOTDIR:-$HOME}/src/github.com/umekikazuya/dotfiles/zsh/lib"

# Source all .zsh files in the lib directory
for file in "$ZSH_LIB_DIR"/*.zsh; do
  if [ -r "$file" ]; then
    source "$file"
  fi
done

# Load local settings if they exist
if [ -f "${HOME}/src/github.com/umekikazuya/dotfiles/zsh/.zshrc.local" ]; then
  source "${HOME}/src/github.com/umekikazuya/dotfiles/zsh/.zshrc.local"
fi

eval "$(~/.local/bin/mise activate zsh)"
eval "$(gh completion -s zsh)"
eval "$(starship init zsh)"

unset ZSH_LIB_DIR file