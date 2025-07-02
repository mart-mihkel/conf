[[ $- != *i* ]] && return

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

precmd_functions+=(_prompt)

function _prompt() {
    items=""
    branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    [[ -n $VIRTUAL_ENV_PROMPT ]] && items="%F{3}%f "
    [[ -n $branch ]] && items="$items%F{5} $branch%f "
    PROMPT="%F{4}%1~%f $items"
}

autoload -Uz compinit && compinit
zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs true
zstyle ":completion::complete:*" gain-privileges 1

setopt list_packed
setopt no_case_glob no_case_match
setopt inc_append_history share_history hist_ignore_dups

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"

alias ls="ls --color"
alias la="la -A --color"
alias ll="ls -lAh --color"

alias vim="nvim"

export EDITOR="vim"

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
