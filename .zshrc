[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
precmd_functions+=(_prompt)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

autoload -Uz compinit && compinit

zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs yes
zstyle ":completion::complete:*" gain-privileges yes

setopt no_case_glob no_case_match hist_ignore_dups inc_append_history

source ~/.cargo/env
source ~/.local/bin/env
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(direnv hook zsh)"

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias vim="nvim"
alias l="ls -lAh --color"
alias bat="bat --theme light"
alias glow="glow --style light"
alias venv="source .venv/bin/activate"

function tfzf() {
    PROJECT=$(
        fd -d 1 -t d . ~/git | \
        fzf --gutter " " --pointer " " --delimiter / --with-nth "{5}"
    )

    [[ -z $PROJECT ]] && return 1

    SESSION=$(basename $PROJECT | tr . _)
    if ! tmux has-session -t $SESSION 2>/dev/null; then
        tmux new-session -d -s $SESSION -c $PROJECT
    fi

    if [[ -n $TMUX ]]; then
        CLIENT=$(tmux display-message -p "#{client_name}")
        tmux switch-client -c $CLIENT -t $SESSION
    else
        tmux attach-session -t $SESSION
    fi
}

function _prompt() {
    _REF=$(git symbolic-ref --short HEAD 2> /dev/null)
    _REF=${_REF:+:%F{5}$_REF%f}
    PROMPT="%F{2}%n@%m%f${_REF}:%F{4}%~%f %% "
}
