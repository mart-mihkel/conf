[[ $- != *i* ]] && return

PROMPT="%F{4}%1~%f "
precmd_functions+=(_rprompt)

HISTFILE=~/.zhist
HISTSIZE=10000
SAVEHIST=10000

ZSH_AUTOSUGGEST_STRATEGY=("completion" "history")

autoload -Uz compinit && compinit
zstyle ":completion:*" special-dirs true
zstyle ":completion::complete:*" gain-privileges 1

setopt no_case_glob no_case_match
setopt inc_append_history share_history hist_ignore_dups

bindkey "^w" forward-word
bindkey "^b" backward-word
bindkey "^k" up-line-or-history
bindkey "^j" down-line-or-history

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias vim="nvim"
alias ls="ls --color"
alias l="ls -A --color"

function tm() {
    sessions=$(tmux ls 2> /dev/null)
    dir=$(find ~/git ~/ut -mindepth 1 -maxdepth 1 -type d | fzf --header "$sessions" --header-border sharp --header-label " Running sessions ")

    if [[ -z $dir ]]; then
        return
    fi

    session=$(basename $dir | tr . _)

    if [[ -z $TMUX ]]; then
        tmux new-session -Ac $dir -s $session
        return
    fi

    if ! tmux has-session -t $session 2> /dev/null; then
        tmux new-session -dc $dir -s $session
    fi

    client=$(tmux display-message -p '#{client_name}')
    tmux switch-client -c $client -t $session
}

function _rprompt() {
    #  󰣇  󱄅 󰣨 󰕈 󰣛 󰣭      
    branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    [[ -z $branch ]] && RPROMPT="%F{8} %f" || RPROMPT="%F{8}󰊢 $branch%f"
}
