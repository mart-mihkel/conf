[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zhist
precm_functions+=(_prompt)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

function _prompt() {
    ITEMS=""
    BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null)
    VENV=$(echo $VIRTUAL_ENV_PROMPT | tr -d '()')

    [[ -n $VENV ]] && ITEMS="%F{3}$VENV%f "
    [[ -n $BRANCH ]] && ITEMS="$ITEMS%F{5}$BRANCH%f "

    PROMPT="%F{4}%1~%f $ITEMS"
}

autoload -Uz compinit && compinit
zstyle ":completion:*" menu yes select
zstyle ":completion::complete:*" gain-privileges 1

setopt no_case_glob no_case_match hist_ignore_dups inc_append_history

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.local/bin/env
source ~/.cargo/env

alias vim="nvim"
alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias fd="fdfind"
alias bat="batcat"
alias l="ls -lah --color"
alias ll="ls -lh --color"
alias venv="source .venv/bin/activate"
alias cssh='ssh -o ProxyCommand="cloudflared access ssh --hostname %h"'

eval "$(direnv hook zsh)"
