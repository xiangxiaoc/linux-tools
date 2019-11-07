#!/bin/bash

[ -f /etc/os-release ] && . /etc/os-release
 
printGreen='\e[1;32m'
printGreen1='\e[1;32m'
resetColor='\e[0m'

function getOSInfo() {
    os=$( uname -o )
    distribution_id=${ID}
    distribution_version=${VERSION_ID}
    distribution_pretty_name=${PRETTY_NAME}
    cpu_architecture=$( uname -p )
    kernel_version=$( uname -r )
    hostname=$( hostname )
    domain_name=$( hostname -d )
}

function getNetworkInfo() {
    ip=$( hostname -I | awk '{print $1}' )
    public_ip=$(curl -s http://ipecho.net/plain)
    default_gateway_ip=$( netstat -rn | awk '{if( $1 == "0.0.0.0" ) print $2}' )
    nameserver=$(cat /etc/resolv.conf | grep -E "\<nameserver[ ]+" | awk '{print $NF}')
}


function getMemoryInfo() {
    total_used_memory=$( awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} END {printf ("%.2f",(total-free)/1024/1024)}' /proc/meminfo )G
    total_used_memory_percent=$( awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} END {printf ("%.2f",(total-free)/total*100)}' /proc/meminfo )%
    application_used_memory=$( awk '/MemTotal/ {total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{printf ("%.2f",(total-free-cached-buffers)/1024/1024)}' /proc/meminfo )G
    application_used_memory_percent=$( awk '/MemTotal/ {total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{printf ("%.2f",(total-free-cached-buffers)/total*100)}' /proc/meminfo )%
    free_memory=$( awk '/MemFree/ {printf ("%.2f",$2/1024/1024)}' /proc/meminfo )G
    free_memory_percent=$( awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} END {printf ("%.2f",free/total*100)}' /proc/meminfo )%
    mem_total=$( awk '/MemTotal/ {printf ("%.2f",$2/1024/1024)}' /proc/meminfo )G
}

function getRunningStatus() {
    now_time=$( date +'%Y-%m-%d %H:%M:%S (%Z)' )
    utc_time=$( date -u +'%Y-%m-%d %H:%M:%S' )
    up_time=$( date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S (%Z)" )
    running_age=$( cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%dd %dh %dm %ds",run_days,run_hour,run_minute,run_second)}' )
}

getOSInfo
echo -e "${printGreen1}### basic info ###${resetColor}"
cat << EOF
Hostname:                   ${hostname}
Domain:                     ${domain_name}
OS Type:                    ${os}
Distribution ID:            ${distribution_id}
Distribution Version:       ${distribution_version}
Distribution Pretty Name:   ${distribution_pretty_name}
Kernel Version:             $kernel_version
CPU Architecture:           $cpu_architecture

EOF

getNetworkInfo
echo -e "${printGreen1}### network info ###${resetColor}"
cat << EOF
LAN IP:     $ip
Gateway IP: $default_gateway_ip
Public IP:  $public_ip
Nameserver: $(echo $nameserver)

EOF

getMemoryInfo
echo -e "${printGreen1}### memory info ###${resetColor}"
cat << EOF
Total Used:         $total_used_memory (${total_used_memory_percent})
Application Used:   $application_used_memory (${application_used_memory_percent})
Free:               $free_memory (${free_memory_percent})
Total Mem:          $mem_total
EOF

# 打印磁盘信息
echo -e "\n${printGreen1}### disk info ###${resetColor}"
df -Th | awk '{ if($2 != "tmpfs" && $2 != "devtmpfs") print }'

# 基本运行现状
getRunningStatus
echo -e "\n${printGreen1}### running info ###${resetColor}"
cat << EOF
UTC Time:   ${utc_time}
Local Time: ${now_time}
UP Time:    ${up_time} (${running_age} ago)
EOF

# 当前用户有什么crontab定时任务
echo -e "\n${printGreen1}### crontab tasks ###${resetColor}"
crontab -l | grep -vE '^#|^$'
