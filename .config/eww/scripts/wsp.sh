#!/bin/bash

if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

    if [[ "$1" == "-a" ]]; then
        socat -u UNIX-CONNECT:$socket - |
            stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' \
                -e '/^focusedmon>>/ {print $3}'
    elif [[ "$1" == "-w" ]]; then
        hyprctl dispatch workspace $2
    else
        socat -u UNIX-CONNECT:$socket - | while read -r; do
            #  󰣇  󱄅 󰣨 󰕈 󰣛 󰣭
            hyprctl clients -j | jq -c '
                [[.[] | {id:.workspace.id,class}] |
                unique_by(.id) | sort_by(.id)[] |
                if .class == "chromium" then
                    {id,icon:""}
                elif .class == "firefox" then
                    {id,icon:"󰈹"}
                elif .class == "Spotify" then
                    {id,icon:"󰓇"}
                elif .class == "discord" then
                    {id,icon:""}
                elif .class == "com.mitchellh.ghostty" then
                    {id,icon:"󱙝"}
                elif .class == "Alacritty" then
                    {id,icon:"󱎯"}
                elif .class == "kitty" then
                    {id,icon:"󰄛"}
                elif .class == "Slack" then
                    {id,icon:""}
                elif .class == "steam" then
                    {id,icon:"󰓓"}
                elif .class == "vlc" then
                    {id,icon:"󰕼"}
                else
                    {id,icon:""}
                end]'
        done
    fi
fi

if [[ "$XDG_CURRENT_DESKTOP" == "i3" ]]; then
    if [[ "$1" == "-a" ]]; then
        i3-msg -m -t subscribe '[ "workspace" ]' | while read -r event; do
            echo $event | jq -r 'select(.change == "focus").current.name'
        done
    elif [[ "$1" == "-w" ]]; then
        i3-msg workspace $2
    else
        echo '[{"id":1,"icon":1}]'
        i3-msg -m -t subscribe '[ "workspace" ]' | while read -r _; do
            i3-msg -t get_workspaces | jq -c '[.[] | {id:.num,icon:.name}]'
        done
    fi
fi
