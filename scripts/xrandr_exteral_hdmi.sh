#!/bin/bash

~/dotfiles/scripts/bspwm_xrandr_stop.sh
# set monitor
xrandr --output eDP1 --off --output HDMI1 --auto
# add padding
bspc config top_padding 15
bspc monitor -d term web mail im dev dev2 vii viii ix spotify
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^4
bspc rule -a Pidgin desktop=^4

~/dotfiles/scripts/bspwm_xrandr_start.sh & 

# Start trayer
trayer --SetDockType true --padding 10 --transparent true --alpha 0 --edge top --distance 8 --align right --padding 10 --expand false --widthtype request --heighttype pixel --height 18 --monitor 0 --margin 500 --tint 0x1D1F21 &
