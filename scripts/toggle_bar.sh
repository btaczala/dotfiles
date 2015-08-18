#!/bin/sh

# check if visible
if xdotool search --onlyvisible --name 'bar'; then
    # visible, hide it then!
    bars=`xdotool search --onlyvisible --name 'bar'`
    for bar in $bars 
    do
        xdotool windowunmap $bar
    done
    bspc config top_padding 0

    #hide stalonetray!
    xdotool search --pid `pidof trayer` --name 'trayer' windowunmap
else
    bars=`xdotool search --name 'bar'`
    for bar in $bars 
    do
        xdotool windowmap $bar
    done
    bspc config top_padding 15
    xdotool search --pid `pidof trayer` --name 'trayer' windowmap
fi
