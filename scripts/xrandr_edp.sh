#!/bin/bash

# kill trayer
killall panel
killall stalonetray
# set monitor
xrandr --output eDP1 --auto --output HDMI1 --off
# add padding
bspc config top_padding 15
bspc monitor -d term web mail dev im vi vii viii ix x
~/.config/bspwm/panel/panel &
sleep 3
stalonetray --dockapp-mode simple &
