#!/bin/bash

root_dir=$1

file=$(fd . $root_dir | rofi -dmenu -p "Select file $root_dir")
xdg-open $file
