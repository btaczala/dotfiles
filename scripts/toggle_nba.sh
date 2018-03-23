#!/bin/bash

window_id=$(xwininfo -name "NBA - Google Chrome" | grep xwininfo | awk '{print $4}')

mapw -t $window_id
