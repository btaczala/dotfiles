#!/bin/sh

sleep 2
host=`hostname`
if [[ "$host" == "bata-b5400" ]]; then
    ~/.config/bspwm/panel_b5400/panel
else
    ~/.config/bspwm/panel/panel &
    #trayer --SetDockType true --padding 10 --transparent true --alpha 240 --edge top --align left --padding 10 --expand false --widthtype request --heighttype pixel --height 15 --monitor 0 --margin 40 --tint 0x00181818 & 
fi
