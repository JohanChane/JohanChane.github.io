# Vim 基础

## Content

${toc}

## References

-   vim help
-   [Vim 从入门到精通](https://github.com/wsdjeg/vim-galore-zh_cn)

## 基础概念

一个 buffer 对应一个文件，保存 buffer 时，会将 buffer 的内容写入文件。

window 是一个窗口，一个 buffer 可以有多个窗口。

-   vim 模式

-   motions and operator

-   text-objects

    一"块"文本

-   Ex command, mode

    `help :`
        Command-line mode is used to enter Ex commands (":")

    `Q, visual, vim -e`

-   vim "组件"

-   range

    可为命令指定 range。

    `help cmdline-ranges`。为命令指定范围。比如：%!xxd

## Get Help

### 搜索 tags

    help help-context

    # 只列出一个匹配的 tag
    help <tag>

    # 进入 help 帮助文档后用此命令，则是用正则表达式搜索 help tags（列出所有符合的 tags），然后可以用 ts 等命令操作这些 tags。
    tag /<pattern>

    # 搜索整个 help 文档。
    # cwindow 导航搜索结果。
    helpgrep <pattern>


    help :<command>
    help '<option>'
    help <function>()

### 搜索快捷键

    # normal mode
    help ctrl-f
    help v_:
    help i_ctrl-w
    help c_ctrl-r
    # 多个按键用下划线分隔
    help ctrl-w_]

## 查看消息

### 查看消息

    # 不包括 echo 的输出
    message
    # 输出一个正确的消息到 message
    echom
    # 输出一个错误的消息到 message
    echoe

    # 查看最后一个错误消息
    echo v:errmsg
    # 查看最后一页输出。包含 echo 输出和 message 的消息。
    g<

### 过虑命令的输出

filter

    filter /<pattern>/ <cmd>       # 能过虑命令的输出

### 查看 Options

    # 查看所有非默认选项
    set
    # 查看所有选项
    set all

    # ## options
    # ### 有值的
    set autoread?
    OR
    echo &autoread

    set fileencodings?
    OR
    echo &fileencodings

    # ### on OR off 选项
    let syntax_on

    # ### 多个 items
    :filetype
    :autocmd

### 查看变量

    # ### list the values of all variables
    # 值前面为 `#` 是数字类型，而 `*` 是函数引用。
    let

#### 特殊变量类型

    " 表示 option（set <option>） 的值。比如：echo &number
    &<option>
    " 表示环境变量的值。比如：echo $VIMRUNTIME
    $<environmentVar>
    " 表示寄存器的值。比如：echo @0
    @<register>

### 查看所有函数

    fun                 # 列出所有函数和它们的参数
    fun <name>          # 查看函数内容
    fun /<pattern>      # 搜索函数

### 查看所有用户命令

    com             # 列出所有用户命令
    com <cmd>       # 查看以 <cmd> 开头的命令

    # 查看加载了哪些脚本
    scriptnames

### 查看错误信息或日志

nvim

    :messages

    :verbose
    # 会输出 verbose 等级为 9 的日志到 myVim.log
    nvim -V9myVim.log

coc.nvim

    :CocInfo
    :CocOpenLog

## Motion and Operator

ref: `help curso-motions`

### Operator

#### `help changing`

    c, d, y, s, S, x, X
    cc, dd                  # 它们是删除行，而 S 是删除一个句子
    C, D

    # 命令也可以在命令行模式下使用。比如：`:dl`

#### `help operator`

    c, d, y

### Motion

有以下这些 motions（Left-right motions, Up-down motions, Word motions）

-   Text object motions
-   Text object selection. *不能单独使用，要结合 opertor 与 visual mode 使用*
-   Marks
-   Jumps
-   Various motions

#### `help left-right-motions`

    0, ^        # 区别：行首，句首
    $

    # 重点
    f, F, `;`, `,`            # 快速定位列

#### `help word-motions`

    w, W, b, B

