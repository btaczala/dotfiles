#!/bin/sh

bspc config right_padding 100
termite --geometry=400x900 --hold --name=task_list_floating --class=task_list_floating -e "task"


