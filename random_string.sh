#!/bin/bash

###############
# Description #
###############
#
# Generate a random string

function get_character_form_ascii() {
  local type=$1
  local num=$2
  case $type in
  "digit")
    # optimize range to hit
    local num=$((RANDOM % 58))
    if [ $num -ge 48 ] && [ $num -le 57 ]; then
      printf "\x$(printf "%x" $num)"
    fi
    ;;
  "letter")
    if [ $num -ge 65 ] && [ $num -le 90 ]; then
      printf "\x$(printf "%x" $num)"
    elif [ $num -ge 97 ] && [ $num -le 122 ]; then
      printf "\x$(printf "%x" $num)"
    fi
    ;;
  *)
    if [ $num -ge 48 ] && [ $num -le 57 ]; then
      printf "\x$(printf "%x" $num)"
    elif [ $num -ge 65 ] && [ $num -le 90 ]; then
      printf "\x$(printf "%x" $num)"
    elif [ $num -ge 97 ] && [ $num -le 122 ]; then
      printf "\x$(printf "%x" $num)"
    fi
    ;;
  esac
}

function generate_random_string() {
  local type=$1
  local str_len=$2
  for i in $(seq "$str_len"); do
    until [ "${str[$i]}" ]; do
      local num=$((RANDOM % 123))
      str[$i]=$(get_character_form_ascii "$type" $num)
    done
  done
  printf "%s" "${str[@]}"
}

function main_process() {
  local str_len=$1
  [ -z "$str_len" ] && str_len=8
  local arg=$2
  case $arg in
  "") generate_random_string "both" "$str_len" ;;
  *) generate_random_string "$arg" "$str_len" ;;
  esac
}

main_process "$@"
echo
