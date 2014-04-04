#!/bin/bash

kill `ps ax | grep qtcre | grep Shoo | awk {'print $1'}`
killall skype
killall pidgin
killall firefox
nmcli con down id mob-wawa
nmcli con down id Nokia
