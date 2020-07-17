#!/bin/bash

## Check whether Mount points is mounted from /etc/fstab

SCRIPT_VERSION='v1'
SCRIPT_UPDATE_DATE=2020-07-17
SCRIPT_UPDATE_TIME=10:45
SCRIPT_UPDATE_TZ=UTC+8

CR='\e[0;31m'
CG='\e[0;32m'
CY='\e[1;33m'
RC='\e[0m'

function get_script_version() {
    cat <<EOF_show_version
Version: $SCRIPT_VERSION
Update:  $SCRIPT_UPDATE_DATE $SCRIPT_UPDATE_TIME $SCRIPT_UPDATE_TZ
EOF_show_version
}

function check_permission() {
    if [ $UID -ne 0 ]; then
        echo "Only for root"
        exit
    fi
}

function check_mount() {
    local list=$1
    for path in $list; do
        real_path=$(readlink -f "$path")
        if [ -z "$real_path" ]; then
            echo -e "${CR}dir non exist${RC}            $path"
            continue
        fi
        if mount | grep "${real_path%/}" &>/dev/null; then
            if eval ls "$real_path/*" &>/dev/null; then
                echo -e "${CG}mounted${RC}                  $path"
            else
                echo -e "${CY}problematic(no file)${RC}     $path"
            fi
        else
            if eval ls "$real_path"/* &>/dev/null; then
                echo -e "${CG}mounted${RC}                  $path"
            else
                echo -e "${CR}unmounted${RC}                $path"
            fi
        fi
    done
}

function main_process() {
    sub_command=$1
    case $sub_command in
    '')
        check_permission
        echo -e "Status                   Mount Point"
        mount_point_list=$(grep -v "^#" /etc/fstab | awk '{print $2}')
        check_mount "$mount_point_list"
        ;;
    version) get_script_version ;;
    esac
}

main_process "$@"
