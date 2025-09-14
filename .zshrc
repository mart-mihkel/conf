[[ $- != *i* ]] && return

SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zhist
PROMPT="%F{4}%~%f "
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

autoload -Uz compinit && compinit
zstyle ":completion:*" menu yes select
zstyle ":completion:*" special-dirs true
zstyle ":completion::complete:*" gain-privileges 1
setopt no_case_glob no_case_match hist_ignore_dups inc_append_history
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.local/bin/env
source ~/.cargo/env
alias vim="nvim"
alias rm="rm -v"
alias cp="cp -v"
alias mv="mv -v"
alias fd="fdfind"
alias bat="batcat"
alias ll="ls -lah --color"
alias venv="source .venv/bin/activate"
alias cssh='ssh -o ProxyCommand="cloudflared access ssh --hostname %h"'
eval "$(direnv hook zsh)"
