[[ $- != *i* ]] && return

PS1="\[\033[01;34m\]\W\[\033[00m\] "
HISTCONTROL=ignoredups

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB:menu-complete"

alias vim="nvim"
alias ls="ls --color"
alias l="ls -hA --color"

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
