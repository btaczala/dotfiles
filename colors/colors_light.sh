#!/bin/bash

rofi_config="$HOME/.config/rofi/config"
gtk_config="$HOME/.config/gtk-3.0/settings.ini"

function colors_terminal() {
    cd ~/.config/termite/
    ln -sf config.light config
}

function colors_config() {
    config_file="$HOME/.current_color"
    if [ -f $config_file ]; then
        rm -rf $config_file
    fi

    echo light > $config_file
}

function colors_gtk() {
    sed -i 's/gtk-theme-name.*/gtk-theme-name=Materia-light/g' $gtk_config
    sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name=Flat-Remix-Light/g' $gtk_config
    sed -i 's/Materia-dark/Materia-light/g' ~/.gtkrc-2.0
    sed -i 's/Flat-Remix-Dark/Flat-Remix-Light/g' ~/.gtkrc-2.0
    gsettings set org.gnome.desktop.interface gtk-theme 'Materia-light'

}

function colors_rofi() {
    sed -i 's/dark/light/g' $rofi_config
    killall -USR1 termite
}

function colors_qt() {
    sed -i '/icon_theme.*/d' ~/.config/qt5ct/qt5ct.conf
    sed -i 's/color_scheme_path.*/color_scheme_path=\/usr\/share\/qt5ct\/colors\/airy.conf/g' ~/.config/qt5ct/qt5ct.conf
}

function restart_browsers() {
    killall firefox
    sway exec firefox
}

colors_terminal
colors_config
colors_gtk
colors_rofi
colors_qt
