[[ $- != *i* ]] && return

PS1="\[\033[01;34m\]\W\[\033[00m\] "
HISTCONTROL=ignoredups

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB:menu-complete"

alias vi="nvim"
alias vim="nvim"
alias ssh="kitten ssh"

alias l="ls -hA --color"
alias ls="ls --color"

_fzf-tmux-attach() {
    session=$(tmux ls | fzf | awk -F ':' '{ print $1 }')
    [[ -n "$session" ]] && tmux attach -d -t $session
}

_fzf-tmux-new() {
    dir=$(find . -maxdepth 2 -type d -print | fzf)
    [[ -n "$dir" ]] && tmux new-session -c $dir -s $(basename $dir)
}

alias ta=_fzf-tmux-attach
alias tn=_fzf-tmux-new

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
