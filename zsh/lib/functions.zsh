function frg() {
  if [ $# -eq 0 ]; then
    echo "⚠️ Usage: frg <search_query> [flags]"
    return 1
  fi

  local rg_cmd=(rg --column --line-number --no-heading --color=always --smart-case)

  local selected=$(
    "${rg_cmd[@]}" "$@" | \
    fzf --ansi \
        --delimiter : \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(echo {1}:{2})' \
        --reverse \
        --height=40%
  )

  if [ -n "$selected" ]; then
    # 改行を含まず(-n)クリップボードにコピー
		echo -n "$selected" | pbcopy
    echo "📋 Copied: $selected"
  fi
}

# tmux(session) + ghq
function tm() {
  local selected=$(ghq list | fzf --reverse --height=40%)

  if [ -n "$selected" ]; then
    local full_path="$(ghq root)/$selected"

    local session_name=$(basename "$selected" | tr . _)

    # フルパスを使ってセッション作成
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      tmux new-session -ds "$session_name" -c "$full_path"
    fi

    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach -t "$session_name"
    fi
  fi
}