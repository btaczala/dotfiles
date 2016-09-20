#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh & 
xrandr --output DP2-1 --auto --output DP2-2 --primary --auto --right-of DP2-1
xrandr --output LVDS1 --off 
xrandr --output eDP1 --off 

bspc monitor DP2-2 -d mail web im system dev irc documents
bspc monitor DP2-1 -d qtcreator dev ssh minicom

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3
bspc rule -a QtCreator desktop=^8

# padding to 0 on left monitor
bspc config top_padding 18

bspc config -m DP2-2 top_padding 20
bspc config -m DP2-1 top_padding 20
lemonbuddy_wrapper work_vga1 & 
lemonbuddy_wrapper work_hdmi1 & 
nitrogen --restore

sleep 2
trayer --SetDockType true --padding 50 --transparent true --alpha 240 --edge top --align left --expand false --widthtype request --heighttype pixel --height 15 --monitor 1 --margin 40 & 

