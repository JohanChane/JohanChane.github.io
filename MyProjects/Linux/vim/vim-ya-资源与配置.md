# vim 配置

## vim 资源

### Refers

- <https://vimawesome.com/>

    插件查询

- <https://github.com/vim/vim>

    github 的 vim

- <ftp://ftp.vim.org/pub/vim/unix>

    各版本 vim 的源码

- <https://tuxproject.de/projects/vim/>

    别人编译好的 vim

- vimrc 参考

    - <https://www.shortcutfoo.com/blog/top-50-vim-configuration-options/>
    - <https://github.com/amix/vimrc>

- vim cheet sheet

    - <https://vim.rtorr.com/>

- 编译 vim 参考

    - <http://www.pingwu.me/2013/12/gvim-74-x64-for-windows-with-gdi-and-gfw.html>
    - <https://www.cnblogs.com/memset/archive/2013/06/14/3134910.html>
    - <https://www.cnblogs.com/abcat/p/3392727.html>

- markdown

    谷歌插件 Markdown Viewer


## 个人 vimrc

" ***个人当前 vimrc 配置，仅供参考，不作维护***

```
" # Customize

" ### Refer
" refer: https://blog.csdn.net/luyong3435/article/details/37941173
"           解决乱码
" refer: https://github.com/VundleVim/Vundle.vim/wiki/Vundle-for-Windows
"           安装插件管理器 Vundle
" refer: https://blog.csdn.net/zxy9602/article/details/79439257
"           安装插件管理器 Vundle，及一些参考配置
" refer: https://www.cnblogs.com/xuxm2007/archive/2012/07/18/2556653.html
"           encoding, encodings, termencoding ... 的解释
" refer: https://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim
"           tab 键
" refer: https://blog.csdn.net/GerryLee93/article/details/106476034
"           文件类型相关设置
" refer: https://blog.csdn.net/u010381648/article/details/52244801?locationNum=5&fps=1
"           解决 Vim/Gvim 插入模式下 backspace 按键无法删除中文字符

" ## General

" ### 是否用 vimrc_example
" Vim with all enhancements
"source $VIMRUNTIME/vimrc_example.vim

" ### 打开功能
" filetype
filetype on
filetype plugin on
filetype indent on

" syntax
syntax on

" #### 准备工作

" for markdown and url
let webBrowser = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
"let $PATH ..= ';' . webBrowser

" ### vim 的相关文件
set nobackup                    "不生成备份文件
set noundofile
" swap file
set directory='.,$TEMP,c:\tmp,c:\temp'

"### 当文件改变时自动读取
set autoread
autocmd FocusGained,BufEnter * checktime

" ### 设置文件编码和格式
" 编码 chinese 是别名，是 simplified Chinese: on Unix "euc-cn", on MS-Windows cp936
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

set fileformats=unix,dos        " 优先使用 unix 格式

"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"解决consle输出乱码
language messages zh_CN.utf-8

" ### 文本显示效果
set wrap            " 文本过长可折行显示，并没有添加换行符只是换行显示。
set nolinebreak     " linebreak 是防止一个词被折行显示。对于英文来说是好的，但是对于中文，vim 会将一行没有空白符的文字当成一个词。
set textwidth=0     " 如果不为 0，插入模式下，一行如果超过 textwidth 且有空白符时，会在空白符插入一个换行符。如果是中文的话不建议使用，理由与 nolinebreak 一样。

" ### 设置 table 键
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" softtabstop 的意思是插入模式下，按 tab 则突出 softtabstop 的距离而不是 tabstop 的距离。
set softtabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" 在行前插入删除时，会根据 'shiftwidth' 来插入与删除，而其他地方则根据 'tabstop' or 'softtabstop'。
set smarttab
" On pressing tab, insert 4 spaces
set expandtab

" ### 设置 indent
" 有点像 C 语言的缩进。比如遇到 `{}` 时。
set smartindent

" ### 搜索
set hlsearch
set smartcase       " 与 shell 的 'less -i' 相同
set incsearch       " 边搜索可以边添加搜索的字符。添加光标后的一个字符 C-l，添加一个词  `C-r,C-w`。

" ### 针对文件类型的相应设置
" autocmd FileType text set textwidth=0                           " txt 文件编辑时不自动换行
autocmd FileType make set noexpandtab				            " makefile 文件时，按下 tab 键则输入一个 tab

" ### 与按键、鼠标相关的
set mouse=a                         "在任何模式下鼠标都可用
set cursorline                      "启用光标行，这样能发现一行长的文本是否是折行显示。
" set cursorcolumn                   "启用光标列

set ruler           " 显示光标的行列号

" 显示相对于光标的行号，方便行间跳转
if v:version >= 703
    set relativenumber
endif

" 列出补全的选项
set wildmenu

" 解决 Vim/Gvim 插入模式下 backspace 按键无法删除中文字符
set nocompatible
set backspace=indent,eol,start

" #### 快捷键进入 paste 模式
" nnoremap <F12> :set invpaste paste?<CR>
" set pastetoggle=<F12>
" set showmode


" #### 用浏览器打开此文件(为了 markdown 文件)
" Evoke a web browser
function OpenFileWithBrowser ()
    let thisFile = expand('%:p')
    exec ':silent !start "' . g:webBrowser . "\" -new-window \"file:///" . thisFile .  "\""
endfunction

map <Leader>f :call OpenFileWithBrowser ()<CR>

" #### 用浏览器打开 URL(不需插件)
" https://vim.fandom.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
" for test
"   www.example.com
"   http://www.example.com
"   https://www.example.com
"   ftp://www.example.com
"   file://www.example.com/index.html
"   file:///D:/
"   chrome 打开 ftps, sftp url 时，地址栏是空的

" Evoke a web browser
" function! Browser ()
"     let line0 = getline (".")
"     " matchstr 的正则表达与标准正则表达式不同。
"     let line = matchstr (line0, "https*://[^ ]*")
"     :if line == ""
"     :endif
"     :if line == ""
"     let line = matchstr (line0, "ftp://[^ ]*")
"     :endif
"     :if line == ""
"     let line = matchstr (line0, "file://[^ ]*")
"     :endif
"     :if line == ""
"     let line = matchstr (line0, "www\.[^ ]*")
"     :endif
"     " 指定特殊字符, 会自动将它们前面添加 <Leader>
"     " let line = escape (line, "#?&;|%")
"     " :if line==""
"     " let line = "\"" . (expand("%:p")) . "\""
"     " :endif
"
"     " 注意：`:!start` 是调用 vim 的 start, 而 `:! start` 是调用 shell 的 start。
"     :if line != ""
"     exec ':silent !start "' . g:webBrowser . "\" \"" . line .  "\""
"     " exec ':silent ! start "title" "' . g:webBrowser . "\" \"" . line . "\""
"     :endif
" endfunction

" map <Leader>w :call Browser ()<CR>

" ### 主题与字体
" 设置颜色主题
" ..colors/ 下有多个主题文件

set t_Co=256
" set background=dark

" colorscheme default
colorscheme desert

" 设置字体
set guifont=Consolas:h11
" set guifont=YaHei_Consolas_Hybrid:h12
" used for double-width characters
" set guifontwide=Courier\ New:h12

" ### Others
" ## 插件管理器

" https://vimawesome.com/
"   有很多不错的插件

" ### Vundle
" https://github.com/VundleVim/Vundle.vim
"   要安装 git

" filetype off
" set shellslash
" set rtp+=$VIMRUNTIME/vimfiles/bundle/Vundle.vim
" call vundle#begin('$VIMRUNTIME/vimfiles/bundle')            " 指定插件安装的位置
" " let Vundle manage Vundle, required
" Plugin 'VundleVim/Vundle.vim'
"
" " 添加 Plugins。PluginInstall 时会下载插件到 $VIMRUNTIME/vimfiles/bundle 下
"
" " https://github.com/vim-scripts/AutoComplPop
" " Plug 'vim-scripts/AutoComplPop'
"
" " All of your Plugins must be added before the following line
" call vundle#end()            " required
" filetype plugin indent on    " required
" "   To ignore plugin indent changes, instead use:
" " filetype plugin on
" "
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line

" ### vim-plug
" https://github.com/junegunn/vim-plug
"   要安装 git

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('$VIMRUNTIME/.vim/plugged')     " 设置插件安装位置

" Make sure you use single quotes


" https://github.com/vim-scripts/AutoComplPop
Plug 'vim-scripts/AutoComplPop'

" https://github.com/tyru/open-browser.vim
Plug 'tyru/open-browser.vim'

Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-markdown'

" Initialize plugin system
call plug#end()

" ### 插件的配置

" #### open-browser

" openbrowser-smart-search 会检测是否是 URI，是则打开，否则搜索该词
" openbrowser-open 直接打开，如果不是 URI 则会报错。

" This is my setting.
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" Open URI under cursor.
"nmap <Leader>w <Plug>(openbrowser-open)
" Open selected URI.
"vmap <Leader>o <Plug>(openbrowser-open)

" https://github.com/vim-scripts/AutoComplPop
" Search word under cursor.
"nmap <Leader>w <Plug>(openbrowser-search)
"Search selected word. vap map-you-like <Plug>(openbrowser-search)

" If it looks like URI, Open URI under cursor.
" Otherwise, Search word under cursor.
"nmap map-you-like <Plug>(openbrowser-smart-search)
" If it looks like URI, Open selected URI.
" Otherwise, Search selected word.
"vmap map-you-like <Plug>(openbrowser-smart-search)

" #### nerdtree

" 打开/关闭 nerdtree
map <C-n> :NERDTreeToggle<CR>       " 打开或关闭 NERDTree

" ## 加载别人的配置
" source $VIMRUNTIME\VimConfigs\basic.vim
```
