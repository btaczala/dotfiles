#!/bin/bash

function run_scratchpad {
    echo "Running scratchpad"
    termite -e 'tmux attach-session -tscratchpad' -t scratchpad --hold
}

# check if scratpad is running
# if it's running focus it

json_output=$(swaymsg -t get_tree | jq '.nodes[].nodes[].floating_nodes[]')
if [ -z "$json_output" ]; then
    run_scratchpad
else
    window_id=$(echo $json_output | jq '.id')

    if [ $? -ne 0 ]; then
        echo "ERROR: while searching for window_id"
    else
        echo "ID = $window_id"
        swaymsg focus floating
    fi
fi

