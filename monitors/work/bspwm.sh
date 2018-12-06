#!/bin/bash

source $HOME/dotfiles/monitors/`hostname`.config

bspc monitor $work_monitor_right -d mail code dev apps docs
bspc monitor $work_monitor_left -d web im system music priv

# custom rules bitches
bspc rule -a Pidgin desktop=^7

# padding to 0 on left monitor
bspc config top_padding 18

bspc config -m $work_monitor_left top_padding 20
bspc config -m $work_monitor_right top_padding 20
bspc monitor -s DisplayPort-2
