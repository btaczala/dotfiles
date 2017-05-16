#!/bin/bash
source $HOME/dotfiles/monitors/`hostname`.config

BAR_MONITOR=$laptop_display polybar main -c ~/dotfiles/lemonbuddy/thinkpad/dual -r & 
