#!/bin/sh

padd=`bspc query -T -m | jq ".topPadding"`
if [ "$padd" == "20" ]; 
then
    bspc config top_padding 0
else
    bspc config top_padding 20
fi

