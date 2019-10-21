#!/bin/bash

rofi_config="$HOME/.config/rofi/config"
gtk_config="$HOME/.config/gtk-3.0/settings.ini"
gtk2_config="$HOME/.gtkrc-2.0"
slack_config="$HOME/.config/Slack/storage/slack-settings"

function colors_terminal() {
    theme=$1
    cd ~/.config/termite/
    ln -sf config.$theme config
    killall -USR1 termite
}

function colors_config() {
    theme=$1
    config_file="$HOME/.current_color"
    if [ -f $config_file ]; then
        rm -rf $config_file
    fi

    echo $theme > $config_file
}

function colors_gtk() {
    theme="$1"
    icon_theme=$2
    sed -i "s/gtk-theme-name.*/gtk-theme-name=$theme/g" $gtk_config
    sed -i "s/gtk-icon-theme-name.*/gtk-icon-theme-name=$icon_theme/g" $gtk_config

    sed -i "s/gtk-theme-name.*/gtk-theme-name=\"$theme\"/g" $gtk2_config
    sed -i "s/gtk-icon-theme-name.*/gtk-icon-theme-name=\"$icon_theme\"/g" $gtk2_config
    gsettings set org.gnome.desktop.interface gtk-theme $theme
}

function colors_rofi() {
    theme=$1
    echo $theme
}

function colors_qt() {
    theme=$1
    icon_theme=$2
    echo "icon_theme=$icon_theme"
    sed -i "s/color_scheme_path.*/color_scheme_path=\/usr\/share\/qt5ct\/colors\/$theme/g" ~/.config/qt5ct/qt5ct.conf
    sed -i "s/icon_theme=.*/icon_theme=$2/g" ~/.config/qt5ct/qt5ct.conf
}

function color_slack() {
    theme=$1
    old_theme=$(cat $slack_config | jq .userTheme)

    sed -i "s/$old_theme/\"$1\"/g" $slack_config
    old_theme=$(cat $slack_config | jq .userTheme)
    echo "New slack theme: $old_theme"
}
