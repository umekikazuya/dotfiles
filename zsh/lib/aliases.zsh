# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------

# Git
alias g='git'

# ssh config のホスト名一覧表示
alias sshli="cat ~/.ssh/config |grep ^Host\  |sed -e 's/^Host\ //g'"

# ghq管理下のリポジトリから選択して移動
alias ghcd="cd \$(ghq root)/\$(ghq list | fzf --reverse --height=40%)"