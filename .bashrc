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

fzf-tmux-attach() {
    _session=$(tmux ls | fzf | awk -F ':' '{ print $1 }')
    [[ -n "$_session" ]] && tmux attach -d -t $_session
}

fzf-tmux-new() {
    _dir=$(find . -maxdepth 2 -type d -print | fzf)
    [[ -n "$_dir" ]] && tmux new-session -c $_dir -s $(basename $_dir)
}

alias ta=fzf-tmux-attach
alias tn=fzf-tmux-new

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
