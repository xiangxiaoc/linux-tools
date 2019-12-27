#!/bin/bash

function add_pid() {
    local process_id=$1
    local subprocess_pids=$(ps -ef | awk '{if($3=="'$process_id'"){print $2}}')
    pids="$pids $subprocess_pids"
    for i in $subprocess_pids; do
        add_pid $i
    done
}

function print_pids() {
    add_pid $1
    echo $pids
}

print_pids $1
