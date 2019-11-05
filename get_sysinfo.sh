#!/bin/bash

[ -f /etc/os-release ] && . /etc/os-release
 
printGreen='\e[1;32m'
printGreen1='\e[1;32m'
resetColor='\e[0m'

function getOSInfo() {
    os=$( uname -o )
    distribution_name=${ID}
    distribution_version=${ID}${VERSION_ID}
    distribution_subversion=${PRETTY_NAME}
    cpu_architecture=$( uname -p )
    kernel_version=$( uname -r )
    hostname=$( hostname )
}

function getNetworkInfo() {
    ip=$( hostname -I | awk '{print $1}' )
    public_ip=$(curl -s http://ipecho.net/plain)
    default_gateway_ip=$( netstat -rn | awk '{if( $1 == "0.0.0.0" ) print $2}' )
    nameserver=$(cat /etc/resolv.conf | grep -E "\<nameserver[ ]+" | awk '{print $NF}')
}


function getMemoryInfo() {
    total_used_memory=$( awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo )M
    application_used_memory=$( awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo )M
    free_memory=$( awk '/MemFree/{print $2/1024}' /proc/meminfo )M
}

function getRunningStatus() {
    now_time=$( date +'%Y-%m-%d %H:%M:%S' )
    utc_time=$( date -u +'%Y-%m-%d %H:%M:%S' )
    up_time=$( cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%dd %dh %dm %ds",run_days,run_hour,run_minute,run_second)}' )
}

getOSInfo
echo -e "${printGreen1}### basic info ###${resetColor}"
cat << EOF
Hostname:                   ${hostname}
OS Type:                    ${os}
Distribution Version:       ${distribution_version}
Distribution subversion:    ${distribution_subversion}
Kernel Version:             $kernel_version
CPU Architecture:           $cpu_architecture

EOF

getNetworkInfo
echo -e "\e[1;32m### network info ### \e[0m"
cat << EOF
LAN IP:     $ip
Gateway IP: $default_gateway_ip
Public IP:  $public_ip
Nameserver: $(echo $nameserver)

EOF

getMemoryInfo
echo -e "\e[1;32m### memory info ### \e[0m"
cat << EOF
Total Used:         $total_used_memory
Application Used:   $application_used_memory
Free:               $free_memory
EOF

# 打印磁盘信息
echo -e "\n\e[1;32m### disk info ### \e[0m"
df -Th | awk '{ if($2 != "tmpfs" && $2 != "devtmpfs") print }'

# 基本运行现状
getRunningStatus
echo -e "\n\e[1;32m### running info ### \e[0m"
cat << EOF
Local Time: ${now_time}
UTC Time:   ${utc_time}
UP Time:    ${up_time}
EOF

# 当前用户有什么crontab定时任务
echo -e "\n\e[1;32m### crontab tasks ### \e[0m"
crontab -l | grep -vE '^#|^$'