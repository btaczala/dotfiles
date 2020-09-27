#!/bin/bash

if pgrep ".*Spotify$" > /dev/null
then
    /usr/local/bin/spotify status | grep paused > /dev/null

    if [ ! $? -eq 0 ]; then
      /usr/local/bin/spotify pause > /dev/null
      echo "was_playing"
    fi
fi
