[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zshist
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

function _prompt() {
    [[ -n $TMUX ]] && cd .

    local ref
    ref=$(git symbolic-ref --short HEAD 2> /dev/null)
    ref=${ref:+ %F{5} $ref%f}

    local venv
    venv=${VIRTUAL_ENV:+ %F{3} venv%f}

    PROMPT="%F{4}󰉋 %1~%f${ref}${venv}  "
}

precmd_functions+=(_prompt)

export PATH=~/.local/bin:$PATH

autoload -Uz compinit && compinit

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs yes
zstyle ":completion::complete:*" gain-privileges yes

setopt no_case_glob no_case_match hist_ignore_dups inc_append_history

eval "$(direnv hook zsh)"

alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"

alias ..="cd .."
alias ...="cd ../.."

alias l="ls -lAh --color"
alias ll="ls -lh --color"

alias fd="fdfind"
alias bat="batcat --theme light"

alias vim="nvim"
alias vimdiff="nvim -d"

alias cal="ncal -Mb"
alias fetch="fastfetch"
alias diff="diff --color"
alias glow="glow --style light"

alias venv="source .venv/bin/activate"
alias follow="tail --follow --lines +0"
