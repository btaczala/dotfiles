#!/bin/bash

bspc config focus_follows_pointer false
wmname LG3D

/home/bata/external/projects/android/android-studio/bin/studio.sh & 
sleep 10
bspc config focus_follows_pointer true
