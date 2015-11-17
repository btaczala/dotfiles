#!/bin/bash

wid=$1
class=$2
instance=$3

echo $instance >> /tmp/zlo

function get_wm_name {
    xprop -id $wid | grep _NET_WM_ICON_NAME | awk '{ print $3}' | tr -d '"'
}

name=$(get_wm_name)
echo "Name=$name asd" >> /tmp/zlo

# for gcalcli calendar window
if [ "$name" == "calendar_floating" ] || [ "$instance" == "calendar_floating" ]; then
    echo "state=floating"
fi

if [ "$name" = "mutt" ]; then
    echo "desktop=^1"
fi
