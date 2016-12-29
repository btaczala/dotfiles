#!/bin/bash

today=`date +"%m/%d/%y"`
tomorrow=`date --date=tomorrow +"%m/%d/%y"`
gcalcli agenda --nostarted --nocolor $today $tomorrow | cut -d " " -f 4- | head -2 | tail -1 | sed "s/^ *//g" | sed "s/    / /g" | cut -c1-19
