# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--color 'fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,bg:-1,bg+:-1'"

# go-task
eval "$(task --completion zsh)"

if command -v aws >/dev/null 2>&1 && command -v aws_completer >/dev/null 2>&1; then
  autoload -Uz bashcompinit
  bashcompinit
  complete -C aws_completer aws
fi