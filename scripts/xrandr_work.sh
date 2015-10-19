#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh 
# set monitor
xrandr --output HDMI1 --auto --output DVI-1-0 --primary --auto --output DVI-1-0 --right-of HDMI1 
xrandr --output LVDS1 --off 

bspc monitor DVI-1-0  -d mail web im system dev irc documents
bspc monitor HDMI1 -d qtcreator dev ssh minicom

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3

~/dotfiles/scripts/bspwm_xrandr_start.sh e
# padding to 0 on left monitor
bspc config top_padding 18
