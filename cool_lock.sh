#!/bin/bash

icon="$HOME/dotfiles/lock.png"
tmpbg='/tmp/screenshot.png'

mpc_status=`mpc status | grep playing`

if [ ! "$mpc_status" == "" ]; then
    mpc pause
fi

if [ "`playerctl status`" == "Playing" ]; then 
    playerctl pause
fi

purple-remote "setstatus?status=away&message=afk"

/usr/bin/xwobf -s 5 $tmpbg
i3lock -n -i $tmpbg
purple-remote "setstatus?status=available&message="
rm $tmpbg

if [ ! "$mpc_status" == "" ]; then
    mpc play
fi

if [ "`playerctl status`" == "Paused" ];then 
    playerctl play
fi
