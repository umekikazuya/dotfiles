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