#!/bin/sh

DMENU="-i -l 20 -nb #1f1f1f -nf #c0b18b"
ls ~/dotfiles/scripts | `dmenu $DMENU -fn "Inconsolata for Powerline-8"> /tmp/dmenu_xrandr_output.txt` && 
    cat /tmp/dmenu_xrandr_output.txt | xargs sh
