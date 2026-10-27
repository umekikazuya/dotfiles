# Bootstrap non-interactive login commands, including Alacritty's tmux launcher.
# Interactive shells initialize their environment in .zshrc instead.
if [[ ! -o interactive ]]; then
  typeset -U path PATH
  path=("$HOME/.local/bin" $path)

  if [[ -x "$HOME/.local/bin/mise" ]]; then
    eval "$("$HOME/.local/bin/mise" activate zsh --shims)"
  fi
fi