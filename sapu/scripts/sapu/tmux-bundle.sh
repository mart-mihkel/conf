#!/bin/sh

BUNDLE="${HOME}/.local/share/sapu-shell"
export TERMINFO_DIRS="${BUNDLE}/share/terminfo${TERMINFO_DIRS:+:${TERMINFO_DIRS}}:/etc/terminfo:/lib/terminfo:/usr/share/terminfo"
exec "${BUNDLE}/lib/ld-musl-x86_64.so.1" --library-path "${BUNDLE}/lib" "${BUNDLE}/libexec/tmux" "$@"
