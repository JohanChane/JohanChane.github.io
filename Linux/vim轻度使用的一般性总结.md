# vim 的一般性总结（轻度使用）

### refer

- 鸟哥私房菜
- https://zh.wikibooks.org/wiki/Vim/%E4%B8%89%E7%A7%8D%E6%A8%A1%E5%BC%8F
- https://zhuanlan.zhihu.com/p/72385924

	*vim 注释/去注释*


平时在 linux 下作开发，偶尔要用到 vim。这里就写一些 vim 的使用心得给大家入门，其实使用 vim 不算很难，了解其一般性设计即可。这里不作细致总结，重点讨论其一般性。还有一些常用命令。

适合人群：刚了解 vim 但难以记忆 vim 的使用。

### vim 有三种模式（这里不细说）

- 命令模式
- 编辑模式
- 底线命令模式
  
### 一般性设计

在命令模式下，如果输入的命令立即完成，则可在命令前输入一些参数，如果输入的命令没有立即完成则可在命令后输入一些参数。*比如：*

- x 是向后删除字符命令, 输入 x 则立即完成，可在命令前输入 2 则可向后删除两个字符。
- d 也是删除命令，输入 d 没有立即完成，可在命令后输入 2W（向后移动两个词）则可向后删除两个词。

按键代表的一般性

- x: 删除字符
- c, d: 删除字符串或行。区别是删除后是否进入编辑模式。
- y: 复制
- p: 粘贴

*命令是区分大小写的。比如：D，d 是有区别的。*

### 移动光标

- 左右上下移动光标：hljk                   # 可带参数：N（整数）。比如：2j。
- 向前，后移动词：w, b; W, B               # 可带参数：N（整数）。比如：2w。
- 行首，尾移动：0, $
- 全文首，尾移动：gg, G                    # 可带参数：N（整数）。比如：5gg, 移动到第 5 行。

### 选择

- 选择字符

	v。比如：v2W
	
- 选择行

	V。比如：V2j
	
- 选择块

	C-v。比如：C-vjjll

### 编辑动作

- 字符

    字符前，后插入：i, a
    向前，后删除字符：X, x
    
- 词
	
	*\# 下面再讲*
- 行

    行首，尾插入：I，A
    删除行，删除并编辑行：dd, cc
    复制行：yy
    
- 全文

	*\# 下面再讲*

- 其他

	删除光杆后的字符：D，C

### 快速定位列

`([f | F]<C>), (;), (,)`


- *`<C>` 代表一个字符。比如： fw, 向后快速定位到该行的 w 字符，Fw, 向前快速定位到该行的 w 字符。*

- *`(;)` 表示重复之前的 find 命令，`(,)` 表示反转之前的 find 命令。*


### 编辑动作与移动光标的结合

*这里就可以很好地体现上面说的一般性设计，移动光标命令成了参数。*

- 字符

    向前，后删除 N 个字符：`<N>X, <N>x`
    
- 词

    向前，后删除 N 个词：`d<N>B, d<N>W; c<N>B, c<N>W`
    向前，后复制 N 个词：`d<N>B, d<N>W`
    
- 全文

    删除全文：`dG(光标在全文首)， dgg(光标在全文尾); cG(光标在全文首)， cgg(光标在全文尾);`
    复制全文：`yG(光标在全文首)， ygg(光标在全文尾)`

### 编辑动作与选择结合

- 删除行

	`V{x | d | c}`。比如：`Vjd` 删除两个行
	
- 复制行

	`Vy`。比如：`Vjy` 复制两行。

- 块的复制，删除，编辑

    比如：`C-vjjll{y | x | d | c | y}`。
    
    应用场景：可用于注释。

### 寄存器

-  reg 查看所有寄存器。`reg`
- 粘贴寄存器内容。`"<reg>p`
- 命令模式下粘贴寄存器内容。`c-r<reg>`
- 是从 vim 复制内容到系统剪切板，`"*y` 是从系统剪切板粘贴到 vim 。`gVim "+y`

### 搜索

- 搜索不区别大小写。*说得准确一点是 `'less -i'` 的模式。*

	`/<pattern>\c。比如：/pacman\c`
	
- 全词匹配

	`/\<<word>\>。比如：/\<pacman\>`
### 替换

与 sed 命令的替换有点类似。

### 插入模式下的快捷键

- `c-t`

	行首插入 tab
	
- `c-d`

	行首删除 tab
	
- `c-w`

	删除一个词
	
- `c-u`

	删除一行

### 其他快捷键

- 复制 `C-insert`
- 粘贴 `shift+insert`
- 剪切 `C-delete`
- 跳回上次光标处：`C-o`

### 查找帮助文档

	:help help              # 学会这个就可以了

---

*最后是我的 gVim 配置供大家学习一下，也适用于 linux 的 vim*

```
" ################################################## Customize ##################################################
" ################################################## Refer ##################################################
" refer: https://blog.csdn.net/luyong3435/article/details/37941173
"           解决乱码
" refer: https://www.cnblogs.com/xuxm2007/archive/2012/07/18/2556653.html
"           encoding, encodings, termencoding ... 的解释
" refer: https://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim
"           tab 键
" refer: https://blog.csdn.net/GerryLee93/article/details/106476034
"           文件类型相关设置
" refer: https://blog.csdn.net/u010381648/article/details/52244801?locationNum=5&fps=1
"           解决 Vim/Gvim 插入模式下 backspace 按键无法删除中文字符

" ################################################## 设置文件编码 ##################################################
" 编码 chinese 是别名，是 simplified Chinese: on Unix "euc-cn", on MS-Windows cp936
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

"解决菜单乱码  
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"解决consle输出乱码
language messages zh_CN.utf-8

" ################################################## 设置 table 键 ##################################################
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" ################################################## 文件类型的相应设置 ##################################################
filetype plugin indent on
filetype detect
autocmd FileType text setlocal textwidth=0          " txt 文件编辑时不自动换行
autocmd FileType make set noexpandtab				" makefile 文件时，按下 tab 键则输入一个 tab

" ################################################## 与按键、鼠标相关的 ##################################################
set cursorline                      "启用光标行
" set cursorcolumn                   "启用光标列
set mouse=a                         "在任何模式下鼠标都可用

" 解决 Vim/Gvim 插入模式下 backspace 按键无法删除中文字符
set nocompatible
set backspace=indent,eol,start

" 快捷键进入 paste 模式
" nnoremap <F12> :set invpaste paste?<CR>
" set pastetoggle=<F12>
" set showmode

" ################################################## 主题与字体 ##################################################
" 设置颜色主题
" ..colors/ 下有多个主题文件
" colorscheme default
" colorscheme evening

" 设置字体
set guifont=Consolas:h12
" used for double-width characters
" set guifontwide=Courier\ New:h14

" ################################################## Others ##################################################
set fileformats=unix,dos        " 优先使用 unix 格式

syntax on                       " 语法高亮
set hlsearch                    " 查找高亮

set nobackup                    "不生成备份文件
set noundofile
```