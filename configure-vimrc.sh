#!/bin/bash

##################################################
# File Name: configure-vim.sh
# Author: xiangxiaoc
# Email: xiangxiaoc@vip.qq.com
# Created Time: Wed 12 Sep 2018 02:30:05 AM CST
##################################################

author_name='$author_name'
author_email='$author_email'

function append_str() {
cat << EOF 
autocmd BufNewFile *.py,*.sh, exec ":call SetTitle()"
let $author_name = "xiangxiaoc"
let $author_email = "xiangxiaoc@vip.qq.com"

func SetTitle()
if &filetype == 'sh'
        call setline(1,"\#!/bin/bash")
        call append(line("."), "")
        call append(line(".")+1, "\##################################################")
        call append(line(".")+2, "\# File Name: ".expand("%"))
        call append(line(".")+3, "\# Author: ".$author_name)
        call append(line(".")+4, "\# Email: ".$author_email)
        call append(line(".")+5, "\# Created Time: ".strftime("%c"))
        call append(line(".")+6, "\##################################################")
        call append(line(".")+7, "")
else
        call setline(1,"\#!/usr/bin/env python")
        call append(line("."), "\#coding:uft-8")
        call append(line(".")+1, "")
        call append(line(".")+2, "\##################################################")
        call append(line(".")+3, "\# File Name: ".expand("%"))
        call append(line(".")+4, "\# Author: ".$author_name)
        call append(line(".")+5, "\# Email: ".$author_email)
        call append(line(".")+6, "\# Created Time: ".strftime("%c"))
        call append(line(".")+7, "\##################################################")
        call append(line(".")+8, "")
endif

autocmd BufNewFile * normal G
endfunction

" 显示命令过程
set showcmd

" 显示行号
set number

" 搜索匹配高亮，同时边输入边高亮
set hlsearch
set incsearch

" 智能缩进
set smartindent

" 使用空格代替 tab 键
" set expandtab
" 智能tab
" set smarttab
EOF
}

append_str >> ~/.vimrc
