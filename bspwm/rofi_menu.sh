#!/bin/bash

workspaces=()
workspace=

function move_window() {
    bspc window -d $1
}

function close_window() {
    bspc window -c
}

function list_workspaces {
    for monitor in `bspc query -M`; do
        asd=`bspc query -D -m $monitor`
        workspaces+=' '
        workspaces+=$asd
    done
    workspace=`echo ${workspaces[*]} | tr " " "\n" | dmenu `
}

command=`echo "move
close" | dmenu`

case "$command" in
    'move')
        echo "move command"
        list_workspaces
        move_window $workspace
        ;;
    'close')
        echo "close command"
        close_window
        ;;
esac
