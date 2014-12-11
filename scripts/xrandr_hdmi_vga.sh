#!/bin/bash

# kill trayer
killall panel
killall stalonetray
# set monitor
xrandr --output LVDS1 --off --output HDMI1 --auto --output VGA1 --auto --output VGA1 --right-of HDMI1

bspc monitor 1 -n VGA1
bspc monitor VGA1 -d 1/VGA1/mail 2/VGA1/web 3/VGA1/im 4/VGA1/term
bspc monitor HDMI1 -d 5/HDMI1/dev 6/HDMI1/git 7/HDMI1/term

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3

nohup ~/.config/bspwm/panel/panel &
sleep 3
nohup stalonetray --dockapp-mode simple &