#### `help text-motions`

    句子之间移动
        (, )
    段落之间移动
        {, }
    section或{} 之间移动
        {: [[, ]]
        }: [], ][
        # [: 向前
        # ]: 向后

#### `help text-objects`

    a: text-object + 包含边界
    i: text-object

    w, W, s, p, <>, [], (), <>, {}, "", '', ``, <></>(tag)

    与 operator 结合使用    # 重点
        ciw
        diw
        yiw

    与 visual mode 结合使用     # 重点
        用于选择 text-object。比如：viw。

#### `help forced-motion`

visual-block 是可以编辑的。应用场景，注释。

## Vim 的"组件"

### buffers

    :ls
    :b<n|N>, :b <N>
    # 将所有 buffers 以 window 打开，一个 buffer 对应一个 window
    :sb <N>, :sba
    # 将所有 buffers 以 tab 打开，一个 buffer 对应一个 tab
    :tab ba

    :e <file>, enew(新建一个空的 buf), vnew(新建垂直的空的 buf), bdel
    # 每个 buf 都执行 <cmd>。比如：:bufdo bd[elete]。
    :bufdo <cmd>

### windows

    :split      # 水平分割
    :vsplit     # 垂直分割

    # 不同窗口之间移动
    C-w + Left, Right ...
    # 返回上一个窗口
    C-w p

    # 平分窗口
    C-w =
    # 上下窗口布局时，最大化当前窗口
    C-w _
    # 左右窗口布局时，最大化当前窗口
    C-w |

    # 调整高度。将当前窗口增加/减少n行
    Ctrl + w, n, +/-

    # 调整宽度。将当前窗口增加/减少n列
    Ctrl + w, n, >/<

    q, only

### registers

ref: `help registers`

    `""`: d,c,s,x,y 命令相关的文本。
    `"0`: 是最近复制的文本。比如：多次粘贴复制的文本。所以复制之后都是用 `"0` 粘贴即可。
    `"1~9`: 最近删除的内容。`"2`: 比 `"1` 更早点删除的内容。依此推到 `"9`。`"1` 表示刚删除的多行数据，而 `"-` 表示刚删除的非多行数据。
    `".` 上次插入模式下输入的内容。

    system clipboard of Linux: "+
    system clipboard of Windows: "+ 或 "*
    a-z/A-Z

    :reg, "<reg>yj, "<reg>p, C-r<reg>

### tabs

    tabnew <file>
    tabclose, tabonly
    # 向右/左选 tab
    gt/gT
    :tabp, :tabn
    # Go to previous (last accessed) tab page.
    g<tab>
    :tabfirst, :tablast

    tab <cmd>
    # 将窗口转为 tab, 但是没法将 tab 转为窗口
    C-w T
    # 显示所有 tabs
    :tabs

### jumps

每 windows 的 jumps 都不同，且 jumps 会跨 buffer（`C-o` 如果跳完本窗口的 jumps，就会跳到非本窗口的 jumps）。而且新的 windows 都有 jumps，新的窗口会继承旧窗口的 jump list。

    :ju
    N_ctrl-o
    N_ctrl-i
    :clearjumps

### changes

每个 buffers 都有自己的 changes

    :changes
    `Ng;`, `Ng,`

    # ### undos
    u, C-r
    g-, g+

`u, C-r` 与 `g-, g+` 的区别

> 值得注意的是，Vim 采用 tree 数据结构来存储内容变更的历史记录，而不是采用 queue。你的每次改动都会成为存储为树的节点。而且，除了第一次改动（根节点），之后的每次改动都可以找到一个对应的父节点。插件 `undotree` 可显现这一点。
>
> u, C-r 是按父子结节的还原修改的，而 g-, g+ 是按时间来还原修改的。

for example

    AAA           AAA           AAA
    BBB  =`u`=>   BBB   ==>     BBB
    CCC                         DDD
    
    # BBB 是 CCC, DDD 的父结点。
    # u, C-r 则不能重现 CCC，因为到 BBB 结点时会转为 DDD 结点。所以是兄弟节点中，只能访问最近的访问的节点。

### marks

每个 buffer 都有各自的 `m[a-z]`。但 `m[A-Z]`(也称 file marks) 是属于 vim 程序的，vim 退出后则丢失。file marks 可跨文件跳转。

`m[0-9]` 不能直接设置，是 viminfo 设置的。比如：`m0` 是上次最后 vim 时光标所在位置。

    :marks, m[a-zA-A], `<mark>

### tags

    :ts, :tn, :tp, C-](C-w-]), C-t

### 宏 (recoding)

ref: `help recording`

录制一系操作到寄存器。

    # ### 创建宏
    # 开始录制
    q<reg>
    # 结束录制
    q

    # ### 使用宏
    @<reg>

    # ### 查看宏
    :reg

### quickfix-list and location-list（一般存放编译错误信息和 tags）

ref: `help quickfix`

-   quickfix-list

        cwindow, copen, cn, cp
        # `make|copen`

-   location-list (也称为 window-local quickfix list)

    每个 window 有各自的 location-list。

        :lwindow, lopen, ln, lp

它们是如何生成的？

> vimgrep, grep, helpgrep, make 会生成 quickfix list。而 lvimgrep, lgrep, lhelpgrep, lmake 会生成 location-list。<br>
> `ts /<reg>` 会生成 quickfix list。

### vim fold

ref: `help fold`

    # ### flod create and delete
    zf
    zd, zD, zE

    # ### fold open and close
    zo, zO
    zc, zC
    # toggle open or close fold
    za, zA

    # #### fold open and close all
    zR
    zM

    # ## others
    zv
    # next, prev fold
    zj, zk

## User Commands

ref: `help user-command`

用户可自定义命令。为了区分 builtin 命令（小写开头，除了 :Next, :X），用户命令名称应以大写开头。

用户命令定义格式

    com[mand][!] [{attr}...] {cmd} {rep}

-   cmd

    用户命令名称

-   rep

    用于替换 cmd 的文本。

-   attr

    可为用户设置一些属性。比如：`-complete`, 表示输入命令名称后，用户要补全参数时（C-d/tab），应该提示什么。`help command-complete` 可查看所有值。

        # 参数个数
        -nargs

        # 用什么补全命令
        -complete

    for example

    ```vim
    :com! -nargs=* -complete=command MyRedir :tabnew|put =execute('<args>')
    :MyRedir set all
    :q!
    ```

-   `!`

    与函数的定义的 `!` 类似。如果存在同名的命令，则会被覆盖。


*cmd rep 不需要（也不能）用引号引着。`在替换文本中，可用 <args> 表示参数列表。`*

for example

```vim
# var 表示补全 user variables
com! -nargs=1 -complete=var Test echo <args>
:Test <C-d>/tab
```

一个命令可接收range（行号），count, register, `!`, 参数。 `help <line1>`。还有命令可设置补全。

for example

```vim
:1,2s/A/a/gc
:3Next
:q!
:echo "aa"
```

在函数中，获取传入命令的东西（比如参数之类）

    <line1>, <line2>, <range>
    <count>

    <bang>
        The command can take a ! modifier (like :q or :w)

    <reg>
    <args>
        还有 <q-args>, <f-args>。
        比如 `:Com arg1 args2`：
            # 代替 Com 后面的字符
            <args>: arg1 args2
            <q-args>: "arg1 arg2"
            <f-args>: "arg1", "arg2"

## Autocmd

ref: `help autocommand`

    au[tocmd] [group] {event} {pat} [++once] [++nested] {cmd}
        event 可列出事件
        pat 用于匹配文件
        cmd 事件触发的命令

    # 列出自动命令
    :autocmd
    # 执行自动命令
    :doau

for example

```vim
autocmd FileType text set textwith=0
```

## 按键映射

ref: `help map-commands, help map-overview`

    :map, nmap, xmap, cmap, omap, imap
    :noremap, nnoremap, xnoremap, cnoremap, onoremap, inoremap      # nore: 表示非递归

    # 会被 mapleader 的内容所代替。`help mapleader`。
    <Leader>

for example

```vim
" :nmap b :echo "Foo"<cr>                    " <CR> 是按下回车
" :nmap a b                                  " a 表示 :echo "Foo"<cr>
" :nnoremap a b
" nnoremap <leader>h :helpgrep<space>
```

## Filetype

ref: `help file-type`

    # 当打开文件时，vim 会根据文件名或文件内容来识别文件类型，然后设置 filetype option（set filetype? 可查看）。其间会触发 FileType 事件。可能还会调用 $VIMRUNTIME\filetype.vim。
    :filetype on
    # 可为指定文件类型设置相应插件。会加载 $VIMRUNTIME\ftplugin.vim。
    :filetype plugin on
    # 可为指定文件类型设置相应缩进文件。会加载 $VIMRUNTIME\indoff.vim。
    :filetype indent on
    # 显示 detection, plugin, indent, 的状态。filetype on 则 detection:ON。
    :filetype

    # 再次检测文件类型。filetype on, filetype plugin, indent on 都是在打开文件时会执行的。而如果用户打开空文件，输入文本，假如输入的是 #!/bin/bash，然后输入命令 :filetype detect 则可以再次检测文件类型了，这时会识别文件为 sh 类型。会使用 detection:ON。
    :filetype detect

## Package and Autoload

package 是一个文件夹，包含多个 vim 脚本的文件。

### Runtimepath

ref: `help runtimepath`

`set runtimepath?` 可查看 runtimepath 包含的路径。

List of directories to be searched for these runtime files:

    filetype.vim	filetypes by file name |new-filetype|
    scripts.vim	filetypes by file contents |new-filetype-scripts|
    autoload/	automatically loaded scripts |autoload-functions|
    colors/	color scheme files |:colorscheme|
    compiler/	compiler files |:compiler|
    doc/		documentation |write-local-help|
    ftplugin/	filetype plugins |write-filetype-plugin|
    indent/	indent scripts |indent-expression|
    keymap/	key mapping files |mbyte-keymap|
    lang/		menu translations |:menutrans|
    menu.vim	GUI menus |menu.vim|
    pack/		packages |:packadd|
    plugin/	plugin scripts |write-plugin|
    print/	files for printing |postscript-print-encoding|
    rplugin/	|remote-plugin| scripts
    spell/	spell checking files |spell|
    syntax/	syntax files |mysyntaxfile|
    tutor/	tutorial files |:Tutor|

    And any other file searched for with the |:runtime| command.

for example

    # 添加一个 path 到 rumtimepath
    let &runtimepath.=','.string(path)

### Autoload

ref: `help autolaod`

当 `call <filename>#<funcname>()` 的格式调用时，vim 会在 'runtimepath' 路径下 'autoload' 文件夹中查找 `<filename>.vim`，然后加载（如果还没有加载）并调用它里面定义的函数 `<filename>#<function>`。

for example

```vim
" 假如有 `~/.vim/foo/autoload/filename.vim`，`call filename#function()` 则会找到 `filename.vim`。

" filename.vim
function filename#funcname()
   echo "Done!"
endfunction

call filename#funcname()
```

### Package

ref: `help package`

当 vim 启时，加载 .vimrc 之后，它会扫描在 `<pack>/*/start(<pack> 是 'packpath' 目录)` 目录下包含 'plugin' 的文件夹，且这些文件夹加到 'rumtimpack'。

`set packpath?` 可查看 packpath 包含的路径。

for example

    In the example Vim will find "pack/foo/start/foobar/plugin/foo.vim" and adds "~/.vim/pack/foo/start/foobar" to 'runtimepath'.

### Autoload and Package 的关联

ref: `help packload-two-steps`。

autoload 路径比 plugin 路径先加载，可以将 plugin 的 libraries 放入 autoload 路径。

for example

    pack/foo/start/one/plugin/one.vim
              call foolib#getit()
    pack/foo/start/two/plugin/two.vim
              call foolib#getit()
    pack/foo/start/lib/autoload/foolib.vim
              func foolib#getit()

## Startup

`help startup` 可查看 vim 启动做了哪些工作。

## Pattern

vim 使用 pattern 不是标准的正则表达式，而是 regex dialet。但与标准正则表达式相差不在，只是有些特殊字符要加转义字符。`help non-greedy` 可查看例子。

`matchstr()` 中 pattern 是不支持一些 pattern 的，比如：`\(\) # 结论是实测而来`。

## 命令行的特殊字符

ref: `help cmdline-special`

## vim 的文件

    # 备份文件
    set backup
    # 交换文件: swap file
    set directory
    # 撤消文件
    set undofile
    set undodir
    # viminfo 文件: 记录历史命令，最近打开的文件，...
    help viminfo
    set viminfo

## 执行多个命令

ref: `help :bar`

    <command> | <command>           # 类似于 shell 的 (;)
    <command> && <command>

## 执行外部命令

ref: `help :!`

### 在 windows 平台

`:!<str>`。不处理 `<str>`，而是直接放在 `cmd.exe /c (<str>)`  运行。

`:!start`, `:! start` 的区别

> `:!start` 运行的不是 shell 的 start，而 vim 内置的一个程序与 windows start 有区别，而 `:! start` 是运行 shell 的 start。

