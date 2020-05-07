#!/bin/bash
pid=$(pgrep openconnect)
if [ $? -eq 0  ]; then
    echo "tun0 "
fi
