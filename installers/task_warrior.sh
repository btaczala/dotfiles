#!/bin/bash

ovh_server=vps513306.ovh.net

function force_setup_task_warrior() {
    task_dir=$1
    echo "Creating $task_dir"
    mkdir -p $task_dir
    scp bartek@vps513306.ovh.net:~/bartek_taczała.cert.pem $task_dir/
    scp bartek@vps513306.ovh.net:~/bartek_taczała.key.pem $task_dir/
    scp bartek@vps513306.ovh.net:~/ca.cert.pem $task_dir/

    yes | task config taskd.certificate   -- $task_dir/bartek_taczała.cert.pem
    yes | task config taskd.key           -- $task_dir/bartek_taczała.key.pem
    yes | task config taskd.ca            -- $task_dir/ca.cert.pem

    yes | task config taskd.server        -- $ovh_server:53589
    yes | task config taskd.credentials   -- private/Bartek Taczała/46ba2358-dc51-48fc-8fc5-22bfc6efcb0a

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
