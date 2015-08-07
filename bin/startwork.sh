#!/bin/sh

function start() {
    nohup $@ > /dev/null 2>&1 &
}


start skype
systemctl --user start mopidy
systemctl --user start gcalcli.timer
systemctl --user start mbsync.timer 
sleep 5
~/dotfiles/skype_away.py online

task sync
yaourt -Syy
