#!/bin/bash

wid=$1
class=$2
instance=$3

function get_wm_name {
    xprop -id $wid | grep _NET_WM_ICON_NAME | awk '{ print $3}' | tr -d '"'
}

name=$(get_wm_name)
echo "Name=$name [][] $class $instance" >> /tmp/zlo

# for gcalcli calendar window
if [ "$name" == "calendar_floating" ] || [ "$instance" == "calendar_floating" ] || [ "$name" == "URxvtQuake" ]; then
    echo "state=floating"
fi

if [ "$name" == "task_list_floating" ] || [ "$instance" == "task_list_floating" ]; then
    echo "state=floating"
fi

if [ "$name" == "wxtest" ]; then
    echo "state=floating"
fi

if [ "$class" == "mutt" ]; then
    echo "desktop=^1"
fi

if [ "$class" == "" ]; then
    echo "desktop=^1"
fi

xwininfo -id $wid | grep "NBA - Google Chrome" && echo "state=floating"
