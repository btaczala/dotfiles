#!/bin/sh

function start() {
    nohup $@ > /dev/null 2>&1 &
}

setxkbmap pl

start skype
systemctl --user start mopidy
systemctl --user start gcalcli.timer
systemctl --user start getmail.timer 

out=`ps ax | grep "termite -e tmuxinator start mails" | grep -v grep`
if [ "$out" == "" ]; then
    termite  -e 'tmuxinator start mails' --name=mutt  --class=mutt &
else
    echo "Mutt is running"
fi

out=`ps ax | grep /opt/google/chrome/chrome | grep -v grep`
if [ "$out" == "" ]; then
    google-chrome-stable --profile-directory="Profile 4" --class=chrome_priv &
    google-chrome-stable --profile-directory="Profile 1" --class=chrome_work &
else
    echo "Chrome is running"
fi

sleep 2
~/dotfiles/skype_away.py online
