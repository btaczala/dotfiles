#!/bin/bash

if ! pgrep -x "kdeconnectd" > /dev/null 
then
    exit 1
fi

id=$(dbus-send --session --dest=org.kde.kdeconnect --print-reply /modules/kdeconnect org.kde.kdeconnect.daemon.deviceIdByName string:"google" | tail -n 1 | awk '{print $2}' | sed -e 's/^"//' -e 's/"$//')

echo $id
if [[ $id == "" ]]; then
    exit 1
fi

is_reachable=$(dbus-send --session --dest=org.kde.kdeconnect --print-reply /modules/kdeconnect/devices/$id org.freedesktop.DBus.Properties.Get string:org.kde.kdeconnect.device string:isReachable | tail -1 | awk '{print $3}')

echo $is_reachable
if [[ "$is_reachable" == "true" ]]; then
    exit 0
fi

exit 1

