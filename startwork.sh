#!/bin/sh

function start() {
    nohup $@ > /dev/null 2>&1 &
}

start pidgin
start skype
systemctl --user start mopidy
systemctl --user start gcalcli.timer
sleep 5
~/dotfiles/skype_away.py online
start supt -e sup
