#!/bin/bash
source $HOME/dotfiles/monitors/`hostname`.config
BAR_WIRELESS=$BAR_WIRELESS BAR_ETH=$BAR_ETH BAR_ADAPTER=$BAR_ADAPTER BAR_MONITOR=$laptop_display polybar main --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r &
