#!/bin/bash

source $HOME/dotfiles/hostconfig/$(hostname)
#polybar only_one -c ~/dotfiles/lemonbuddy/thinkpad/poly_config -r & 
BAR_MONITOR=HDMI-3 polybar main -c ~/dotfiles/lemonbuddy/thinkpad/dual -r &
