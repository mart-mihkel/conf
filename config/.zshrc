[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
precmd_functions+=(pprecmd)

function pprecmd() {
    PROMPT="%F{4}%~%f "
    branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    [[ -n $VIRTUAL_ENV_PROMPT ]] && PROMPT="$PROMPT%F{3}$VIRTUAL_ENV_PROMPT%f "
    [[ -n $branch ]] && PROMPT="$PROMPT%F{5}$branch%f "
}

autoload -Uz compinit && compinit
zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs true
zstyle ":completion::complete:*" gain-privileges 1
setopt no_case_glob no_case_match hist_ignore_dups inc_append_history

source ~/.cargo/env
source ~/.local/bin/env
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias vim="nvim"
alias fd="fdfind"
alias bat="batcat"
alias ls="ls --color"
alias ll="ls -lAh --color"
alias venv="source .venv/bin/activate"
alias neofetch="fastfetch --config neofetch"
alias sway="XDG_SCREENSHOTS_DIR=$HOME/Pictures/screenshots sway"
alias cssh='ssh -o ProxyCommand="cloudflared access ssh --hostname %h"'
