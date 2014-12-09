#!/bin/bash

# kill trayer
killall stalonetray
# set monitor
xrandr --output eDP1 --off --output HDMI1 --auto
# add padding
bspc config top_padding 15
stalonetray --dockapp-mode simple &
