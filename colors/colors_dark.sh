#!/bin/bash

source $HOME/dotfiles/colors/common.sh

function restart_browsers() {
    killall firefox
    sway exec firefox
}

colors_terminal dark
colors_config dark
colors_gtk "Materia-dark" "Flat-Remix-Green-Dark"
colors_rofi "dark"
colors_qt darker.conf Flat-Remix-Green-Dark
color_slack "dark"

pkill swaybg
swaybg -o DP-2 -i '/home/bartek/dotfiles/walls/LazyDaysII.jpg' -m fill &
swaybg -o HDMI-A-1 -i '/home/bartek/dotfiles/walls/planets.jpg' -m fill &
