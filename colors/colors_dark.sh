#!/bin/bash

rofi_config="$HOME/.config/rofi/config"
gtk_config="$HOME/.config/gtk-3.0/settings.ini"

function colors_gtk() {
    sed -i 's/gtk-theme-name.*/gtk-theme-name=Materia-dark/g' $gtk_config
    sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name=Flat-Remix-Dark/g' $gtk_config
    sed -i 's/Materia-light/Materia-dark/g' ~/.gtkrc-2.0
    sed -i 's/Flat-Remix-Light/Flat-Remix-Dark/g' ~/.gtkrc-2.0
}

function colors_rofi() {
    sed -i 's/light/dark/g' $rofi_config
}

function colors_qt() {
    sed -i 's/color_scheme_path.*/color_scheme_path=\/usr\/share\/qt5ct\/colors\/darker.conf/g' ~/.config/qt5ct/qt5ct.conf
}

function restart_browsers() {
    killall firefox
    killall chrome
    sway exec firefox
    sway exec google-chrome-stable 
}

wal --theme base16-atelier-forest

colors_gtk
colors_rofi
colors_qt

restart_browsers
