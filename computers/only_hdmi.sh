#!/bin/bash

# bspc

killall polybar

bspc monitor eDP1 -r
bspc monitor HDMI1 \
        -d {system,web,slack,rocket,dev,code,docs,music,priv}

bspc wm -o

BAR_MONITOR=HDMI1 BAR_WIRELESS=wlp3s0 BAR_ETH=enp0s31f6 BAR_ADAPTER=AC polybar -r -c ~/dotfiles/lemonbuddy/thinkpad/dual main &
~/dotfiles/computers/move_windows.sh

setxkbmap pl
setxkbmap -option "caps:swapescape"
