#!/bin/bash

[ -f /etc/os-release ] && . /etc/os-release

print_green='\e[1;32m'
reset_color='\e[0m'

function format_print_header() {
    local text=$1
    echo -e "$print_green### $text ###$reset_color"
}

function getOSInfo() {
    os=$(uname -o)
    distribution_id=${ID}
    distribution_version=${VERSION_ID}
    distribution_pretty_name=${PRETTY_NAME}
    cpu_architecture=$(uname -p)
    kernel_version=$(uname -r)
    hostname=$(hostname -s)
    domain_name=$(hostname -d)
}

function getNetworkInfo() {
    ip=$(hostname -I | awk '{print $1}')
    public_ip=$(curl -s --max-time 5 http://ipecho.net/plain)
    # centos of mininal installation need install net-tools
    default_gateway_ip=$(netstat -rn | awk '{if( $1 == "0.0.0.0" ) print $2}')
    nameserver=$(grep -E "\<nameserver[ ]+" /etc/resolv.conf | awk '{print $NF}')
}

function getCPUInfo() {
    vCPU_num=$(lscpu | awk '{ if ($1 == "CPU(s):") print $2}')
    load_average_1m=$(uptime | awk '{print $(NF-2)}' | cut -d ',' -f 1)
    load_average_5m=$(uptime | awk '{print $(NF-1)}' | cut -d ',' -f 1)
    load_average_15m=$(uptime | awk '{print $NF}')
}

function getMemoryInfo() {
    total_used_memory=$(awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} END {printf ("%.2f",(total-free)/1024/1024)}' /proc/meminfo)G
    total_used_memory_percent=$(awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} END {printf ("%.2f",(total-free)/total*100)}' /proc/meminfo)%
    true_used_memory=$(awk '/MemTotal/ {total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{printf ("%.2f",(total-free-cached-buffers)/1024/1024)}' /proc/meminfo)G
    true_used_memory_percent=$(awk '/MemTotal/ {total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{printf ("%.2f",(total-free-cached-buffers)/total*100)}' /proc/meminfo)%
    free_memory=$(awk '/MemFree/ {printf ("%.2f",$2/1024/1024)}' /proc/meminfo)G
    free_memory_percent=$(awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} END {printf ("%.2f",free/total*100)}' /proc/meminfo)%
    mem_total=$(awk '/MemTotal/ {printf ("%.2f",$2/1024/1024)}' /proc/meminfo)G
}

function getRunningStatus() {
    now_time=$(date +'%Y-%m-%d %H:%M:%S (%Z)')
    utc_time=$(date -u +'%Y-%m-%d %H:%M:%S')
    up_time=$(date -d "$(awk -F '.' '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S (%Z)")
    running_age=$(awk -F '.' '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%dd %dh %dm %ds",run_days,run_hour,run_minute,run_second)}' /proc/uptime)
}

function main_process() {
    getOSInfo
    format_print_header "basic info"
    cat <<EOF
Hostname:                   ${hostname}
Domain:                     ${domain_name}
OS:                         ${os}
Distribution ID:            ${distribution_id}
Distribution Version:       ${distribution_version}
Distribution Pretty Name:   ${distribution_pretty_name}
Kernel Version:             $kernel_version
CPU Architecture:           $cpu_architecture

EOF

    getNetworkInfo
    format_print_header "network info"
    cat <<EOF
LAN IP:     $ip
Gateway IP: $default_gateway_ip
Public IP:  $public_ip
Nameserver: $(echo $nameserver)

EOF

    # print disk info
    format_print_header "Disk Info"
    df -Th | awk '{ if($2 != "tmpfs" && $2 != "devtmpfs") print }'
    echo

    # print cornjob of current user
    format_print_header "Cornjob"
    crontab -l | grep -vE '^#|^$'
    echo

    # print basic running info
    getRunningStatus
    format_print_header "Running Info"
    cat <<EOF
UTC Time:   ${utc_time}
Local Time: ${now_time}
UP Time:    ${up_time} (${running_age} ago)

EOF

    getCPUInfo
    format_print_header "CPU Info"
    cat <<EOF
vCPU num: ${vCPU_num}
Load Average 15 min: ${load_average_15m}
Load Average 5 min:  ${load_average_5m}
Load Average 1 min:  ${load_average_1m}

EOF

    getMemoryInfo
    format_print_header "Memory Info"
    cat <<EOF
Total Used:         $total_used_memory (${total_used_memory_percent})
True Used:          $true_used_memory (${true_used_memory_percent})
Free:               $free_memory (${free_memory_percent})
Total Mem:          $mem_total

EOF
}

main_process "$@"
