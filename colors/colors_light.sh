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
