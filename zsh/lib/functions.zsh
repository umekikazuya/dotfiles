# sw: ghq+fzfでプロジェクトをswitch
function sw() {
  local selected=$(
    {
    while IFS= read -r repo; do
      local session_name=$(basename "$repo" | tr . _)

      if tmux has-session -t "$session_name" 2>/dev/null; then
        printf '[active]\t%s\n' "$repo"
      fi
    done < <(ghq list)

    while IFS= read -r repo; do
      local session_name=$(basename "$repo" | tr . _)

      if ! tmux has-session -t "$session_name" 2>/dev/null; then
        printf '[new ]\t%s\n' "$repo"
      fi
    done < <(ghq list)
    } | fzf --reverse --popup 80% --no-sort | cut -f2-
  )

  if [ -n "$selected" ]; then
    local full_path="$(ghq root)/$selected"

    local session_name=$(basename "$selected" | tr . _)

    # フルパスを使ってセッション作成
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      tmux new-session -ds "$session_name" -c "$full_path"

      tmux split-window -t "$session_name" -h -p 20 -c "$full_path"

      tmux select-pane -t "$session_name" -U

      tmux new-window -t "$session_name" -c "$full_path"

      tmux split-window -t "$session_name" -v -p 20 -c "$full_path"

      tmux select-pane -t "$session_name" -L

      tmux select-window -t "$session_name:^"
    fi

    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach -t "$session_name"
    fi
  fi
}