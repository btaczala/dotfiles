#!/bin/bash
source ~/dotfiles/bspwm/dmenu_env.sh

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
    workspace=`echo ${workspaces[*]} | tr " " "\n" | dmenu -x $x -y $y -w 150 -l 10 -nb "#282828" -nf "#ccb18b" -fn Terminess-8:normal`
}

command=`echo "move
close" | dmenu -x $x -y $y -w 150 -l 10 -nb "#282828" -nf "#ccb18b" -fn Terminess-8:normal`

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
