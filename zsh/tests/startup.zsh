#!/usr/bin/env zsh
emulate -LR zsh
setopt errexit nounset pipefail
zmodload zsh/files

root="${0:A:h:h}"
fixture="${0:A:h}/.startup-test.$$.${RANDOM}"
TRAPEXIT() {
  (( ZSH_SUBSHELL == 0 )) || return 0
  zf_rm -rf -- "$fixture"
}
zf_mkdir -p "$fixture/home/.local/bin" "$fixture/config/zsh/lib" \
  "$fixture/config/zsh/plugins/zeno.zsh" "$fixture/data/mise/shims" "$fixture/tools" \
  "$fixture/local-bin"
export HOME="$fixture/home"
export XDG_CONFIG_HOME="$fixture/config"
export XDG_CACHE_HOME="$fixture/cache"
export XDG_DATA_HOME="$fixture/data"
export ZDOTDIR="$fixture/config/zsh"
export PATH=/usr/bin:/bin
export ZSH_TEST_SHIMS="$fixture/data/mise/shims"
export ZSH_TEST_TOOLS="$fixture/tools"
export ZSH_TEST_LOCAL_BIN="$fixture/local-bin"
export ZSH_TEST_MISE_LOG="$fixture/mise.log"
export ZSH_TEST_FZF_LOG="$fixture/fzf.log"
export ZSH_TEST_TOOL_LOG="$fixture/tools.log"
unset MISE_DATA_DIR FZF_DEFAULT_OPTS FZF_DEFAULT_COMMAND FZF_CTRL_T_COMMAND \
  FZF_CTRL_T_OPTS FZF_CTRL_R_OPTS
export ZENO_DISABLE_EXECUTE_CACHE_COMMAND=stale
export ZENO_DISABLE_BUILTIN_COMPLETION=stale

/bin/ln -s "$root/.zprofile" "$ZDOTDIR/.zprofile"
/bin/ln -s "$root/.zshrc" "$ZDOTDIR/.zshrc"
/bin/ln -s "$root/lib/tool.zsh" "$ZDOTDIR/lib/tool.zsh"
for command in deno tmux; do
  /bin/ln -s /usr/bin/true "$ZSH_TEST_SHIMS/$command"
  /bin/ln -s /usr/bin/true "$fixture/tools/$command"
done
/bin/cat > "$HOME/.local/bin/mise" <<'ZSH'
#!/bin/zsh
print -r -- "$*|${ZSH_TEST_LOCAL-unset}" >> "$ZSH_TEST_MISE_LOG"
if [[ "$*" == "activate zsh --shims" ]]; then
  print -r -- 'path=("$ZSH_TEST_SHIMS" $path)'
else
  print -r -- 'autoload -Uz add-zsh-hook
path=("$ZSH_TEST_TOOLS" "$ZSH_TEST_SHIMS" $path)'
fi
ZSH
print -r -- '#!/bin/zsh
print -r -- "$0" >> "$ZSH_TEST_TOOL_LOG"
if [[ ${0:t} == fzf ]]; then
  print -r -- "${FZF_DEFAULT_OPTS-unset}|${FZF_CTRL_R_OPTS-unset}|${ZSH_TEST_LOCAL-unset}" > "$ZSH_TEST_FZF_LOG"
fi
print -r -- ":"' > "$fixture/tool"
/bin/chmod +x "$HOME/.local/bin/mise" "$fixture/tool"
for command in fzf task usage gh starship; do
  /bin/ln -s "$fixture/tool" "$fixture/local-bin/$command"
  /bin/ln -s "$fixture/tool" "$HOME/.local/bin/$command"
done
print -r -- 'ZSH_TEST_ZENO_STATE="$ZENO_HOME|${ZENO_DISABLE_EXECUTE_CACHE_COMMAND-unset}|${ZENO_DISABLE_BUILTIN_COMPLETION-unset}"
zeno-bind-default-keys() { :; }' > "$ZDOTDIR/plugins/zeno.zsh/zeno.zsh"
print -r -- 'path=("$ZSH_TEST_LOCAL_BIN" $path)
export ZSH_TEST_LOCAL=ready
export FZF_DEFAULT_OPTS=local-style
export FZF_DEFAULT_COMMAND=local-command
export FZF_CTRL_R_OPTS=""
export ZENO_HOME="$HOME/custom-zeno"
export ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1
export ZENO_DISABLE_BUILTIN_COMPLETION=1' > "$ZDOTDIR/.zshrc.local"

/bin/zsh -dlc '
  setopt errexit
  TRAPZERR() { print -u2 -- "FAIL: login bootstrap ($funcfiletrace[1])"; }
  [[ $(whence -p tmux) == "$ZSH_TEST_SHIMS/tmux" ]]
  [[ "$(<"$ZSH_TEST_MISE_LOG")" == "activate zsh --shims|unset" ]]
  [[ ! -v ZSH_TEST_LOCAL && ! -e "$ZSH_TEST_TOOL_LOG" ]]
'
for flags in -dic -dlic; do
  : > "$ZSH_TEST_MISE_LOG"
  : > "$ZSH_TEST_TOOL_LOG"
  /bin/zsh "$flags" '
    setopt errexit
    TRAPZERR() { print -u2 -- "FAIL: interactive startup ($funcfiletrace[1])"; }
    [[ "$(<"$ZSH_TEST_MISE_LOG")" == "activate zsh|ready" ]]
    [[ $(whence -p gh) == "$ZSH_TEST_LOCAL_BIN/gh" ]]
    [[ $(whence -p deno) == "$ZSH_TEST_TOOLS/deno" ]]
    [[ "$(<"$ZSH_TEST_TOOL_LOG")" != *"$HOME/.local/bin/"* ]]
    [[ "$(<"$ZSH_TEST_FZF_LOG")" == "local-style||ready" ]]
    [[ "$FZF_CTRL_T_COMMAND" == local-command ]]
    [[ "$ZSH_TEST_ZENO_STATE" == "$HOME/custom-zeno|1|1" ]]
    source "$ZDOTDIR/.zshrc" || exit 1
    unique_path=("${(@u)path}")
    (( ${#path} == ${#unique_path} ))
    [[ ${path[-1]} == "$ZSH_TEST_SHIMS" ]]
  '
done
zf_mv "$ZDOTDIR/.zshrc.local" "$ZDOTDIR/.zshrc.local.disabled"
/bin/zsh -dic '
  setopt errexit
  TRAPZERR() { print -u2 -- "FAIL: startup without local settings ($funcfiletrace[1])"; }
  [[ "$ZSH_TEST_ZENO_STATE" == "$XDG_CONFIG_HOME/zeno|unset|unset" ]]
  [[ "$FZF_DEFAULT_OPTS" == "--reverse --ansi --color "* ]]
  [[ "$FZF_CTRL_R_OPTS" == "--reverse --input-border "* ]]
  [[ "$FZF_CTRL_T_COMMAND" == "$FZF_DEFAULT_COMMAND" ]]
'
print -r -- 'ok: login bootstrap, interactive initialization, and local environment contract'
