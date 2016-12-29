#!/bin/bash


function close_program()
{
    progName=$1
    if [[ -n `pidof $progName` ]]; then
        kill -2 `pidof $progName`
    fi
}

~/dotfiles/skype_away.py offline
sleep 2
systemctl --user stop mopidy
systemctl --user stop getmail.timer
systemctl --user stop getmail.service
close_program skype
pkill --oldest chrome
pkill --oldest skype
close_program ncmpcpp

# kill all terminals
killall termite
