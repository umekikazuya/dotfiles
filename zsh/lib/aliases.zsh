# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------

# Git
alias g='git'

# Docker
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dst='docker stats'
alias dil='docker images'
alias dclog='docker compose logs -f'
alias dex='docker exec -it'
alias dcex='docker compose exec -it'
alias drm='docker rm'
alias dri='docker rmi'
alias dcl='docker system df && docker volume ls -qf dangling=true | xargs -r docker volume rm && docker images -f "dangling=true" -q | xargs -r docker rmi && docker container prune --force --filter "until=168h" && docker ps --filter "status=exited" | grep "weeks ago" | awk "{print \$1}" | xargs -r docker rm && docker builder prune && docker system df'

# ssh config のホスト名一覧表示
alias sshli="cat ~/.ssh/config |grep ^Host\  |sed -e 's/^Host\ //g'"

# ghq管理下のリポジトリから選択して移動
alias ghcd="cd \$(ghq root)/\$(ghq list | fzf --reverse --height=40%)"