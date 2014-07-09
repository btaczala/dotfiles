#!/bin/bash


function close_program()
{
    progName=$1
    if [[ -n `pidof $progName` ]]; then
        kill -2 `pidof $progName`
    fi
}

kill `ps ax | grep qtcre | grep Shoo | awk {'print $1'}`
~/dotfiles/skype_away.py offline
sleep 2
purple-remote quit

close_program firefox
sleep 1
akonadictl stop
close_program kmail
nmcli con down id mob-wawa
nmcli con down id Nokia
systemctl --user stop mopidy
close_program skype
close_program ncmpcpp
