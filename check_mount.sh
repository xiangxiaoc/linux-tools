#!/bin/bash

## Check whether Mount points is mounted from /etc/fstab

CR='\e[0;31m'
CG='\e[0;32m'
RC='\e[0m'

function check_permission() {
    if [ $UID -ne 0 ]; then
        echo "Only for root"
        exit
    fi
}

function check_mount() {
    mount_point_list=$(grep -v "^#" /etc/fstab | awk '{print $2}')
    for mount_point in $mount_point_list; do
        if df "$mount_point" &>/dev/null; then
            echo -e "${CG}mounted${RC}      $mount_point"
        else
            echo -e "${CR}unmounted${RC}    $mount_point"
        fi
    done
}

function main_process() {
    check_permission
    echo -e "Status       Mount Point"
    check_mount
}

main_process
