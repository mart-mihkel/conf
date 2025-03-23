[[ $- != *i* ]] && return

PROMPT="%F{4}%1~%f "
precmd_functions+=(_rprompt)

HISTFILE=$ZDOTDIR/.zhist
HISTSIZE=10000
SAVEHIST=10000

ZSH_AUTOSUGGEST_STRATEGY=("completion" "history")

autoload -Uz compinit && compinit
zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs true
zstyle ":completion::complete:*" gain-privileges 1

setopt list_packed
setopt no_case_glob no_case_match
setopt inc_append_history share_history hist_ignore_dups

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias vim="nvim"
alias rm="rm -v"
alias ls="ls --color"
alias l="ls -A --color"

function _rprompt() {
    items=""
    branch=$(git symbolic-ref --short HEAD 2> /dev/null)

    [[ -n $branch ]] && items="$items 󰊢 $branch"
    [[ -n $SSH_TTY ]] && items="$items  %n@%M"

    RPROMPT="%F{8}$items%f"
}
