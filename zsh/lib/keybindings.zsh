bindkey -e
bindkey -r "^X^F"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z