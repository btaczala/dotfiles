#!/bin/bash

wid=$1
class=$2
instance=$3

echo $instance >> /tmp/zlo

function get_wm_name {
    xprop -id $wid | grep _NET_WM_ICON_NAME | awk '{ print $3}' | tr -d '"'
}

name=$(get_wm_name)

# for gcalcli calendar window
if [ "$name" = "calendar_floating" ] || [ "$instance" = "calendar_floating" ]; then
    echo "floating=on"
fi
