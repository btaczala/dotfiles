#!/bin/sh

function start() {
    nohup $@ > /dev/null 2>&1 &
}

setxkbmap pl

start skype
systemctl --user start mopidy
systemctl --user start gcalcli.timer
systemctl --user start getmail.timer 

termite  -e 'mutt -F ~/dotfiles/work/mutt/mutt_mobica.muttrc' --name=mutt  --class=mutt &
google-chrome-stable --profile-directory="Profile 4" --class=chrome_priv &
google-chrome-stable --profile-directory="Profile 1" --class=chrome_work &

sleep 5
~/dotfiles/skype_away.py online
