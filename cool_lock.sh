#!/bin/bash

function irc_away
{
    msg=$1
    fifo=`find $HOME/.weechat -name weechat_fifo*` 
    if [[ ! "$fifo" == "" ]]; then
        echo "irc.server.jlr */away $msg" > $fifo
    fi
}

icon="$HOME/dotfiles/lock.png"
tmpbg='/tmp/screenshot.png'

mpc_status=`mpc status | grep playing`

if [ ! "$mpc_status" == "" ]; then
    mpc pause
fi

purple-remote "setstatus?status=away&message="
/usr/bin/xwobf -s 5 $tmpbg
i3lock -n -i $tmpbg
rm $tmpbg
purple-remote "setstatus?status=available&message="

if [ ! "$mpc_status" == "" ]; then
    mpc play
fi

setxkbmap pl
