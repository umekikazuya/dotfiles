# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--reverse --ansi --color 'fg:#52525b,fg+:#18181b,bg:-1,bg+:#f3e8ff,hl:#9333ea,hl+:#7e22ce,info:#8b5cf6,prompt:#8b5cf6,pointer:#8b5cf6,marker:#8b5cf6,border:#d8b4fe'"
export FZF_DEFAULT_COMMAND='fd --type d --color=never --hidden --exclude .git/ ; fd --type f --color=never --hidden --exclude .git/'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--input-border --preview 'bat --color=always --style=numbers {}' --preview-window=down:50%"
export FZF_CTRL_R_OPTS="--reverse --input-border --preview 'echo {}' --preview-window=down:3:wrap"

_fzf_complete_git() {
  local -a tokens
  tokens=(${(z)1})

  [[ ${tokens[2]-} == sw ]] || return

  _fzf_complete --no-multi -- "$@" < <(
    git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads 2>/dev/null
  )
}

# go-task
eval "$(task --completion zsh)"

source <(usage g completion-init zsh)

if command -v aws >/dev/null 2>&1 && command -v aws_completer >/dev/null 2>&1; then
  autoload -Uz bashcompinit
  bashcompinit
  complete -C aws_completer aws
fi