#!/bin/bash

function start() {
    #nohup $@ > /dev/null 3>&1 &
    swaymsg exec $@
}

#setxkbmap pl

#systemctl --user start mopidy
#systemctl --user start gcalcli.timer
#systemctl --user start getmail.timer 

#out=`ps ax | grep /opt/google/chrome/chrome | grep -v grep`
#if [ "$out" == "" ]; then
    #google-chrome-stable --class=chrome_priv &
#else
    #echo "Chrome is running"
#fi

start firefox
start slack
start google-chrome-stable
