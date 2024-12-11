[[ $- != *i* ]] && return

PS1="\[\033[01;34m\]\W\[\033[00m\] "
HISTCONTROL=ignoredups

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t $HOSTNAME || tmux new-session -s $HOSTNAME
fi

alias vim="nvim"
alias ls="ls --color=auto"
alias ll="ls --color=auto -la"
alias grep="grep --color=auto"
alias headset="bluetoothctl connect 14:3F:A6:DA:AA:00"
alias wake-jaam="ssh kubujuss@alajaam.risuhunnik.xyz 'wol --port=9 9C:6B:00:13:EE:B0'"

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
