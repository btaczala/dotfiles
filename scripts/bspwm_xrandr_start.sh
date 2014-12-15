#!/bin/sh

~/.config/bspwm/panel/panel
sleep 2
stalonetray --dockapp-mode simple &
feh --bg-scale ~/ownCloud/wallpapers/1616699.jpg
conky -c ~/dotfiles/conky/gcalcli &
conky -c ~/dotfiles/conky/panel &
