#!/bin/bash

bspc monitor -d mail web im dev code system git priv 

# custom rules bitches
bspc rule -r Pidgin
bspc rule -r Skype
bspc rule -a Skype desktop=^3
bspc rule -a Pidgin desktop=^3
bspc rule -a QtCreator desktop=^8

# padding to 0 on left monitor
bspc config top_padding 18
