#!/bin/sh

set -eu

apk add --no-cache tmux ncurses-terminfo >/dev/null

mkdir -p /tmp/bundle/libexec /tmp/bundle/lib /tmp/bundle/share/terminfo
cp /usr/bin/tmux /tmp/bundle/libexec/tmux
cp /lib/ld-musl-x86_64.so.1 /tmp/bundle/lib/ld-musl-x86_64.so.1
cp -L /usr/lib/libncursesw.so.6 /tmp/bundle/lib/libncursesw.so.6
cp -L /usr/lib/libevent_core-2.1.so.7 /tmp/bundle/lib/libevent_core-2.1.so.7
cp -a /usr/share/terminfo/. /tmp/bundle/share/terminfo/
cp -a /etc/terminfo/. /tmp/bundle/share/terminfo/

/tmp/bundle/lib/ld-musl-x86_64.so.1 --library-path /tmp/bundle/lib /tmp/bundle/libexec/tmux -V

tar -czf /output/tmux-bundle.tar.gz -C /tmp/bundle .
