#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config

xrandr --output $laptop_display --auto \
       --output $work_monitor_left --off \
       --output $home_hdmi --off \
       --output $work_monitor_right --off
