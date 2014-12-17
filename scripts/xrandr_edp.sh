#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh
# set monitor
xrandr --output eDP1 --auto --output HDMI1 --off
# add padding
bspc config top_padding 15
bspc monitor -d term web mail dev im vi vii viii ix x
~/dotfiles/scripts/bspwm_xrandr_start.sh & 
