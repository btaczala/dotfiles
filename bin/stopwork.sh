#!/bin/bash


function close_program()
{
    progName=$1
    if [[ -n `pidof $progName` ]]; then
        kill -2 `pidof $progName`
    fi
}

task sync

~/dotfiles/skype_away.py offline
systemctl --user stop mopidy
close_program skype
killall skype
close_program ncmpcpp

i3lock
