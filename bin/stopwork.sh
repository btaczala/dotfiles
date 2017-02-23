#!/bin/bash


function close_program()
{
    progName=$1
    if [[ -n `pidof $progName` ]]; then
        kill -2 `pidof $progName`
    fi
}

purple-remote "setstatus?status=offline&message="
~/dotfiles/skype_away.py offline
nmcli con down id here.com
sleep 2
systemctl --user stop mopidy
systemctl --user stop getmail.timer
systemctl --user stop getmail.service
close_program skype
pkill --oldest chrome
pkill --oldest skype
close_program ncmpcpp
purple-remote quit

# kill all terminals
killall termite
