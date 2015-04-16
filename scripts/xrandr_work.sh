#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh 
# set monitor
xrandr --output LVDS1 --off --output VGA1 --auto
xrandr --output HDMI1 --auto --output VGA1 --auto --output VGA1 --right-of HDMI1
xrandr --output HDMI1 --rotate left

bspc monitor 1 -n VGA1
#bspc monitor VGA1 -d 1/VGA1/mail 2/VGA1/web 3/VGA1/im 4/VGA1/term 5/VGA1/VM
#bspc monitor HDMI1 -d 6/HDMI1/dev 7/HDMI1/git 8/HDMI1/term
bspc monitor VGA1 -d mail web im system dev irc wayland
bspc monitor HDMI1 -d qtcreator git web

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3

~/dotfiles/scripts/bspwm_xrandr_start.sh e
# set rain wallpaper on left monitor
feh --bg-scale ~/drive/wallpapers/rain.png --bg-scale $WALLPAPER

# padding to 0 on left monitor
bspc config -m HDMI1 top_padding 0
bspc config -m HDMI1 window_gap 1
