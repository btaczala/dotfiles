#!/bin/sh
# based on http://ebrnd.de/?p=501

backlight-control -s 100
xrandr --output VGA-0 --off --output DVI-0 --off --output LVDS --auto

i3-nagbar -m "EBRND'S SUPER-COOL I3WM SCREEN CONFIG UTILITY" -t warning \
    -b "HDMI + VGA"   "xrandr --output LVDS1 --off  --output HDMI1 --auto --output VGA1 --auto --right-of HDMI1" \
    -b "Laptop only"  "xrandr --output LVDS1 --auto --output HDMI1 --off  --output VGA1 --off" 
