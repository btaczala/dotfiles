#!/bin/sh
source ~/dotfiles/bspwm/dmenu_env.sh

path=~/dotfiles/bin
bin_file=`ls ~/dotfiles/bin | rofi -dmenu`
exec $path/$bin_file
