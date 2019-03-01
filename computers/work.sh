#!/bin/bash

# bspc

killall polybar

bspc monitor eDP1 -r
bspc monitor HDMI1 -r
bspc monitor DP3-2 \
        -d {code,dev,docs,priv}
bspc monitor DP3-1 \
        -d {system,web,slack,rocket,music}

bspc wm -o

BAR_MONITOR=DP3-1 BAR_WIRELESS=wlp3s0 BAR_ETH=enp0s31f6 BAR_ADAPTER=AC polybar -r -c ~/dotfiles/lemonbuddy/thinkpad/dual main &
BAR_MONITOR=DP3-2 BAR_WIRELESS=wlp3s0 polybar -r -c ~/dotfiles/lemonbuddy/thinkpad/dual work_hdmi1 &
~/dotfiles/computers/move_windows.sh
bspc monitor -s DP3-1

setxkbmap pl
setxkbmap -option "caps:swapescape"
