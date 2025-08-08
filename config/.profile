if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.local/bin/env" ] ; then
    source "$HOME/.local/bin/env"
fi

if [ -f "$HOME/.cargo/env" ] ; then
    source "$HOME/.cargo/env"
fi
