#!/bin/sh

~/.config/bspwm/panel/panel &
sleep 2
trayer --SetDockType true --padding 10 --transparent true --alpha 240 --edge top --align center --expand false --widthtype request --heighttype pixel --height 15 --monitor 1 --margin 40 & 
feh --bg-scale $WALLPAPER &
conky -c ~/dotfiles/conky/gcalcli &
conky -c ~/dotfiles/conky/panel  &
