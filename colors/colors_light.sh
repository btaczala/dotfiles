#!/bin/bash

rofi_config="$HOME/.config/rofi/config"
gtk_config="$HOME/.config/gtk-3.0/settings.ini"

function colors_gtk() {
    sed -i 's/gtk-theme-name.*/gtk-theme-name=Materia-light/g' $gtk_config
    sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name=Flat-Remix-Light/g' $gtk_config
    sed -i 's/Materia-dark/Materia-light/g' ~/.gtkrc-2.0
    sed -i 's/Flat-Remix-Dark/Flat-Remix-Light/g' ~/.gtkrc-2.0
}

function colors_rofi() {
    sed -i 's/dark/light/g' $rofi_config
}

function colors_qt() {
    sed -i 's/color_scheme_path.*/color_scheme_path=\/usr\/share\/qt5ct\/colors\/airy.conf/g' ~/.config/qt5ct/qt5ct.conf
}
function restart_browsers() {
    killall firefox
    killall chrome
    firefox & 
    /usr/bin/google-chrome-stable & 
}

wal -l --theme base16-github

colors_gtk
colors_rofi
colors_qt
restart_browsers