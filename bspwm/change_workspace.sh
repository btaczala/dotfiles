#!/bin/bash

source ~/dotfiles/bspwm/dmenu_env.sh

workspaces=()
for monitor in `bspc query -M`; do
    asd=`bspc query -D -m $monitor`
    workspaces+=' '
    workspaces+=$asd
done

workspace=`echo ${workspaces[*]} | tr " " "\n" | dmenu -x $x -y $y -w $curr_width -l 10 -nb "#282828" -nf "#ccb18b" -fn Terminess-8:normal`
if [[ -n $workspace ]]; then
    bspc desktop -f $workspace
fi
