[[ $- != *i* ]] && return

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

precmd_functions+=(_prompt)

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.local/bin/env
source ~/.cargo/env

autoload -Uz compinit && compinit
zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs true
zstyle ":completion::complete:*" gain-privileges 1

setopt list_packed
setopt no_case_glob no_case_match
setopt inc_append_history share_history hist_ignore_dups

alias vim="nvim"

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"

alias ls="ls --color"
alias la="la -A --color"
alias ll="ls -lAh --color"
 
alias at="source .venv/bin/activate"
alias jl=".venv/bin/jupyter-lab"
alias nb=".venv/bin/jupyter-notebook"

function _prompt() {
    items=""
    branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    venv=$(echo $VIRTUAL_ENV_PROMPT | tr -d '()')

    [[ -n $venv ]] && items="%F{3}$venv%f "
    [[ -n $branch ]] && items="$items%F{5}$branch%f "

    PROMPT="%F{4}%~%f $items"
}
