#!/bin/bash

# kill trayer
killall panel
killall stalonetray
# set monitor
xrandr --output LVDS1 --auto --output HDMI1 --off --output VGA1 --off
# add padding
bspc config top_padding 15
bspc monitor -d term web mail dev im vi vii viii ix x

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^5
bspc rule -a Pidgin desktop=^5

~/.config/bspwm/panel/panel &
sleep 3
stalonetray --dockapp-mode simple &
