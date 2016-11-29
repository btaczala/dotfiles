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
#lemonbuddy work_edp1 --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual & 
polybar only_one -c ~/dotfiles/lemonbuddy/thinkpad/poly_config & 
