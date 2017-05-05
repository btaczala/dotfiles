#!/bin/bash

killall Xephyr
sleep 2

current_mon=`bspc query -M | head -1`
width=`bspc query -m $current_mon -T | jq .desktops[1].root.rectangle.width`
height=`bspc query -m $current_mon -T | jq .desktops[1].root.rectangle.height`

echo "Xephyr :1 -screen "$width"x"$height" -dpi 96 -ac &"
Xephyr :1 -screen "$width"x"$height" -dpi 96 -ac &
sleep 3
DISPLAY=:1 openbox & 
DISPLAY=:1 termite & 
DISPLAY=:1 pavucontrol & 
