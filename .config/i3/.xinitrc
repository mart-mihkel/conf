setxkbmap -layout ee -variant nodeadkeys
xset r rate 256 32

export XDG_CURRENT_DESKTOP="i3"
exec i3
