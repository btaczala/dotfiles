#!/bin/bash

source $HOME/dotfiles/colors/common.sh

function restart_browsers() {
    killall firefox
    sway exec firefox
}

colors_terminal light
colors_config light
colors_gtk "Materia-light" "Flat-Remix-Green-Light"
colors_rofi "light"
colors_qt airy.conf Flat-Remix-Green-Light
color_slack "light"

pkill swaybg
swaybg -o DP-2 -i '/home/bartek/dotfiles/walls/LazyDaysII.jpg' -m fill &
swaybg -o HDMI-A-1 -i '/home/bartek/dotfiles/walls/Beautiful-Lake-4K-Wallpaper-3840x2160.jpg' -m fill &
