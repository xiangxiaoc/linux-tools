#!/bin/bash

function cumulate_pids() {
    ## Recursive function for cumulate pid
    local process_id=$1
    local subprocess_pids=$(ps -ef | awk '{if($3=="'$process_id'"){print $2}}')
    pids="$pids $subprocess_pids"
    for i in $subprocess_pids; do
        cumulate_pids $i
    done
}

function get_all_subprocess_pids() {
    local process_id=$1
    cumulate_pids $process_id
    echo "$pids"
}

get_all_subprocess_pids $1
