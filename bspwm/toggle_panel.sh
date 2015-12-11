#!/bin/sh
source ~/.bspwm_theme

if killall panel > /dev/null
then
    bspc config top_padding 0
    killall trayer
else
    bspc config top_padding $PANEL_HEIGHT
    ~/.config/bspwm/panel/panel &
    sleep 2 
    trayer --SetDockType true --padding 10 --transparent true --alpha 240 --edge top --align left --expand false --widthtype request --heighttype pixel --height 15 --monitor 1 --margin 40 &
fi

