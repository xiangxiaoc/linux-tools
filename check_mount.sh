#!/bin/bash

## Check whether Mount points is mounted from /etc/fstab

CR='\e[0;31m'
CG='\e[0;32m'
RC='\e[0m'

if [ ! $UID -eq 0 ];then
    echo "Only for root"
    exit
fi

mount_point_list=$(grep -v "^#" /etc/fstab | awk '{print $2}')
echo -e "Status      Mount Point"
for mount_point in $mount_point_list; do
    if df "$mount_point" &>/dev/null; then
        echo -e "${CG}mounted${RC}      $mount_point"
    else
        echo -e "${CR}unmounted${RC}    $mount_point"
    fi
done
