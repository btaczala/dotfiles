#!/bin/bash

icon="$HOME/dotfiles/lock.png"

if pgrep -x "swaylock" >/dev/null; then
    exit 1
fi

mpc_status="$(mpc status | grep playing | awk '{print $1}')"

function revert() {
    if [ "$mpc_status" == "[playing]" ]; then
        mpc play
    fi
}

function forget_gpg_pass() {
    echo RELOADAGENT | gpg-connect-agent
}

function unlock_gpg_pass() {
    swaynag -m "remember about pgp" -t warning -e bottom -B unlock "pass private/adguard > /dev/null && killall swaynag"
}

trap revert HUP INT TERM

if [ "$mpc_status" == "[playing]" ]; then
    mpc pause
fi

#grim $tmpbg
background=~/dotfiles/walls/trees.jpg
tmpbg=$(mktemp)
convert -composite $background $HOME/dotfiles/rick.png -gravity South -geometry -20x1200 $background $tmpbg
convert -pointsize 48 -font /usr/share/fonts/TTF/Hack-Regular.ttf -fill white -draw 'text 200,320 "I am sorry but Your opinion means very little to me"' $tmpbg $tmpbg

forget_gpg_pass
swaylock $tmpbg --image $tmpbg $@
unlock_gpg_pass

rm $tmpbg
revert
