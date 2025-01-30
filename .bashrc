[[ $- != *i* ]] && return

PS1="\[\033[01;34m\]\W\[\033[00m\] "
HISTCONTROL=ignoredups

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

alias ls="ls --color"
alias l="ls -lhA --color"
alias la="ls -lha --color"
alias grep="grep --color"

alias vim="nvim"
alias neofetch="fastfetch"

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
