#!/bin/sh

kstart skype & 
kstart pidgin & 
truecrypt /dev/sda4 -p=bs8b@_@kmM & 
kstart firefox https://outlook.com/here.com &
systemctl --user start mopidy
systemctl --user start offlineimap.service
systemctl --user start offlineimap.timer
