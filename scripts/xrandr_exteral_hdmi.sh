#!/bin/bash

# kill trayer
killall trayer
# set monitor
xrandr --output eDP1 --off --output HDMI1 --auto
# add padding
bspc config top_padding 15
trayer --edge top --width 100 --widthtype pixel --align left --height 13 --margin 60 --tint 0xFF1f1f1f --transparent true --alpha 0 &
