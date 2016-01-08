#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh 
# set monitor
xrandr --output HDMI1 --auto --output VGA1 --primary --auto --right-of HDMI1 
xrandr --output LVDS1 --off 

bspc monitor VGA1  -d mail web im system dev irc documents
bspc monitor HDMI1 -d qtcreator dev ssh minicom

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3

~/dotfiles/scripts/bspwm_xrandr_start.sh
# padding to 0 on left monitor
bspc config top_padding 18

sleep 2
bspc monitor -s DVI-I-1

sleep 2
trayer --SetDockType true --padding 10 --transparent true --alpha 240 --edge top --align left --expand false --widthtype request --heighttype pixel --height 15 --monitor 1 --margin 40 & 
