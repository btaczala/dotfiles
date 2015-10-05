#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh
# set monitor
xrandr --output HDMI1 --primary --auto --output eDP1 --auto --below HDMI1
# add padding
bspc config -m HDMI1 top_padding 40
bspc monitor eDP1 -d [2]term [2]dev [2]ssh
bspc monitor HDMI1 -d [1]mail [1]web [1]im [1]qtcreator
$HOME/.config/bspwm/panel_b5400/panel &
bspc config -m eDP1 top_padding 0

# Rules
bspc rule -a Skype desktop=^3
bspc rule -a QtCreator desktop=^4

# Start trayer
killall trayer
trayer --SetDockType true --padding 10 --transparent true --alpha 0 --edge top --distance 8 --align right --padding 10 --expand false --widthtype request --heighttype pixel --height 18 --monitor 0 --margin 500 --tint 0x1D1F21 &
sleep 5
killall trayer
trayer --SetDockType true --padding 10 --transparent true --alpha 0 --edge top --distance 8 --align right --padding 10 --expand false --widthtype request --heighttype pixel --height 18 --monitor 0 --margin 500 --tint 0x1D1F21 &
bspc config -m eDP1 top_padding 0
