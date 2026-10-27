# ------------------------------------------------------------------------------
# MAIN .zshrc
# ------------------------------------------------------------------------------
#
# This file sources all the config files in the `lib` directory.
#
# ------------------------------------------------------------------------------

export PATH="$HOME/.local/bin:$PATH"

# Resolve managed tools before completion setup can cache shim paths.
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
  # Mise can restore inherited shim aliases at each prompt or directory change.
  _zsh_mise_shims_fallback() {
    local shims="${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}/shims" shim
    for shim in "$shims" "${(@M)path:#*/shims}"; do
      if [[ ${shim:A} == ${shims:A} ]]; then
        path=("${(@)path:#"$shim"}")
      fi
    done
    path+=("$shims")
    hash -r
  }
  _zsh_mise_shims_fallback
  add-zsh-hook -d precmd _zsh_mise_shims_fallback
  add-zsh-hook -d chpwd _zsh_mise_shims_fallback
  add-zsh-hook precmd _zsh_mise_shims_fallback
  add-zsh-hook chpwd _zsh_mise_shims_fallback
fi

FPATH="$HOME/.docker/completions:$FPATH"
autoload -Uz compinit
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

if [ ! -d "$ZSH_CACHE_DIR" ]; then
  mkdir -p "$ZSH_CACHE_DIR"
fi

# Use cached completion dump to skip compaudit on startup.
compinit -C -d "$ZSH_COMPDUMP"


# Completion improvements
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# Prefer XDG config path first to keep dotfiles location independent.
ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
ZSH_LIB_DIR="$ZSH_CONFIG_DIR/lib"

# Backward-compatible fallback for direct .zshrc symlink layout.
if [ ! -d "$ZSH_LIB_DIR" ]; then
  ZSH_LIB_DIR="${${(%):-%N}:A:h}/lib"
fi

# Source all .zsh files in the lib directory
for file in "$ZSH_LIB_DIR"/*.zsh; do
  if [ -r "$file" ]; then
    source "$file"
  fi
done

# Load local settings if they exist
if [ -f "$ZSH_CONFIG_DIR/.zshrc.local" ]; then
  source "$ZSH_CONFIG_DIR/.zshrc.local"
fi

eval "$(gh completion -s zsh)"
eval "$(starship init zsh)"

export ZENO_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/zeno"
unset ZENO_DISABLE_EXECUTE_CACHE_COMMAND ZENO_DISABLE_BUILTIN_COMPLETION

ZENO_SCRIPT="${ZSH_LIB_DIR:h}/plugins/zeno.zsh/zeno.zsh"
if [[ -f "$ZENO_SCRIPT" ]]; then
  source "$ZENO_SCRIPT"
  zeno-bind-default-keys
  bindkey '^r' zeno-smart-history-selection
  bindkey '^z' zeno-toggle-auto-snippet
fi

unset ZSH_CONFIG_DIR ZSH_LIB_DIR ZSH_CACHE_DIR ZSH_COMPDUMP file
