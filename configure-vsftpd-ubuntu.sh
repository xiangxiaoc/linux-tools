#!/bin/bash

##################################################
# File Name: configure-vsftpd-ubuntnu.sh
# Author: xiangxiaoc
# Email: xiangxiaoc@vip.qq.com
# Created Time: Sun 30 Sep 2018 03:28:52 PM CST
##################################################

# 判断是否为root
if [ $UID -ne 0 ] ; then
        echo "权限拒绝，sudo试试"
        exit 0
fi

ftp_virtual_account_list_file='/etc/vsftpd/virtual_account.txt'
ftp_virtual_account_list_db_file='/etc/vsftpd/vsftpd_login.db'

# install

function install_vsftpd() {
    apt install vsftpd -y
}

function install_db_util() {
    apt install db_util -y
}

# configure

function configure_virtual_account() {
    get_ftp_virtual_account
    add_account_to_file
    show_file
}

function get_ftp_virtual_account() {
    read -p 'Input username: ' virtual_user_name
    read -p 'Input password: ' virtual_user_password
}

function add_account_to_file() {
    if [ ! -d /etc/vsftpd ] ; then
        mkdir /etc/vsftpd
    fi
    echo $virtual_user_name >> $ftp_virtual_account_list_file
    echo $virtual_user_password >> $ftp_virtual_account_list_file
}

function show_file() {
    more $ftp_virtual_account_list_file
}

function remove_file() {
    rm $ftp_virtual_account_list_file
}

function db_load_hash() {
    db_load -T -t hash -f $ftp_virtual_account_list_file $ftp_virtual_account_list_db_file
    chmod 600 $ftp_virtual_account_list_db_file
}

function configure_pam_auth() {
    pam_vsftpd_file='/etc/pam.d/vsftpd.virtual_account'
    echo "auth sufficient pam_userdb.so db=${ftp_virtual_account_list_db_file%.*}" >> $pam_vsftpd_file
    echo "account sufficient pam_userdb.so db=${ftp_virtual_account_list_db_file%.*}" >> $pam_vsftpd_file
}

function add_local_user_vsftpd() {
    vsftpd_home_dir='/home/vsftpd'
    useradd vsftpd -d $vsftpd_home_dir -m -s /bin/false
}

function configure_vsftpd_conf() {
    cat << EOF_vsftpd
listen=YES
anonymous_enable=YES
dirmessage_enable=YES
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=YES
chroot_local_user=YES
guest_enable=YES
guest_username=vsftpd
user_config_dir=/etc/vsftpd/vsftpd_virtual_user.conf
pam_service_name=$pam_vsftpd_file
local_enable=YES
secure_chroot_dir=/var/run/vsftpd
EOF_vsftpd
}



function show_help() {
    cat << EOF_help

Usage: sudo bash $0 Command [arg]

Commands:
  install [-a]    安装管理菜单 [-a 一键安装全部]
  remove [-a]     卸载管理菜单 [-a 一键移除所有安装]
  config          配置管理菜单
  check           检查各软件是否已安装

EOF_help
    exit 0
}

function main() {
    Command=$1
    shift
    case $Command in
        'install') install_vsftpd   ;;
        'configure') configure_virtual_account  ;   exit 0  ;;
        *)  show_help   ;;
    esac
}

main $@