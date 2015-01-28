#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh
# set monitor
xrandr --output eDP1 --off --output HDMI1 --auto
# add padding
bspc config top_padding 15
bspc monitor -d term web mail dev im vi vii viii ix x
~/dotfiles/scripts/bspwm_xrandr_start.sh & 
