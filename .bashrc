[[ $- != *i* ]] && return

PS1="\[\033[01;34m\]\W\[\033[00m\] "
HISTCONTROL=ignoredups

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB:menu-complete"

alias vi="nvim"
alias vim="nvim"

alias l="ls -lhA --color"
alias ls="ls --color"
alias grep="grep --color"

alias tn="tmux new-session -s"
alias ta="tmux attach -d -t"
alias tl="tmux ls"

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
