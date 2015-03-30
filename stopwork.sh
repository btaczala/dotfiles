#!/bin/bash


function close_program()
{
    progName=$1
    if [[ -n `pidof $progName` ]]; then
        kill -2 `pidof $progName`
    fi
}

echo "Sync drive"
#cd ~/drive
#drive push
#cd -
task sync


~/dotfiles/skype_away.py offline
sleep 2
purple-remote quit
close_program firefox
sleep 1
nmcli con down id mobica
nmcli con down id Here
systemctl --user stop mopidy
close_program skype
killall skype
close_program ncmpcpp

# close sup
sup_id=`xdotool search --name mutt | head -1`
xdotool windowactivate --sync $sup_id key q
