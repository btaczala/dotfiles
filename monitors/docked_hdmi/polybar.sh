#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config
BAR_MONITOR=$home_hdmi polybar main --config=$HOME/dotfiles/lemonbuddy/thinkpad/dual -r &

