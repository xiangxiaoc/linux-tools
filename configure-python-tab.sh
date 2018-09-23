#!/bin/bash

##################################################
# File Name: configure-python-tab.sh
# Author: xiangxiaoc
# Email: xiangxiaoc@vip.qq.com
# Created Time: Sun 23 Sep 2018 05:16:55 PM UTC
##################################################

function add_str() {
  cat << EOF
# python startup file  
import readline  
import rlcompleter  
import atexit  
import os  
# tab completion  
readline.parse_and_bind('tab: complete')  
# history file  
histfile = os.path.join(os.environ['HOME'], '.pythonhistory')  
try:  
    readline.read_history_file(histfile)  
except IOError:  
    pass  
atexit.register(readline.write_history_file, histfile)  
del os, histfile, readline, rlcompleter  
EOF
}

add_str >> ~/.pythonstartup

echo "export PYTHONSTARTUP=~/.pythonstartup" >> ~/.bashrc
