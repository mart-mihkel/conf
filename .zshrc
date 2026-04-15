[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

function _prompt() {
    _REF=$(git symbolic-ref --short HEAD 2> /dev/null)
    _REF=${_REF:+:%F{5}$_REF%f}
    PROMPT="%F{2}%n@%m%f${_REF}:%F{4}%~%f %% "
}

precmd_functions+=(_prompt)

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
alias fd="fdfind"
alias cal="ncal -C"
alias l="ls -lAh --color"
alias glow="glow --style light"
alias bat="batcat --theme light"
alias venv="source .venv/bin/activate"
