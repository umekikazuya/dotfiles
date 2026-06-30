# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--ansi --color 'fg:#3b3248,fg+:#14171d,bg:-1,bg+:#ddd3fb,hl:#8b5cf6,hl+:#6d28d9,header:#b35b79,info:#7b66b8,pointer:#8b5cf6,marker:#8b5cf6,prompt:#8b5cf6,border:#c9c2b4'"
export FZF_DEFAULT_COMMAND='fd --type f --color=always --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {}' --preview-window=right:55%"
export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window=down:3:wrap"

# go-task
eval "$(task --completion zsh)"

if command -v aws >/dev/null 2>&1 && command -v aws_completer >/dev/null 2>&1; then
  autoload -Uz bashcompinit
  bashcompinit
  complete -C aws_completer aws
fi