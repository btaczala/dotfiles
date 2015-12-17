#!/bin/bash

width=`bspc query -T -m focused | jq '.rectangle.width'`
height=`bspc query -T -m focused | jq '.rectangle.height'`
#curr_width=echo "$(( 0.7 * $curr_width ))"
i=0.7
t=$(expr $width*$i | bc)
curr_width=$( printf "%.0f" $t )

x=`echo "($width-$curr_width)/2" | bc`
y=`echo "$height/2 - 50" | bc`

PATH=$PATH:$HOME/bin dmenu_run -x $x -y $y -w $curr_width -l 10 -nb "#282828" -nf "#ccb18b" -fn Terminess-8:normal
#echo $curr_width " " $x
