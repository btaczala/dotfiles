#!/bin/bash


function close_program()
{
    progName=$1
    if [[ -n `pidof $progName` ]]; then
        kill -2 `pidof $progName`
    fi
}
systemctl --user stop mopidy
close_program ncmpcpp
killall skypeforlinux

# kill all terminals
killall termite
