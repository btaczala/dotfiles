#!/bin/bash
today=`date +"%m/%d/%y"`
tomorrow=`date --date=tomorrow +"%m/%d/%y"`

gcalcli agenda --nostarted $today $tomorrow
