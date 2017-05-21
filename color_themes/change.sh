#!/bin/bash
selected=`echo -e "light\ndark" | rofi -dmenu`

if [[ "$selected" == "" ]]; then
    exit
fi

echo "source $HOME/dotfiles/color_themes/$selected"
source $HOME/dotfiles/color_themes/$selected

rm $HOME/.config/termite/config -rf
ln -s $termite_theme $HOME/.config/termite/config
killall -s USR1 termite
