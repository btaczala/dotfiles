#!/bin/sh

bspc config top_padding 14
~/.config/bspwm/panel/panel &
sleep 2
stalonetray --dockapp-mode simple &
feh --bg-scale $WALLPAPER &
conky -c ~/dotfiles/conky/gcalcli &
conky -c ~/dotfiles/conky/panel &
