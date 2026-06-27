#!/usr/bin/env bash
#MISE description="システム全体のキャッシュ掃除"
echo "Cleaning Go cache..." && go clean -modcache -cache -testcache
echo "Cleaning Docker..." && docker system df && docker volume ls -qf dangling=true | xargs -r docker volume rm && docker images -f 'dangling=true' -q | xargs -r docker rmi && docker container prune --force --filter 'until=168h' && docker ps --filter 'status=exited' | grep 'weeks ago' | awk '{print $1}' | xargs -r docker rm && docker builder prune && docker system df
echo "Cleaning npm cache..." && npm cache clean --force
echo "Cleaning pnpm store..." && pnpm store prune
echo "Cleaning mise old versions..." && mise prune --yes