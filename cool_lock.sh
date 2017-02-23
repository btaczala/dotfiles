#!/bin/bash

icon="$HOME/dotfiles/lock.png"
tmpbg='/tmp/screenshot.png'

mpc_status=`mpc status | grep playing`

if [ ! "$mpc_status" == "" ]; then
    mpc pause
fi

purple-remote "setstatus?status=away&message=afk"
~/dotfiles/skype_away.py away 

#scrot $tmpbg
#convert $tmpbg -scale 25% -scale 400% $tmpbg
#[[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte $tmpbg
/usr/bin/xwobf -s 5 $tmpbg
i3lock -n -i $tmpbg
purple-remote "setstatus?status=available&message="
~/dotfiles/skype_away.py online
rm $tmpbg

if [ ! "$mpc_status" == "" ]; then
    mpc play
fi
