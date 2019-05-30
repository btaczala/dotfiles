#!/bin/bash 

options="play-pause\nstop\nnext\nprevious\nstatus"
option=$(echo -e $options | rofi -dmenu -lines 5 -markup-rows -width 20 -p "spotify")
if [[ "$option" == "status" ]]; then
    status=$(playerctl metadata)
    rofi -e "$status"
else
    playerctl $option
fi
