#!/bin/bash

icon="$HOME/dotfiles/lock.png"
tmpbg='/tmp/screenshot.png'

~/dotfiles/skype_away.py away
i3lock -n -f -r 40 
~/dotfiles/skype_away.py online
