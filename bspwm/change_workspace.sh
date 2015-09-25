#!/bin/bash

workspaces=()
for monitor in `bspc query -M`; do
    asd=`bspc query -D -m $monitor`
    workspaces+=' '
    workspaces+=$asd
done

workspace=`echo ${workspaces[*]} | tr " " "\n" | rofi -dmenu -p "Change workspace to"`
echo "Workspace= $workspace"
if [[ -n $workspace ]]; then
    bspc desktop -f $workspace
fi
