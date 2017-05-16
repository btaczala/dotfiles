#!/bin/bash

STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
    mbsync -c ~/dotfiles/work/mutt/mbsync_mobica mobica
    notmuch new
    $HOME/dotfiles/systemd/notmuch-notification.sh
    exit 0
fi
echo "No internet connection."
exit 0
