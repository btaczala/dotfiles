#!/bin/bash
~/dotfiles/skype_away.py away
purple-remote "setstatus?status=away&message=AFK"
i3lock -f
~/dotfiles/skype_away.py online
purple-remote "setstatus?status=available&message="
