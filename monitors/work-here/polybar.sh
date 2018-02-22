#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config

BAR_MONITOR=DisplayPort-1 polybar main --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r & 
BAR_MONITOR=DisplayPort-0 polybar work_hdmi1 --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r & 
