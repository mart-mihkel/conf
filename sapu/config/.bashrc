[[ $- != *i* ]] && return

if [[ -r "$HOME/.local/share/blesh/ble.sh" ]]; then
    # shellcheck disable=SC1091
    source "$HOME/.local/share/blesh/ble.sh" --attach=none
fi

_prompt() {
    _ref=$(git symbolic-ref --short HEAD 2> /dev/null)
    PS1='\[\e[32m\]\h\[\e[0m\] \[\e[34m\]\W\[\e[0m\]\[\e[35m\]${_ref:+ git:${_ref}}\[\e[0m\]\[\e[33m\]${VIRTUAL_ENV:+ py:venv}\[\e[0m\] % '
}

PROMPT_COMMAND="_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"

alias ..="cd .."
alias ...="cd ../.."

alias ls="eza"
alias ll="eza --long --all"
alias l="eza --long --all --no-permissions --no-user"

alias bat="bat --theme light"
alias cat="bat --theme light --plain"

alias diff="diff --color"

alias venv="source .venv/bin/activate"
alias follow="tail --follow --lines +0"

export PATH="$HOME/.local/bin:$PATH"

eval "$(direnv hook bash)"
eval "$(just --completions bash)"

if [[ -n ${BLE_VERSION:-} ]]; then
    ble-attach
fi
