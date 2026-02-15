[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
precmd_functions+=(precmd)
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

eval "$(direnv hook zsh)"

function precmd() {
    ITEMS=""
    BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null)

    [[ -n $VIRTUAL_ENV_PROMPT ]] && ITEMS="%F{3}($VIRTUAL_ENV_PROMPT)%f "
    [[ -n $CONDA_PROMPT_MODIFIER ]] && ITEMS="%F{2}($CONDA_PROMPT_MODIFIER)%f "
    [[ -n $BRANCH ]] && ITEMS="$ITEMS%F{5}$BRANCH%f "

    PROMPT="%F{4}%1~%f $ITEMS"
}

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
