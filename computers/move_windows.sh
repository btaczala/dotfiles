#!/bin/bash

for node in $(bspc query -N); do
    name=$(bspc query -T -n $node | jq .client.className)
    instance=$(bspc query -T -n $node | jq .client.instanceName)
    name="${name#\"}"
    name="${name%\"}"
    instance="${instance#\"}"
    instance="${instance%\"}"
    echo $name $instance

    wid=$(bspc query -T -n $node | jq .id)

    if [[ "$name" == "Firefox" ]]; then
        id=$(bspc query -T -n $node | jq .id)
        echo "Moving Firefox to web"
        bspc node $id -d web
    fi
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
    if [[ "$instance" == "google-chrome" ]]; then
        id=$(bspc query -T -n $node | jq .id)
        echo "Moving google to priv"
        bspc node $wid -d priv
    fi

    if [[ $(xprop -id $wid 2>/dev/null | grep spotify) ]]; then
        echo "spotify"
        bspc node $wid -d music
    fi
done

