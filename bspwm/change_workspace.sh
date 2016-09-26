#!/bin/bash

source ~/dotfiles/bspwm/dmenu_env.sh

workspaces=()
#for desk in `bspc query -D`; do
    #workspaces+=`echo $desk\\n`
#done
for monitor in `bspc query -M`; do
    asd=`bspc query -D -m $monitor`
    for a in $asd; do 
        tmp=`bspc query -T -d $a | jq '.name'`
        workspaces+='_'
        workspaces+="$a "
        #workspaces+=" $tmp"
    done
done
workspace=("${workspace[@]:1}")
#workspace=`echo ${workspaces[*]} | tr "_" "\n" | dmenu -x $x -y $y -w $curr_width -l 10 -nb "#282828" -nf "#ccb18b" -fn Terminess-8:normal`
workspace=`echo ${workspaces[*]} | tr "_" "\n" | rofi -dmenu`
if [[ -n $workspace ]]; then
    real=`echo $workspace | awk '{print $1}'`
    bspc desktop -f $workspace
fi
