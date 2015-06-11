#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh 
# set monitor
xrandr --output HDMI1 --auto --output VGA1 --auto --output VGA1 --right-of HDMI1 
xrandr --output LVDS1 --off --output VGA1 --auto --primary

bspc monitor HDMI1 -d qtcreator git web
bspc monitor VGA1 -d mail web im system dev irc wayland

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3

~/dotfiles/scripts/bspwm_xrandr_start.sh e
# set rain wallpaper on left monitor
feh --bg-scale ~/wallpaper.png --bg-scale $WALLPAPER

# padding to 0 on left monitor
bspc config top_padding 18
