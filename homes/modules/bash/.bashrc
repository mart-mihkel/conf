[[ $- != *i* ]] && return

PS1="\[\033[01;34m\]\W\[\033[00m\] "
HISTCONTROL=ignoredups

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

alias vim="nvim"
alias activate=". .venv/bin/activate"
alias neofetch="fastfetch --config neofetch"

alias l="ls -lA --color"
alias la="ls -la --color"
alias grep="grep --color"

alias headset="bluetoothctl connect 14:3F:A6:DA:AA:00"
alias wake-jaam="ssh alajaam.risuhunnik.xyz 'wol --port=9 9C:6B:00:13:EE:B0'"

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
