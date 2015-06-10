#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh 
# set monitor
xrandr --output LVDS1 --off --output VGA1 --auto
xrandr --output HDMI1 --auto --output VGA1 --auto --output VGA1 --right-of HDMI1 --primary

bspc monitor 1 -n VGA1
bspc monitor VGA1 -d '1.mail' 2.web 3.im 4.system 5.dev 6.irc 7.wayland
bspc monitor HDMI1 -d 8.qtcreator 9.git 10.web

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3

~/dotfiles/scripts/bspwm_xrandr_start.sh e
# set rain wallpaper on left monitor
feh --bg-scale ~/drive/wallpapers/rain.png --bg-scale $WALLPAPER

# padding to 0 on left monitor
bspc config top_padding 18
