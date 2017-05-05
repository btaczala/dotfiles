#!/bin/bash

function start() {
    nohup $@ > /dev/null 2>&1 &
}

setxkbmap pl

start skypeforlinux
systemctl --user start mopidy
systemctl --user start gcalcli.timer
systemctl --user start getmail.timer 

out=`ps ax | grep /opt/google/chrome/chrome | grep -v grep`
if [ "$out" == "" ]; then
    google-chrome-stable --profile-directory="Profile 4" --class=chrome_priv &
    google-chrome-stable --profile-directory="Profile 1" --class=chrome_work &
else
    echo "Chrome is running"
fi

sleep 2
