#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config

xrandr --output $laptop_display --off --output DP2-1 --off --output DP2-2 --off --output $home_hdmi --auto
