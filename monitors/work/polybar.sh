#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config

BAR_MONITOR=$work_monitor_right polybar main --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r & 
BAR_MONITOR=$work_monitor_left polybar work_hdmi1 --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r & 
