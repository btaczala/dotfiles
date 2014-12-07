#!/bin/bash

# quit sup
sup_id=`xdotool search --name sup | head -1`
xdotool windowactivate --sync $sup_id key q y
purple-remote quit
