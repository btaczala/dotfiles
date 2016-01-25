#!/bin/sh
source ~/.bspwm_theme

if killall panel > /dev/null
then
    bspc config top_padding 0
    killall trayer
else
    bspc config top_padding $PANEL_HEIGHT
    if [[ "`hostname`" == "bata-b5400" ]]; then
        ~/.config/bspwm/panel_b5400/panel &
        sleep 2 
        trayer --SetDockType true --padding 10 --transparent true --alpha 0 --edge top --distance 8 --align right --padding 10 --expand false --widthtype request --heighttype pixel --height 18 --monitor 0 --margin 500 --tint 0x1D1F21 &
    else 
        ~/.config/bspwm/panel/panel &
        sleep 2 
        trayer --SetDockType true --padding 10 --transparent true --alpha 240 --edge top --align left --expand false --widthtype request --heighttype pixel --height 15 --monitor 1 --margin 40 &
    fi
fi

