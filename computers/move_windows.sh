#!/bin/bash

for node in $(bspc query -N); do
    name=$(bspc query -T -n $node | jq .client.className)
    name="${name#\"}"
    name="${name%\"}"
    #echo $name

    if [[ "$name" == "Spotify" ]]; then
        id=$(bspc query -T -n $node | jq .id)
        echo "Moving spotify to music"
        bspc node $id -d music
    fi
    if [[ "$name" == "Slack" ]]; then
        id=$(bspc query -T -n $node | jq .id)
        echo "Moving Slack to slack"
        bspc node $id -d slack
    fi
    if [[ "$name" == "Rocket.Chat" ]]; then
        id=$(bspc query -T -n $node | jq .id)
        bspc node $id -d rocket
    fi
    if [[ "$name" == "Google-chrome" ]]; then
        id=$(bspc query -T -n $node | jq .id)
        bspc node $id -d priv
    fi
done

