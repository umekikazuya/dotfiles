# Use vi editing mode, with jj as the insert-mode escape sequence.
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

# Edit the current command line in $EDITOR from vi command mode.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Keep the terminal cursor aligned with the active vi keymap.
function zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne '\e[2 q' ;;
    viins|main) echo -ne '\e[6 q' ;;
  esac
}
zle -N zle-keymap-select

function zle-line-init() {
  echo -ne '\e[6 q'
}
zle -N zle-line-init

# External tools can change the cursor shape, so restore insert-mode on prompt.
function _reset_cursor_shape_precmd() {
  echo -ne '\e[6 q'
}
precmd_functions+=(_reset_cursor_shape_precmd)