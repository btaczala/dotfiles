#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh
# set monitor
xrandr --output HDMI1 --primary --auto --output eDP1 --auto --below HDMI1 --output DVI-1-0 --auto --right-of HDMI1
# add padding
bspc config -m HDMI1 top_padding 40
bspc monitor HDMI1 -d [h]mail [h]web [h]qtcreator 
bspc monitor eDP1 -d [edp]term [edp]dev 
bspc monitor DVI-1-0 -d [d]im [d]dlt
export PANEL_WIDTH=1920
$HOME/.config/bspwm/panel_b5400/panel &
bspc config -m eDP1 top_padding 0

# Rules
bspc rule -a Skype desktop=^6
bspc rule -a QtCreator desktop=^3
bspc rule -a dlt_viewer desktop=^7

# Start trayer
killall trayer
trayer --SetDockType true --padding 10 --transparent true --alpha 0 --edge top --distance 8 --align right --padding 10 --expand false --widthtype request --heighttype pixel --height 18 --monitor 0 --margin 500 --tint 0x1D1F21 &
sleep 5
killall trayer
trayer --SetDockType true --padding 10 --transparent true --alpha 0 --edge top --distance 8 --align right --padding 10 --expand false --widthtype request --heighttype pixel --height 18 --monitor 0 --margin 500 --tint 0x1D1F21 &
bspc config -m eDP1 top_padding 0
bspc config -m DVI-1-0 top_padding 0

