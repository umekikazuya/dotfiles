# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------

# ssh config のホスト名一覧表示
alias sshli="cat ~/.ssh/config |grep ^Host\  |sed -e 's/^Host\ //g'"

alias nv='nvim'
alias dc="docker compose"
alias dps='docker ps --format "table {{ "{{" }}.Names{{ "}}" }}\t{{ "{{" }}.Status{{ "}}" }}\t{{ "{{" }}.Ports{{ "}}" }}"'
alias dpsa="docker ps -a"
alias dst="docker stats"
alias dil="docker images"
alias dclog="docker compose logs -f --no-log-prefix"
alias dcex="docker compose exec -it"
alias drm="docker rm"
alias dri="docker rmi"
alias dcl='''docker system df && docker volume ls -qf dangling=true | xargs -r docker volume rm && docker images -f 'dangling=true' -q | xargs -r docker rmi && docker container prune --force --filter 'until=168h' && docker ps --filter 'status=exited' | grep 'weeks ago' | awk '{print $1}' | xargs -r docker rm && docker builder prune && docker system df'''
alias pn="pnpm"