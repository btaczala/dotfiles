#!/bin/sh

echo 'Stop panel, conky, stalonetray'

#killall lemonbuddy
killall polybar
killall panel
killall conky
killall trayer

