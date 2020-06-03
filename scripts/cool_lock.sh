#!/bin/bash

icon="$HOME/dotfiles/lock.png"
tmpbg='/tmp/screenshot.png'

if pgrep -x "i3lock" > /dev/null
then
    exit 1
fi

mpc_status=$(playerctl status)

function irc_away
{
    msg=$1
    fifo=`find $HOME/.weechat -name weechat_fifo*` 
    if [[ ! "$fifo" == "" ]]; then
        echo "irc.server.jlr */away $msg" > $fifo
    fi
}

function revert() {
    xset dpms 0 0 0
    rm $tmpbg
    setxkbmap pl
    if [ "$mpc_status" == "Playing" ]; then
        playerctl play
    fi
}

trap revert HUP INT TERM

if [ "$mpc_status" == "Playing" ]; then
    playerctl pause
fi

/usr/bin/xwobf -s 5 $tmpbg
convert -composite $tmpbg $HOME/dotfiles/rick.png -gravity South -geometry -20x1200 $tmpbg
i3lock -n -i $tmpbg -e
revert

