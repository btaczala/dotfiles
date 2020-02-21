#!/bin/bash

root_dir="$1"

file=$(exa -s modified -r "$root_dir" | rofi -dmenu -p "Select file $root_dir")

if [ $? -eq 0 ]; then
    echo $root_dir/$file
    if [ -d "$root_dir/$file" ]; then
        $HOME/dotfiles/scripts/rofi_file_browser.sh "$root_dir/$file"
    else
        echo "Not a dir"
        xdg-open $root_dir/$file
    fi
fi
