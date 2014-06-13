#!/bin/bash

while [ true ]
do
    echo "Remind me"
    /usr/bin/gcalcli remind 15 'notify-send -i /usr/share/icons/oxygen/48x48/actions/view-calendar-whatsnext.png -u critical -a gcalcli %s'
    sleep 600
done
