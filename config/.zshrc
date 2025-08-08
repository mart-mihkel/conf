[[ $- != *i* ]] && return

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

precmd_functions+=(pprecmd)

function pprecmd() {
    items=""
    branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    [[ -n $VIRTUAL_ENV_PROMPT ]] && items="%F{3}%f "
    [[ -n $branch ]] && items="$items%F{5} $branch%f "
    PROMPT="%F{4}%~%f $items"
}

function tm() {
    dir=$(fdfind -t=d -d=2 . ~ | fzf --preview 'tmux ls' --preview-window=down,25%)
    [[ -n $dir ]] && tmux new-session -A -D -c $dir -s $(basename $dir | tr . _)
}

autoload -Uz compinit && compinit

zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs true
zstyle ":completion::complete:*" gain-privileges 1

setopt list_packed
setopt no_case_glob no_case_match
setopt inc_append_history share_history hist_ignore_dups

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias vim="nvim"
alias fd="fdfind"
alias bat="batcat"
alias ls="ls --color"
alias grep="grep --color"
alias ll="ls -lAh --color"
alias jn=".venv/bin/jupyter-notebook"
alias venv="source .venv/bin/activate"
alias neofetch="fastfetch --config neofetch"
alias cssh='ssh -o ProxyCommand="cloudflared access ssh --hostname %h"'
alias sway="XDG_CURRENT_DESKTOP=sway XDG_SCREENSHOTS_DIR=$HOME/Pictures/screenshots sway"
