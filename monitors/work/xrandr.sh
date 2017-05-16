#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config

xrandr --output $laptop_display --off
xrandr --output $work_monitor_left --auto 
xrandr --output $work_monitor_right --auto --right-of $work_monitor_left

