#!/bin/bash

. /etc/os-release
os_release_id=$ID$VERSION_ID


# 分析系统基础信息

clear
 
# 提取操作系统信息
 
os=$(uname -o)
distribution_name=$(. /etc/os-release;echo $ID)
distribution_version=$(. /etc/os-release;echo $ID$VERSION_ID)
cpu_architecture=$(uname -p)
kernel_version=$(uname -r)
hostname=$(hostname)

# 提取网络信息
ip=$(hostname -I | awk '{print $1}')
public_ip=$(curl -s http://ipecho.net/plain)
default_gateway_ip=$(netstat -rn | awk '{if($1=="0.0.0.0") print $2}')
nameserver=$(cat /etc/resolv.conf | grep -E "\<nameserver[ ]+" | awk '{print $NF}')

# 提取内存信息
total_used_memory=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo)M
application_used_memory=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo)M
free_memory=$(awk '/MemFree/{print $2/1024}' /proc/meminfo)M

echo -e "\e[1;32m### basic info ### \e[0m"
cat << EOF
Hostname: $hostname
OS Type: $os
Distribution Version: $distribution_version
Kernel Version: $kernel_version
CPU Architecture: $cpu_architecture

EOF

echo -e "\e[1;32m### network info ### \e[0m"
cat << EOF
LAN IP: $ip
Gateway IP: $default_gateway_ip
Public IP: $public_ip
Nameserver:
$nameserver

EOF

echo -e "\e[1;32m### memory info ### \e[0m"
cat << EOF
Total Used: $total_used_memory
Application Used: $application_used_memory
Free: $free_memory
EOF

# 打印磁盘信息
echo
echo -e "\e[1;32m### disk info ### \e[0m"
df -hP | grep -v 'tmpfs' | awk '{if($4!=0)print}'

# 基本运行现状
echo
echo -e "\e[1;32m### running info ### \e[0m"
w

# 当前用户有什么crontab定时任务
echo
echo -e "\e[1;32m### crontab tasks ### \e[0m"
crontab -l | grep -vE '^#|^$'

echo