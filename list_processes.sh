#!/bin/bash
#
# list processes based on ps command on linux server

function get_process_info() {
  local pid=$1
  info_text=$(ps -p "$pid" -o "user,lstart,cmd" --no-headers)
  user=$(echo "$info_text" | awk '{print $1}')
  start_time=$(echo "$info_text" | awk '{
    for(col=2;col<=6;col++) print $col
  }') # example: Mon Apr 13 13:13:13 2020
  command=$(echo "$info_text" | awk '{print $7}')
}

function cal_timestamp() {
  local start_time=$*
  current_timestamp=$(date +%s)
  start_timestamp=$(date --date="$start_time" +%s)
  duration=$((current_timestamp - start_timestamp))
}

function convert_second() {
  local second=$1
  if [[ $second -ge 86400 ]]; then
    days=$((second / 86400))
    hours=$((second % 86400 / 1440))
    echo "${days}d${hours}h"
  elif [[ $second -ge 1440 ]]; then
    hours=$((second / 1440))
    minutes=$((second % 1440 / 60))
    echo "${hours}h${minutes}"
  elif [[ $second -ge 60 ]]; then
    minutes=$((second / 60))
    second=$((second % 60))
    echo "${minutes}m${second}s"
  else
    echo ${second}s
  fi
}

function get_cpu_mem() {
  local pid=$1
  info_text=$(top -p "$pid" -b -n 1 | awk 'NR>7 {print $9,$10}')
  cpu_usage=$(echo "$info_text" | awk '{print $1}')
  mem_usage=$(echo "$info_text" | awk '{print $2}')
}

function print_process_info_table() {
  local pids=$*
  for pid in $pids; do
    get_process_info "$pid"
    cal_timestamp "$start_time"
    age=$(convert_second $duration)
    get_cpu_mem "$pid"
    declare -A data
    data['pid']=$pid
    data['user']=$user
    data['age']=$age
    data['cpu']=$cpu_usage
    data['mem']=$mem_usage
    data['cmd']=$command
    printf "%-8d %-10s %-10s %-5s %-5s %s\n" "${data['pid']}" "${data['user']}" "${data['age']}" "${data['cpu']}" "${data['mem']}" "${data['cmd']}"
  done
}

function get_pids_from_input() {
  read -r -p "Input command: " command
  pids=$(pgrep "$command")
}

function main() {
  get_pids_from_input
  print_process_info_table "$pids"
}

main "$@"
