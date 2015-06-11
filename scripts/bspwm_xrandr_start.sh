#!/bin/sh

~/.config/bspwm/panel/panel &
sleep 2
trayer --SetDockType true --padding 10 --transparent true --alpha 240 --edge top --align left --padding 10 --expand false --widthtype request --heighttype pixel --height 15 --monitor 0 --margin 40 --tint 0x00181818 & 
feh --bg-scale $WALLPAPER &
conky -c ~/dotfiles/conky/gcalcli &
conky -c ~/dotfiles/conky/panel  &
