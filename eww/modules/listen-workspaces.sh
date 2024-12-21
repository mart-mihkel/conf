#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

hyprctl workspaces -j | jq -c 'map({id: .id})'
socat -u UNIX-CONNECT:$SOCKET - | while read -r line; do
    hyprctl workspaces -j | jq -c 'map({id: .id})'
done
