#!/usr/bin/env zsh
emulate -LR zsh
setopt errexit nounset pipefail
zmodload zsh/files

rc="${0:A:h:h}/.zshrc"
fixture="${0:A:h}/.mise-test.$$.${RANDOM}"
TRAPEXIT() {
  (( ZSH_SUBSHELL == 0 )) || return 0
  zf_rm -rf -- "$fixture"
}
zf_mkdir -p "$fixture/home/.local/bin" "$fixture/config/zsh/lib" \
  "$fixture/data/mise/shims" "$fixture/tools-one" "$fixture/tools-two"
export HOME="$fixture/home"
export XDG_CONFIG_HOME="$fixture/config"
export XDG_CACHE_HOME="$fixture/cache"
export XDG_DATA_HOME="$fixture/data"
unset MISE_DATA_DIR
export ZSH_TEST_SHIMS="$fixture/data/mise/shims"
export ZSH_TEST_TOOLS_ONE="$fixture/tools-one"
export ZSH_TEST_TOOLS_TWO="$fixture/tools-two"
export ZSH_TEST_TOOLS="$ZSH_TEST_TOOLS_ONE"
/bin/ln -s "$fixture/data/mise" "$fixture/mise-alias"
export ZSH_TEST_SHIM_ALIAS="$fixture/mise-alias/shims"
for directory in "$ZSH_TEST_SHIMS" "$ZSH_TEST_TOOLS_ONE" "$ZSH_TEST_TOOLS_TWO"; do
  /bin/ln -s /usr/bin/true "$directory/deno"
done
for command in starship gh; do
  /bin/ln -s /usr/bin/true "$HOME/.local/bin/$command"
done
print -r -- ':' > "$fixture/config/zsh/lib/fixture.zsh"
print -r -- '#!/bin/zsh
print -r -- '"'"'autoload -Uz add-zsh-hook
_mise_hook_precmd() {
  path=("$ZSH_TEST_SHIM_ALIAS" "$ZSH_TEST_SHIMS" "$ZSH_TEST_TOOLS"
    "${(@)path:#"$ZSH_TEST_TOOLS_ONE"}")
}
_mise_hook_chpwd() { _mise_hook_precmd; }
add-zsh-hook -d precmd _mise_hook_precmd
add-zsh-hook -d chpwd _mise_hook_chpwd
add-zsh-hook precmd _mise_hook_precmd
add-zsh-hook chpwd _mise_hook_chpwd
_mise_hook_precmd'"'" > "$HOME/.local/bin/mise"
/bin/chmod +x "$HOME/.local/bin/mise"

fail() {
  print -u2 -- "FAIL: $*"
  return 1
}
direct_deno() {
  [[ $(whence -p deno) == "$ZSH_TEST_TOOLS/deno" ]] ||
    fail "shim shadowed the selected Deno: $*"
}

unsetopt nounset
source "$rc"
setopt nounset
direct_deno 'initialization'
for hook in "${precmd_functions[@]}"; do
  "$hook"
done
direct_deno 'first prompt'
unsetopt nounset
source "$rc"
setopt nounset
for hook in "${precmd_functions[@]}"; do
  "$hook"
done
direct_deno 'prompt after reloading .zshrc'
export ZSH_TEST_TOOLS="$ZSH_TEST_TOOLS_TWO"
builtin cd "$fixture/tools-two"
direct_deno 'directory change with a different selected installation'
for hook in "${precmd_functions[@]}"; do
  "$hook"
done
direct_deno 'subsequent prompt'
[[ ${path[-1]} == "$ZSH_TEST_SHIMS" ]] || fail 'shims must remain available as a fallback'
[[ ${path[(Ie)$ZSH_TEST_SHIM_ALIAS]} == 0 ]] || fail 'canonical shim aliases must be removed'
print -r -- 'ok: mise direct tools survive prompt and directory hooks'
