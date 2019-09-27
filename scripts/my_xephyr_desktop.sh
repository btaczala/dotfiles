#!/bin/bash

killall Xephyr
sleep 1

s_width=$(swaymsg -t get_outputs -r | jq '.[0].rect.width')
s_height=$(swaymsg -t get_outputs -r | jq '.[0].rect.height')

width=$(echo "$s_width-40" | bc)
height=$(echo "$s_height-40" | bc)

echo "Xephyr :1 -screen "$width"x"$height" -dpi 96 -ac &"
Xephyr :1 -screen "$width"x"$height" -dpi 96 -ac &
sleep 1
DISPLAY=:1 openbox &
