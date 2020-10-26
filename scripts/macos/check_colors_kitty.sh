#!/bin/bash
function darkMode {
    2>/dev/null defaults read -g AppleInterfaceStyle
}

while true
do
    mode=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
    echo "Mode is $mode"
    if [[ ! $mode =~ 'Dark' ]]; then
      kitty @ --to unix:/tmp/kitty set-colors --all --configured ~/.config/kitty/kitty-themes/themes/AtomOneLight.conf
    else
      kitty @ --to unix:/tmp/kitty set-colors --reset
    fi
    sleep 5
done
