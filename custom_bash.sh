#!/bin/bash

#####################
# 颜色 F代码 B代码
# 黑色 30   40
# 红色 31   41
# 绿色 32   42
# 黄色 33   43
# 蓝色 34   44
# 紫红 35   45
# 青蓝 36   46
# 白色 37   47


# 使 ~/.bashrc 加载 ~/.ps1_color
grep ps1_color ~/.bashrc
if [ $? -ne 0 ]; then
    cat >> ~/.bashrc << EOF_import_ps1_color
    if [ -f ~/.ps1_color ]; then
        source ~/.ps1_color
    fi
EOF_import_ps1_color
fi


# 设定 ~/.ps1_color 的内容。根据用户是否为 root，\\$ 是会变化的
cat > ~/.ps1_color << 'EOF_PS1'
user_color='\e[34m'
host_color='\e[34m'
workdir_color='\e[34m'
init_color='\e[0m'
PS1="\n${user_color}\u${init_color}@${host_color}\h${init_color} ${workdir_color}\w${init_color} \\$ \n"
EOF_PS1
source ~/.bashrc