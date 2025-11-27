[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zhist
precmd_functions+=(precmd_prompt)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

autoload -Uz compinit && compinit
zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs yes
zstyle ":completion::complete:*" gain-privileges yes

setopt no_case_glob no_case_match hist_ignore_dups inc_append_history

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.local/bin/env
source ~/.cargo/env

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias vim="nvim"
alias fd="fdfind"
alias bat="batcat"
alias l="ls -lah --color"
alias ll="ls -lh --color"
alias venv="source .venv/bin/activate"
alias cssh='ssh -o ProxyCommand="cloudflared access ssh --hostname %h"'

eval "$(direnv hook zsh)"

function tm() {
    PROJECT=$(fd -d=1 -t=d . ~/git | fzf)
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

function precmd_prompt() {
    if [[ -n $TMUX ]]; then
        cd . # hack to refresh prompt in new tmux session
    fi

    ITEMS=""
    BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null)

    [[ -n $VIRTUAL_ENV_PROMPT ]] && ITEMS="%F{3}($VIRTUAL_ENV_PROMPT)%f "
    [[ -n $BRANCH ]] && ITEMS="$ITEMS%F{5}$BRANCH%f "

    PROMPT="%F{4}%1~%f $ITEMS"
}
