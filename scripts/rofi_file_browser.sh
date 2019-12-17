#!/bin/bash

root_dir=$1

file=$(exa -s modified -r $root_dir | rofi -dmenu -p "Select file $root_dir")
xdg-open $root_dir/$file
