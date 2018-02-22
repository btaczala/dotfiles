#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config

bspc monitor DisplayPort-1 -d mail web im irc system vm
bspc monitor DisplayPort-0 -d code dev music priv

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3

# padding to 0 on left monitor
bspc config top_padding 18

bspc config -m $work_monitor_left top_padding 20
bspc config -m $work_monitor_right top_padding 20
bspc monitor -s DisplayPort-2
