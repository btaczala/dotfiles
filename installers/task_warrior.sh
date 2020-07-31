#!/bin/bash

ovh_server=vps762509.ovh.net
task_user="bartek"

function force_setup_task_warrior() {
    task_dir=$1
    echo "Creating $task_dir"
    mkdir -p $task_dir
    scp bartek@$ovh_server:~/$task_user.cert.pem $task_dir/
    scp bartek@$ovh_server:~/$task_user.key.pem $task_dir/
    scp bartek@$ovh_server:~/ca.cert.pem $task_dir/

    yes | task config taskd.certificate   -- $task_dir/$task_user.cert.pem
    yes | task config taskd.key           -- $task_dir/$task_user.key.pem
    yes | task config taskd.ca            -- $task_dir/ca.cert.pem

    yes | task config taskd.server        -- $ovh_server:53589
    yes | task config taskd.credentials   -- private/bartek/79d7ada1-23c6-4e1e-8409-22a714d17daf

    yes | task sync init
    yes | task sync
}

function setup_task_warrior() {
    task_dir=$HOME/.task
    taskrc=$HOME/.taskrc
    if [ -d $task_dir ]; then
        read -p "$task_dir exists, do you want to remove it (y/n)" CONT
        if [ "$CONT" = "y" ]; then
            rm $task_dir -rfv
            rm $taskrc
            force_setup_task_warrior $task_dir
        else
          echo "$task_dir not deleted, continue";
        fi
    else
        force_setup_task_warrior $task_dir
    fi
}

echo "Setting up task warrior"
setup_task_warrior
