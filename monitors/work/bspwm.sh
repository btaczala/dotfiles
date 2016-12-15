#!/bin/bash

bspc monitor DP2-2 -d mail web im system dev docs
bspc monitor DP2-1 -d code dev ssh priv

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3
bspc rule -a QtCreator desktop=^8

# padding to 0 on left monitor
bspc config top_padding 18

bspc config -m DP2-2 top_padding 20
bspc config -m DP2-1 top_padding 20
bspc monitor -s DP2-2
