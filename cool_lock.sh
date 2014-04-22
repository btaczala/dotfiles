#!/bin/bash
#
# This is an easier-to-tweak version of Steffen Honig's i3lock
# script.  If it doesn't work, it's his fault ;)
#
TEMP_FILE=/tmp/lock.png
TEMP_FILE_POST=/tmp/lock.modified.png
BAR_BG_COLOR="orange"
BAR_FONT_COLOR="white"
BAR_FONT="Source-Code-Pro-Black"
BAR_WIDTH="1920"
BAR_HEIGHT="30"
MOGRIFY_OPTS="-scale 10% -scale 1000% $TEMP_FILE"
MESSAGE="SYSTEM LOCKED: $USER"
CONVERT_OPTS="-background $BAR_BG_COLOR -gravity center -fill $BAR_FONT_COLOR -font $BAR_FONT -size ${BAR_WIDTH}x${BAR_HEIGHT} caption:@- $TEMP_FILE +swap -composite $TEMP_FILE_POST"
 
rm $TEMP_FILE $TEMP_FILE_POST
scrot $TEMP_FILE
mogrify $MOGRIFY_OPTS
#echo $MESSAGE | tr -d "\n" | convert $CONVERT_OPTS
killall -SIGUSR1 dunst
i3lock -i $TEMP_FILE
killall -SIGUSR2 dunst
