#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh
# set monitor
xrandr --output eDP1 --auto --output HDMI1 --off
# add padding
bspc config top_padding 15
bspc monitor -d mail web im dev qtcreator vi vii viii ix x
$HOME/.config/bspwm/panel_b5400/panel &
