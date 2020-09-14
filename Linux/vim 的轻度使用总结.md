# vim 的轻度使用总结

### refer

- vim help

### 使用说明

平时在 linux 下作开发，偶尔要用到 vim。这里就写一些 vim 的使用心得给大家入门，其实使用 vim 不算很难，了解其一般性设计即可。这里不作细致总结，重点讨论其一般性。还有一些常用命令。

适合人群：刚了解 vim 但难以记忆 vim 的使用。

结合我写的 [vim get help](https://github.com/JohanChane/JohanChane.github.io/blob/master/MyProjects/Linux/vim/vim-aa-gethelp.md) 使用。

想深入了解 vim。可看我的 [vim 笔记](https://github.com/JohanChane/JohanChane.github.io/tree/master/MyProjects/Linux/vim)。

想了解 vim 配置，可查看我个人的 [vimrc](https://github.com/JohanChane/JohanChane.github.io/blob/master/MyProjects/Linux/vim/vim-ya-%E4%B8%AA%E4%BA%BAvimrc.md)。*能打开 vim 中 url 和支持 markdown(浏览器安装 chrome 插件：Markdown Viewer)*

### motion and operator

`help cursor-motions` 有详细说明，用 `C-], C-t` 跳转到 tag 查看即可。

#### operator

    `help changing`
        c, d, y, s, S, x, X
        cc, dd      # 它们是删除行，而 S 是删除一个句子
        C, D

        # 命令也可以在命令行模式下使用。比如：`:dl`

     `help operator`
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
        w, W, e, E, b, B

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
        visual-block 是可以编辑的。应用场景，注释。`{VisualBlock}I// `

#### motion 与 operation 结合

- operation: y, c, d

        `help y`

        ["x]y{motion}       # `x` 是寄存器
        {Visual}["x]y       # {Visual} 表示 visual 模式下的选择

        *c, d 也是同理*

- v (选择)
        
        v{motion}


    for example:
        文本：world (sometext)

        # 光标在 `(sometext)` 上
        diw
        daw
        
        viw, y/c/d
        vaw, y/c/d

        # 光标在 `w` 上
        dw
        # 光标在 `b` 之后
        db
        
### 寄存器, marks, jumps, changes

#### 基本概念

一个 buffer 对应一个文件，保存 buffer 时，会将 buffer 的内容写入文件。

window 是一个窗口，一个 buffer 可以有多个窗口。

#### 寄存器

操作：`reg, "<reg>`

常用寄存器

`help registers`

- `""`

    最近复制或删除的内容

- `"0`

    最近复制的内容。*这个在粘贴复制时比较好用*

- `"1-9`

    最近删除的内容。"2: 比 `"1` 更早点删除的内容。依此推到 "9。

- `".`

    上次插入模式下输入的内容。

system clipboard of Linux: "+
system clipboard of Windows: "+ 或 "*

还有 `"<a-zA-Z>` 寄存器。*复制多处内容时，用它们比较方便。*

#### marks

`help mark-motions`

操作：```marks, m[A-Z], m[a-z], `<mark>```

- `m[A-Z]`

    也叫 file marks, 可多个文件中跳转。属于 vim 程序, 程序退出后，则丢失。

- `m[a-z]`
    
    每个 buffer 都有各自的 `m[a-z]`。

- `m0`
    
    vim 退出时会记录光标最后的位置并保存在 viminfo 中，重新打开 vim 后，按 ` `0` 可定位到上次编辑的文件的光标处。


*编辑多个文件或多窗口时，`m[A-Z] 特别有用`*

#### jumps

每个 window 都有各自的 jumps

`help jump-motions, help jumplist`

操作：`jumps, C-o, C-i`

#### changes

每个 buffer 都有各自的 changes

`help changs, help changelist`

操作：`changes, g;, g, u, C-r`

*`g;` 就很有用了*

### 命令补全

`set wildmenu`。可按 `C-<Right>/C-<Left>` 退出 wildmenu 开始编辑命令。

`<Tab>/<S-Tab>, C-d`

### 搜索历史操作

按 `:`, 输出历史命令前面字符，按 `<Up>` 即可搜索。

*同理，`/, ?` 也是如此*

### 插入模式下的快捷键

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

### 插件推荐

*windows 下使用的*


- 自动补全
    
    [vim-scripts/AutoComplPop](https://github.com/vim-scripts/AutoComplPop)
    
    *直接用了，不用配置*

- 打开文本中的 url

    [tyru/open-browser.vim](https://github.com/tyru/open-browser.vim)

    *光标放在 url 上，gx 就可打开。放在单词上，gx 就可查询*

        配置
        " #### open-browser

        " openbrowser-smart-search 会检测是否是 URI，是则打开，否则搜索该词
        " openbrowser-open 直接打开，如果不是 URI 则会报错。

        " This is my setting.
        let g:netrw_nogx = 1 " disable netrw's gx mapping.
        nmap gx <Plug>(openbrowser-smart-search)
        vmap gx <Plug>(openbrowser-smart-search)

    *如果不想用此插件，则要这样配置，也是可以打开 url 的。将光标放在 url 上按 `\w` 即可打开*
                
        " #### 用浏览器打开 URL(不需插件)
        let webBrowser = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
        "let $PATH ..= ';' . webBrowser
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
        function! Browser ()
            let line0 = getline (".")
            " matchstr 的正则表达与标准正则表达式不同。
            let line = matchstr (line0, "https*://[^ ]*")
            :if line == ""
            :endif
            :if line == ""
            let line = matchstr (line0, "ftp://[^ ]*")
            :endif
            :if line == ""
            let line = matchstr (line0, "file://[^ ]*")
            :endif
            :if line == ""
            let line = matchstr (line0, "www\.[^ ]*")
            :endif
            " 指定特殊字符, 会自动将它们前面添加 <Leader>
            " let line = escape (line, "#?&;|%")
            " :if line==""
            " let line = "\"" . (expand("%:p")) . "\""
            " :endif
        
            " 注意：`:!start` 是调用 vim 的 start, 而 `:! start` 是调用 shell 的 start。
            :if line != ""
            exec ':silent !start "' . g:webBrowser . "\" \"" . line .  "\""
            " exec ':silent ! start "title" "' . g:webBrowser . "\" \"" . line . "\""
            :endif
        endfunction

        map <Leader>w :call Browser ()<CR>

- 文件资源管理

    [scrooloose/nerdtree](https://github.com/preservim/nerdtree)

    *按 `?` 开始学习使用*

        配置
        " #### nerdtree

        " 打开/关闭 nerdtree
        map <C-n> :NERDTreeToggle<CR>       " 打开或关闭 NERDTree


- Markdown 语法

    [tpope/vim-markdown](https://github.com/tpope/vim-markdown)

- markdown preview

    chrome 插件 markdown viwer

    *按 `\f` 在浏览器打开*

        配置
        " #### 用浏览器打开此文件(为了 markdown 文件)
        " for markdown [and url]
        let webBrowser = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
        "let $PATH ..= ';' . webBrowser
        " Evoke a web browser
        function OpenFileWithBrowser ()
            let thisFile = expand('%:p')
            exec ':silent !start "' . g:webBrowser . "\" -new-window \"file:///" . thisFile .  "\""
        endfunction

        map <Leader>f :call OpenFileWithBrowser ()<CR>
