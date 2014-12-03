#!/bin/bash
~/dotfiles/skype_away.py away
purple-remote "setstatus?status=away&message=AFK"
scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 /tmp/screenshotblur.png
i3lock -n -i /tmp/screenshotblur.png
~/dotfiles/skype_away.py online
purple-remote "setstatus?status=available&message="
