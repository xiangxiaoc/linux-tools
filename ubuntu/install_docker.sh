#!/usr/bin/env bash

# https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/

DOCKER_VERSION='19.03.4'
CONTAINERD_VERSION='1.2.2-3'
BASE_URL='https://download.docker.com/linux/ubuntu/dists'

function get_deb_name_and_url() {
    distribution_codename=$(lsb_release -c | awk '{print $2}')
    docker_deb_name="docker-ce_${DOCKER_VERSION}~3-0~ubuntu-bionic_amd64.deb"
    docker_cli_deb_name="docker-ce-cli_${DOCKER_VERSION}~3-0~ubuntu-bionic_amd64.deb"
    containerd_deb_name="containerd.io_${CONTAINERD_VERSION}_amd64.deb"
    docker_deb_url="$BASE_URL/$distribution_codename/pool/stable/amd64/$docker_deb_name"
    docker_cli_deb_url="$BASE_URL/$distribution_codename/pool/stable/amd64/$docker_cli_deb_name"
    containerd_deb_url="$BASE_URL/$distribution_codename/pool/stable/amd64/$containerd_deb_name"
}

function download_packages() {
    download_list=$*
    for current_package in $download_list; do
        echo "download $current_package..."
        wget "$current_package"
    done
}

function main_process() {
    get_deb_name_and_url
    deb_url_list=("$docker_deb_url" "$docker_cli_deb_url" "$containerd_deb_url")
    download_packages "${deb_url_list[@]}"
    deb_name_list=(./"$docker_deb_name" ./"$docker_cli_deb_name" ./"$containerd_deb_name")
    apt install -y --no-install-recommends "${deb_name_list[@]}"
    rm -f "${deb_name_list[@]}"
}

main_process
