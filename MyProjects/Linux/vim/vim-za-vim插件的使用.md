# vim 插件的使用

## nerdcommenter

### Refers

- <https://github.com/preservim/nerdcommenter>
- `help NERDCommenterContents`

### 常用

    `help NERDCustomDelimiters`
    为某个文件格式设置注释
    left, right: 设置默认的左右注释符
    leftAlt, rightAlt: 设置另一种注释符

    " Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1

    " `help NERDCommenterDefaultDelims`
    " 自动切换默认注释符（不用每次打开新的文件都要切换默认注释符）。即可会切换到 leftAlt 或 rightAlt。
    let g:NERDAltDelims_c = 1

    \ca
        切换默认注释风格。前提不进入 Visual mode。
    \cc
        注释。
    \c<space>
        Toggles the comment state of the selected line(s). 
    \cu
        取消注释。

    \cm
        尽量少注释符
    \cs
        性感的注释风格

## NERDTree

### Refers

- help NERDTree

### Get help

按 `?` 显示 quickhelp

`help NERDTree-contents` 显示帮助目录

### 配置

map <C-n> :NERDTreeToggle<CR>       " 打开或关闭 NERDTree

### 常用命令

- file node

    preview 与 open 的区别是打开文件后光标的位置。
    o, go, i, gi, s, gs
    
- directory node

    o, p, P, O, X

- filesysteme

    r, m(对 node 添加/删除等), cd(作为当前工作目录)

    - tree root（文件系统正在打开的路径，与当前工作目录不同）

        CD(change root node to PWD), C, u, R

- Bookmark

    B, Bookmark, D, 与 file node 相同的操作

- filtering

    I(隐藏 `.` 开头的文件), f(隐藏特定文件。与 NERDTressIgnore 有关), F(隐藏文件，只能看到目录)

        let NERDTressIgnore=['\.vim$']      " 隐藏 .vim 后缀的文件

## vim easy align

### Refers

- <https://github.com/junegunn/vim-easy-align>

ga 是相当于一个 operator(c,d,y)。可参考 `help y, help operator, help forced-motion`。

语法格式（与 c, d, y 类似，是在最后加入一个对齐方案和一个对齐字符）

    # [<enter>]<对齐方案>]<对齐字符> 最终是在命令行下输入的。<enter> 是取反的意思。
    ga{motion}[<enter>][<对齐方案>]<对齐字符>          
    {Visual}ga[<enter>][<对齐方案>]<对齐字符>

### 对齐方案

- 如果不写对齐方案则默认为 1。
- `N`: 前面第 N 个对齐字符对齐。
- `-N`: 后面第 N 个对齐字符对齐
- `*`: 所有对齐字符对齐。
- `**` 单元格左-右对齐。第一个单元格为左，第二个为右，第三个为左，第四个为右，依此类推。

        # 单元格默认方案是左对齐。
        # `<enter>**` 则是单元格右-左对齐。第一个单元格为右，第二个为左，第三个为右，第四个为左，依此类推。
        # 所以单元格就有了四种对齐方案：左/右/左-右/右-左。

    for example:

    ```
    | Option| Type | Default | Description |
    | --|--|--|--|
    | threads | Fixnum | 1 | number of threads in the thread pool |
    | queues |Fixnum | 1 | number of concurrent queues |
    | queue_size | Fixnum | 1000 | size of each queue |
    | interval | Numeric | 0 | dispatcher interval for batch processing |
    | batch | Boolean | false | enables batch processing mode |
    | batch_size | Fixnum | nil | number of maximum items to be assigned at once |
    | logger | Logger | nil | logger instance for debug logs |

    # 用了 `+` 和空格方便理解，所以是特殊字符，如果正常输入 `+` 和空格则用 `\+`, `\ `表示。
    vip + ga + |
    vip + ga + 2|
    vip + ga + -1|
    vip + ga + -2|
    vip + ga + <enter>3|
    vip + ga + *|
    vip + ga + <enter>*|
    vip + ga + <enter>**|
    ```

*如果还不满足可进下一步学习。[vim easy align](https://github.com/junegunn/vim-easy-align)*

## mzlogin/vim-markdown-toc

### Refers

- <https://mazhuang.org/2015/12/19/vim-markdown-toc/>

### 常用

    :GenTocGFM
    :UpdateToc
    :RemoveToc

## plasticboy/vim-markdown

### Refers

- <https://github.com/plasticboy/vim-markdown>

### 折叠命令

设置

    # 取消折叠
    let g:vim_markdown_folding_disabled = 1

`help fold-expr`

    作用于 buffer:

        zR, zM: 打开/折叠所有 folds
        zr, zm: 打开/折叠一层 folds

    作用于 fold:

        za, zc: 打开/折叠一层 folds
        zA, zC: 递归打开/折叠 folds

查看标题结构

    :Toc

## kien/ctrlp.vim

### Refers

- <https://github.com/kien/ctrlp.vim>
- <https://github.com/kien/ctrlp.vim/blob/04ddbf4cb2c921fb2c1210ce4213c1ea41c142d0/doc/ctrlp_cn.txt>

### 使用

`C-p` 进入 ctrlp 的 file mode 模式。输出 `?` 查看帮助。


- 搜索模式
    files, buffers, mru files(搜索 Files, Buffers and MRU files)
    C-f, C-b

- 搜索的路径是 PWD

- 根据文件名搜索还是路径搜索

    C-d

- 是否开启 regex

    C-r

- 历史命令
    
    C-p, C-n

- 浏览结果
    
    C-j, C-k, <Up>, <Down>

- 打开多个文件
    
    C-z + C-o

- 返回上层目录
    `..` 会修改 PWD

*`help ctrlp-mappings`, F5 是刷新*

*不支持中文输入。。。*

## Line Diff

### Refers

- <https://github.com/AndrewRadev/linediff.vim>

### 使用

Linediff
LinediffAdd, LinediffLast
tabclose

for example:

    ABCDEFGHIJKLMN
    OPQRSTUVWXYZ

    ABCDEFGHIIKLMN
    OPQRSTUUWXYZ

    ABCDEFGHIJKLNN
    OPQRSTUVVXYZ

    # 比较两个区块 
    :1, 2Linediff
    :4, 5Linediff
    :tabclose       " diff 的信息也会丢失，下次再比较时，要重新选。

    # 比较多个区块
    :1, 2Linediff
    :4, 5LinediffAdd
    :7, 8LinediffLast
    :tabclose
