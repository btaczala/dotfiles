#!/bin/bash


function close_program()
{
    progName=$1
    if [[ -n `pidof $progName` ]]; then
        kill -2 `pidof $progName`
    fi
}

#task sync

~/dotfiles/skype_away.py offline
systemctl --user stop mopidy
close_program skype
killall skype
killall chrome
killall firefox
killall hangups
killall mutt
close_program ncmpcpp

~/dotfiles/cool_lock.sh
