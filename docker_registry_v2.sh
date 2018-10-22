#!/bin/bash

# 确保你的系统有安装 libwww-perl 包（这里是 apt 的包名）

##################
# define variable
##################

registry_url='192.168.3.10:5000'
image_name='ecve'
iamge_tag='18.09.1'

##############
# function
##############

function check_api_version() {
    GET $registry_url/v2/
    echo
}

function list_image() {
    image_name=$1
    GET $registry_url/v2/$image_name/tags/list | json_pp
}

function list_images() {
    GET $registry_url/v2/_catalog | json_pp
}

function main() {
    Commmand=$1
    shift
    case $Commmand in
        '')
            ;;
        'check')
            check_api_version  ;;
        'image')
            list_image $@ ;;
        'images')
            list_images ;;
        'del')
            delete_image
    esac
}

main $@