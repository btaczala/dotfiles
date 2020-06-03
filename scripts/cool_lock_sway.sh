#!/bin/bash

icon="$HOME/dotfiles/lock.png"

if pgrep -x "swaylock" >/dev/null; then
    exit 1
fi

#mpc_status="$(mpc status | grep playing | awk '{print $1}')"
mpc_status="$(playerctl status 2>/dev/null)"

was_playing() {
    if [ "$mpc_status" = "[playing]" ] | [ "$mpc_status" = "Playing" ]; then
        return 0
    fi
    return 1
}

function revert() {
    if was_playing; then playerctl play; fi
}

trap revert HUP INT TERM

if was_playing; then playerctl pause; fi

background=~/dotfiles/walls/trees.jpg
tmpbg=$(mktemp)
convert -composite $background $HOME/dotfiles/rick.png -gravity South -geometry -20x1200 $background $tmpbg
convert -pointsize 48 -font /usr/share/fonts/TTF/Hack-Regular.ttf -fill white -draw 'text 200,320 "I am sorry but Your opinion means very little to me"' $tmpbg $tmpbg

swaylock $tmpbg --image $tmpbg $@

rm $tmpbg
revert
