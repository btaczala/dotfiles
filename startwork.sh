#!/bin/sh

function start() {
    nohup $1 > /dev/null 2>&1 &
}

start skype
start pidgin 
truecrypt /dev/sda4 -p=bs8b@_@kmM & 
systemctl --user start mopidy
systemctl --user start gcalcli.timer
sleep 5
~/dotfiles/skype_away.py online
