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
