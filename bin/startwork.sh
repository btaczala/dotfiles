#!/bin/sh

function start() {
    nohup $@ > /dev/null 2>&1 &
}

setxkbmap pl

start skype
systemctl --user start mopidy
systemctl --user start gcalcli.timer
systemctl --user start getmail.timer 

ps ax | grep "termite -e mutt" | grep -v grep
if [ ! $? ]; then
    termite  -e 'mutt -F ~/dotfiles/work/mutt/mutt_mobica.muttrc' --name=mutt  --class=mutt &
fi

ps ax | grep /opt/google/chrome/chrome | grep -v grep
if [ ! $? ]; then
    google-chrome-stable --profile-directory="Profile 4" --class=chrome_priv &
    google-chrome-stable --profile-directory="Profile 1" --class=chrome_work &
fi

~/dotfiles/skype_away.py online
