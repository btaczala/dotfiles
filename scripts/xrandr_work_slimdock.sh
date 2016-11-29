#!/bin/bash
~/dotfiles/scripts/bspwm_xrandr_stop.sh
#xrandr --output VIRTUAL1 --off --output eDP1 --off --output DP1 --off --output DP2-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP2-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DP2-3 --off --output HDMI2 --off --output HDMI1 --off --output VGA1 --off --output DP2 --off
xrandr --output DP2-1 --auto
xrandr --output DP2-2 --mode 1920x1080 --right-of DP2-1
xrandr --output eDP1 --off

bspc monitor DP2-2 -d mail web im system dev docs
bspc monitor DP2-1 -d code dev ssh priv

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3
bspc rule -a QtCreator desktop=^8

# padding to 0 on left monitor
bspc config top_padding 18

bspc config -m DP2-2 top_padding 20
bspc config -m DP2-1 top_padding 20
bspc monitor -s DP2-2
lemonbuddy work_vga1 --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r & 
lemonbuddy work_hdmi1 --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r & 
nitrogen --restore

