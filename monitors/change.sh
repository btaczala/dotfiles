#!/bin/bash +xe

current_setup="/tmp/current-monitor"
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -eq 1 ]]; then
    config=$1
    if [[ "`find $this_dir -mindepth 1 -type d | grep $config | grep -v grep`" == "" ]]; then
        echo "No such config $config"
        exit 1
    fi
else
    selected=`find $this_dir -mindepth 1 -type d -exec basename '{}' ';' | rofi -dmenu `
    if [[ "$selected" == "" ]]; then
        exit 1
    fi
    config=`basename $selected`
fi

bspwm_script="bspwm.sh"
bar="polybar.sh"
echo "Changing to config"
config=$this_dir/$config/

# call reset
$this_dir/reset.sh

configs=($config/$bspwm_script $config/$bar $config/"after.sh")
for cfg in "${configs[@]}"
do
    if [[ -e $cfg ]]; then
        echo "Executing $cfg"
        $cfg
    fi
done

if [[ -d $current_setup ]]; then
    unlink $current_setup
fi

echo "Linking ln -s $config $current_setup"
ln -s $config $current_setup
