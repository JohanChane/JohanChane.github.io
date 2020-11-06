# vim 笔记

### Refer

- vim help
- <https://github.com/wsdjeg/vim-galore-zh_cn>

    vim 笔记

## vim 基础

### vim 基本概念

- vim 模式

- motions and operator

- text-objects

    一"块"文本

- Ex command, mode

    `help :`
        Command-line mode is used to enter Ex commands (":")

    `Q, visual, vim -e`

- vim "组件"

- range

    可为命令指定 range。

    `help cmdline-ranges`。为命令指定范围。比如：%!xxd

### motion and operator

`help curso-motions`

#### operator

    help changing
        c, d, y, s, S, x, X
        cc, dd      # 它们是删除行，而 S 是删除一个句子
        C, D

        # 命令也可以在命令行模式下使用。比如：`:dl`

    help operator
        c, d, y

#### motion

有以下这些 motions

- Left-right motions		
- Up-down motions
- Word motions			
- Text object motions		
- Text object selection. *不能单独使用，要结合 opertor 与 visual mode 使用*
- Marks
- Jumps
- Various motions

#### motions 的详细说明(只列出部分)

    help left-right-motions
        0, ^        # 区别：行首，句首
        $

        # 重点
        f, F, `;`, `,`            # 快速定位列

    help word-motions
        w, W, b, B

    help text-motions
        句子之间移动
            (, )
        段落之间移动
            {, }
        section或{} 之间移动
            {: [[, ]]
            }: [], ][
            # [: 向前
            # ]: 向后

    help text-objects
        a: text-object + 包含边界
        i: text-object

        w, W, s, p, <>, [], (), <>, {}, "", '', ``, <></>(tag)

        与 operator 结合使用    # 重点
            ciw
            diw
            yiw

        与 visual mode 结合使用     # 重点
            用于选择 text-object。比如：viw。

    help forced-motion
        visual-block 是可以编辑的。应用场景，注释。

### vim 基础命令，函数，操作

    set, let, echo, echom, call
    put
    exe
    execute()
    filter

#### 查看消息

    message
        不包括 echo 的输出
    echom
        输出一个正确的消息到 message
    echoe
        输出一个错误的消息到 message
        
    echo errmsg
        查看最后一个错误消息
    g<
        查看最后一页输出。包含 echo 输出和 message 的消息。
    
#### 命令行的特殊字符

    help cmdline-special
        help c_%

#### 命令或函数的使用

    查看设置的值
        set <option>?

    在命令中，将 expr 的内容作为命令，并执行该命令。可用表达式拼接成命令并执行。
        exe <expr>

            for example:
                exe "echo 'AA'"
                let cmd="echo 'BB'"
                exe cmd

    执行命令并返回命令 output string
        execute(<cmd>)
            <cmd> can be a string or a List.
        
            for example:
                let outputStr = execute("set fileencodings?")
                put =outputStr

    输出寄存器或表达式的内容，还有命令的 output string 到文件
        put <reg>
        put =<expr>
            注意：`expr` 中的 `|` `"` 要转义。
            for example:
                put "0
                put =$VIMRUNTIME
                put ='ABC'
                put =\"ABC\"

                # 函数也是一个 expr
                put =execute(\"echo 'AA' \| echo 'BB'\")

    过虑命令的结果
        filter /<path> <cmd>
            for example:
                filter /v:version/ let

#### 执行外部命令

    help :!<str>       # 重点    # 不处理 <str>，直接放在 shell: cmd.exe /c (<str>)  运行。
    `:!start`, `:! start` 的区别   # 重点
        `:!start` 运行的不是 shell 的 start，而 vim 内置的一个程序与 windows start 有区别，而 `:! start` 是运行 shell 的 start。
    
    help :rang!
        
#### 执行多个命令

    help :bar
    <command> | <command>           # 类似于 shell 的 (;)
    <command> && <command>

### vim "组件"

*一般是一个 buf 对应一个 file，多个 windows*

buffers, windows, tab pages, reg, jumps, changes, marks, quickfix-list and location-list, tags

    buffers
        :ls, :b<n|N>, :b <N>, :sb <N>, :sba, :e <file>, enew, bdel
        :bufdo <cmd>
            每个 buf 都执行 <cmd>。比如：:bufdo bd[elete]。

    windows
        一般与 buf 命令共同。
        :q
            退出当前 window。如果所有 windows 被关闭后，vim 不管是否还是 buf（已保存），都会退出。
        :qa
            退出所有 windows。

    tab pages
        `help tabpage`
        一个 tab page 可有多个 windows。比如：vsplist 后 tab page 会添加一个窗口。
        默认只有一个 tab page, 可用 tab 新建一个 tab page。
        tabs, tabclose

    regs
        :reg, "<reg>yj, "<reg>p, C-r<reg>

    jumps
        每个 windows 都有各自的 jumps。且子窗口会继承父窗口的 jumps。
        :ju, C-i, C-o
    changes
        每个 buffer 都有各自的 changes。
        :changes, g;, `g,` u, C-r, g-, g+
        u, C-r 与 g-, g+ 的区别
            值得注意的是，Vim 采用 tree 数据结构来存储内容变更的历史记录，而不是采用 queue。你的每次改动都会成为存储为树的节点。而且，除了第一次改动（根节点），之后的每次改动都可以找到一个对应的父节点。
            u, C-r 是按父子结节的还原修改的，而 g-, g+ 是按时间来还原修改的。
                for example:
                    AAA           AAA           AAA
                    BBB  =`u`=>   BBB   ==>     BBB
                    CCC                         DDD
                        
                    # BBB 是 CCC, DDD 的父结点。
                    # u, C-r 则不能重现 CCC，因为到 BBB 结点时会转为 DDD 结点。所以是兄弟节点中，只能访问最近的访问的节点。
    
    marks
        每个 buffer 都有各自的 `m[a-z]`。但 `m[A-Z]`(也称 file marks) 是属于 vim 程序的，vim 退出后则丢失。
        `m[0-9]` 不能直接设置，是 viminfo 设置的。比如：`m0` 是上次最后 vim 时光标所在位置。
        :marks, m[a-zA-A], `<mark>

    quickfix-list and location-list（一般存放编译错误信息和 tags）
        `help quickfix`
        quickfix-list
            cwindow, copen, cn, cp
        location-list (也称为 window-local quickfix list)
            每个 window 有各自的 location-list。
            :lwindow, lopen, ln, lp

        它们是如何生成的？
            vimgrep, grep, helpgrep, make 会生成 quickfix list。而 lvimgrep, lgrep, lhelpgrep, lmake 会生成 location-list。
            ts /<reg> 会生成 quickfix list。
    tags
        :ts, :tn, :tp, C-], C-t


#### 寄存器

    help registers

    "": 最近复制或删除的内容
    "0: 最近复制的内容
    "1~9: 最近删除的内容。"2: 比 `"1` 更早点删除的内容。依此推到 "9。
    ...
    system clipboard of Linux: "+
    system clipboard of Windows: "+ 或 "*
    a-z/A-Z
    
    ". 上次插入模式下输入的内容。

#### 宏 (recoding)

    录制一系操作到寄存器。

    help recording
        创建宏
            开始录制
                q<reg>
            结束录制
                q
                
        使用宏
            @<reg>

        查看宏
            :reg

#### 窗口与 tab

    help ctrl-w
        C-w + Left, Right ...: 不同窗口之间移动

    windows
        :split      # 水平分割
        :vsplit     # 垂直分割
    
        C-w =
        C-w - 
        C-w |
        C-w p
    tab
        tab <cmd>
        C-w T           # 没法将 tab 转为窗口，只能关闭再打开
        gt
        gT

#### 按键映射

    help map-commands
        :map, nmap, xmap, cmap, omap, imap
        :noremap, nnoremap, xnoremap, cnoremap, onoremap, inoremap      # nore: 表示非递归
    
    <Leader>
        会被 mapleader 的内容所代替。`help mapleader`。

        for example:
            " :nmap b :echo "Foo"<cr>                    " <CR> 是按下回车
            " :nmap a b                                  " a 表示 :echo "Foo"<cr>
            " :nnoremap a b
            " nnoremap <leader>h :helpgrep<space>

    filetype
        help file-type

        :filetype on
            当打开文件时，vim 会根据文件名或文件内容来识别文件类型，然后设置 filetype option（set filetype? 可查看）。其间会触发 FileType 事件。可能还会调用 $VIMRUNTIME\filetype.vim。
        :filetype plugin on
            可为指定文件类型设置相应插件。会加载 $VIMRUNTIME\ftplugin.vim。
        :filetype indent on
            可为指定文件类型设置相应缩进文件。会加载 $VIMRUNTIME\indoff.vim。
        :filetype
            显示 detection, plugin, indent, 的状态。filetype on 则 detection:ON。

        :filetype detect
            再次检测文件类型。filetype on, filetype plugin, indent on 都是在打开文件时会执行的。而如果用户打开空文件，输入文本，假如输入的是 #!/bin/bash，然后输入命令 :filetype detect 则可以再次检测文件类型了，这时会识别文件为 sh 类型。会使用 detection:ON。

#### autocmd

    help autocommand

    au[tocmd] [group] {event} {pat} [++once] [++nested] {cmd}
        event 可列出事件
        pat 用于匹配文件
        cmd 事件触发的命令

    列出自动命令
    执行自动命令
        :doau 

    for example:
        autocmd FileType text set textwith=0

### grep

`help grep`

vim 有两种搜索方式，internal grep(vimgrep) 和 external grep(grep)。

    内部 grep 的好处是能在所有系统上使用，和能使用强大的 vim search patterns。坏处是比外部 grep 慢，因为文件都要读入内存。
    vimgrep, grep 会生成 quickfix list, 而 lvimgrep, lgrep 会生成 location list。

#### internal grep

    格式
        vim[grep][!] /{pattern}/[g][j] {file} ...
            g: 如果没有 g, 则添加每行第一次匹配（match）。如果有 g, 则每行的所有匹配。
            j: jump。表示跳到第一次匹配的位置，否则只是更新 quickfix list。
            !: With the [!] any changes in the current buffer are abandoned.
        <count>vim ...
            <count>: 匹配的最大次数。

        lvimgrep 也 grepvim 是一样的格式，lvimgrep 只是添加匹配到 location list.

        vimgrepadd, lvimgrepadd 也与 vimgrep 有一样的格式，不同的是 <vimgrep>add 添加 list 到 current list, 而 <vimgrep> 生成新的 list。


    for example:
        :vimgrep /stdio\.h/ /usr/include/*.h

#### external grep

与 linux grep 有相同的接口，即用法一样。grep 不是系统提供的，而是 vim 提供的。比如：windown gvim 的 grep 是用 findstr 查找的。

    格式
        grep [arguments]
        lgrep
        grepadd, lgrepadd

    for example:
        :grep -ir 'stdio\.h' /usr/include/*.h

### vim 的文件

    备份文件
        set backup
    交换文件: swap file
        set directory
    撤消文件
        set undofile
        set undodir
    viminfo 文件: 记录历史命令，最近打开的文件，...
        help viminfo
        set viminfo

### vim 快捷键

#### Others

    help dos-standard-mappings
        复制 C-insert
        粘贴 S-insert
        剪切 C-del
        
    help ins-special-keys
        词之间移动
            S-Left
        删除词
            C-w
        删除行
            C-u
        
        插入/删除 tab
            c-t
                tab
            c-d
                删除 tab
                
    插入模式或命令模式下粘贴 reg 内容
        help c_ctrl-r
            C-r<reg>
    
    补全
        C-i/tab/S-tab: 匹配下个命令。
        C-d: 列出所有匹配的命令
        
        插入模式下的补全: C-p, C-n

    easy 模式转为普通模式
        help i_ctrl-l

        gVim easy 模式是 insert-mode，所以 C-l 从 easy 模式转到普通模式。这就可进入命令行模式了。

### 字符名称、合成符（digraphs）、不可见字符、编码

#### [字符名称](https://en.wikipedia.org/wiki/List_of_Unicode_characters)

*可用 `help digraphs-default` 查看*

应用场景：当在网上搜索含有特殊字符的问题时，可用它们的名称搜索。

for example

| char name         | char |
| --                | --   |
| Colon             | :    |
| Comma             | ,    |
| Percent sign      | %    |


#### 合成符（digraphs）

*可用 `help digraph-table` 查看*

应用场景：设置一些软件的快捷键。

for example

| char | digraph | hex  | dec | official name        |
| --   | --      | --   | --  | --                   |
| ^@   | NU      | 0x00 | 0   | NULL (NUL)           |
| ^@   | LF      | 0x0a | 10  | LINE FEED (LF)       |
| ^M   | CR      | 0x0d | 13  | CARRIAGE RETURN (CR) |

#### 不可见字符

查看不可见字符: `set list`, `%!cat -A`

设置不可见字符的显示形式: `set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<`

##### 换行符

windows 的换行符为 `CRLF`（`CR` 即 `^M`）。，而 unix 的换行符为 `LF`。

`set listchars=eol:$` 表示将换行符显示为 `$`。那么如何查看换行符的区别呢？

> 可重新以 fileformat=unix 的形式打开文件（`:e ++ff=unix`），而 `CR` 会显示为 `^M`, `LF` 显示为 `$`。

转换 buffer 的换行符。比如：`set ff=dos`。


##### 替换换行符

`help :s` 查看用法，`:[range]s[ubstitute]/{pattern}/{string}/[flags] [count]`，注意在 pattern, string 的特殊字符是不同的。

> pattern 的换行符是 `\n`，string 的换行符是 `\r`。

for example

    # test.txt
    aa;bb;cc

    # 将分号转换为换行符
    :%s/;/\r/gc

    # 将换行符转为分号
    :%s/\n/;/gc
    
#### 编码

转换 buffer 的编码。比如：`set fileencoding=gbk, set fileencoding=utf-8`。

因为 vim 以某种编码打开文件时，如果是不认识的字符，则会转换为问号，如果用 `set fileencoding=<encoding>`，则会转换 buffer 的编码,所以只是转换问号的编码而不是转换不认识字符的编码。那么该如何解决呢？

> 以某种编码重新打开文件即可。比如：`:e ++enc=gbk`。然后再将 buffer 写入文件即可。还有，可以某种编码转换 buffer 再写入文件。比如：`w ++enc=utf-8`。一般是重新打开文件无乱码后，直接写入文件即可。

for example 
    
    # 打开一个 gbk 的文件乱码，则这样解决
    :e ++enc=gbk
    :w
    # 也可将其保存为其他编码。前提是打开文件无乱码。
    :w ++enc=utf-8

---

综上:

`set ff=<fileformat>, set fileencoding=<encoding>` 都表示转换 buffer 的内容。

`e|w ++ff|++enc=<something>` 表示以某种方式打开或写入文件。

### vim 技巧

    搜索
        搜索不区别大小写。`help \c`
            help ignorecase
                /<pattern>\c
        全词匹配。`help \\<`
            help \\<
                \<<word>\>

    搜索历史命令
        [/ | :| ?]<str> + Up/Down 会根据 <str> 自动匹配历史命令

        help command-line-window
            q??     # 向上搜索历史命令

    重新选择刚粘贴的文本
        `help `[`

        nnoremap gp `[v`]

        
    复制历史命令
        `q:, :C-f` 进入 command-line-window 即可复制

    退出命令补全并编辑
        可按 <S-<Right>/<Left>> 退出并编辑

    快速定位行
        help 'relativenumber'

    自动对齐
        help =

    help scrolling
        zz, zt, zb      # 重点
        # zz 可将最后一行移动到中间

        页之间移动
            C-B, C-F
        
        百分比移动
            <N>%
        
    打开最近文件
        oldfiles            # 查看最近打开的文件
        browse oldfiles     # 查看并打开最后打开的文件

    浏览文件系统
        # 除了 `:Next, :X`，大写开头是用户命令
        Exporle     # 用此 window 打开
        Sex         # 用新的 window 打开
        .\<C-d>

    `-- More --` 模式的导航
        可按 <Right> 查看帮助。比如：let

    输出文件路径
        help expand
        echo expand('%:p')              # full path
        echo expand('%:t')              # 最后一个 path component
        echo expand('%:e')              # 扩展名
        echo expand('%:p:h')            # `:h` 删除最后一个 path component。最终是文件所在的目录。
        echo expand('%:p:r')            # `:r` 删除扩展名。
        echo expand('%:h')
        echo expand('%:r')

    多文件或多窗口编辑文件的技巧
        m[A-Z] 记录好位置，因为 changes 只针对 buf, jumps 只针对 window，用 `C-o, g;` 则没有那么方便。
        `g;, C-o` 要多用
        如果一个文件过长，则用 m[a-z] 记录好位置。

    比较两行是否相同
        <range>sort [i] u
            如果只剩下一行则两行相同，否则不同。

    拼接文件
        :r <file>
        :w>> [file]			# `help :w_a`
