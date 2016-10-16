#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh
# set monitor
xrandr --output eDP1 --off
xrandr --output DP2-1 --off 
xrandr --output DP2-2 --off
xrandr --output HDMI1 --auto
# add padding
bspc config top_padding 20
bspc monitor -d mail web im dev code system ssh priv 
nitrogen --restore & 
lemonbuddy_wrapper work_edp1 --config=~/dotfiles/lemonbuddy/thinkpad/dual & 
sleep 2
trayer --SetDockType true --padding 50 --transparent true --alpha 240 --edge top --align left --expand false --widthtype request --heighttype pixel --height 15 --monitor 0 --margin 400 & 
