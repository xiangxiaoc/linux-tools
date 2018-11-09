#!/bin/bash

# 确保你的系统有安装 curl 工具

####################################
# define variable
####################################

registry_url='192.168.3.10:5000'
image_name=''
iamge_tag=''

####################################
# function
####################################

function check_api_version() {
    curl --connect-timeout 3 -sX GET $registry_url/v2/ > /dev/null
    [ $? -eq 0 ] && echo '连接成功' || echo '连接超时或者API版本不匹配'
}

function list_image() {
    image_name=$1
    curl -sX GET $registry_url/v2/$image_name/tags/list | json_pp
}

function list_images() {
    curl -sX GET $registry_url/v2/_catalog | json_pp
}

function get_image_digest_bash() {
    image_digest_bash=$(curl --header "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    -I -sX GET $registry_url/v2/$image_name/manifests/$iamge_tag | grep Docker-Content-Digest | awk {'print $2'})
}

function delete_image() {
    image_name=$1
    iamge_tag=$2
    get_image_digest_bash
    # echo $image_digest_bash
    curl -sX DELETE $registry_url/v2/$image_name/manifests/$image_digest_bash
    # docker exec -it <registry_container_id> bin/registry garbage-collect <path_to_registry_config>
}

function show_help() {
cat << EOF_help
Docker Registry Management Script 
    verison:    0.1.0
    built:      2018-10-22 18:41:00
    OS:         linux

Usage:
    $0 Command

Command:
    check                测试 registry 的API版本是否为v2
    images               列出所有镜像
    image   <IMAGE>      列出镜像所有 tag
    del     <IMAGE TAG>  删除指定 tag 的镜像
EOF_help
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
            delete_image $@ ;;
        *)
            show_help ;;
    esac
}

main $@