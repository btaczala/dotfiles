#!/bin/bash

icon="$HOME/dotfiles/lock.png"
tmpbg='/tmp/screenshot.png'

why=`echo -e "\nping pong\nmeeting" | rofi -dmenu -p lock`
echo $why > /tmp/why
~/dotfiles/skype_away.py away "$why"
#if [[ "$why" == "ping pong" ]]; then
    #i3lock -n -i ~/Downloads/pingpong.jpeg.size.xxlarge.letterbox.png -t
#else
    #i3lock -n -f -r 40 
#fi
i3lock -i ~/dotfiles/walls/orion.png
~/dotfiles/skype_away.py online
