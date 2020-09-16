# Vim Verbose and Debug

### Refers

- vim help

### verbosenum and verbosefile

`help 'verbose'`

    可查看 verbosenum 代表的意思。常用的 verbosenum 有 9，12，16。
    set verbose

    for example:
        set verbose=9，之后操作 vim 就会知道运行了哪个 autocmd。
        set verbose=0，关闭 verbose。

`help 'verbosefile'`

    如果设置不为空，则所有消息都会输出到该文件。
    set verbosefile

    for example:
        set verbosefile=vim.log
        set verbose=9
        之后操作 vim 则不会调出 verbose 消息，而是输出到了 verbosefile。

`help -V`
    
    -V[N]<filename> 表示设置 verbose=N, verbosefile=<filename>

    for example:
        `vim -V[12]`
            如果想保存结果则设置 verbosefile。

### debug mode

`help debug-mode`

    vim -D
        # vim 不是 vim ex command, 所以要有 shell 中执行。
        可用调试 vim 的启动过程。其实是在 vim 启动前设置了一个 breakpoint。

        help startup-options
            查看 vim 程序的参数

        for example:
            vim -D
            vim -D <filename>

    :debug <cmd>
        调试单个 <cmd>

        for example:
            debug echo 'AA' | echo 'BB'

### debug commands
    
`help \><DebugCmd>`

*进入 debug mode 之后才能使用这些命令。*

debug commans:

    `next, step, cont, finish, bt/backtrace/where, (frame, up, down), quit, interrupt`

### breakpoint
    
- defining breakpoints
    
    help breakadd

    可根据相对于文件，函数，光标设置断点。

- deleting breakpoints

    help breakdel

    *`breakdel \*` 是删除所有 breakpoint*

- listing breakpoints

    help breaklist

### 进入调试模式

- 设置 breakpoint, 然后 source

- `:debug <cmd>`

- `vim -D`

### Examples

调用时，如果 vim 画面重叠，用 `C-l` 刷新屏幕。

### Debug Scripts

program: test.Vim

    let myint = 100
    let mystr = 'ABC'

    function Add(para1, para2)
        return a:para1 + a:para2
    endfunction
    
    function Func()
        call Add(1, 2)
    endfunction
    
    echo Func()

commands:

    breakadd file test.vim
    breakadd func 1 Func
    breakadd here       # 光标在要断点的行上
    breaklist
    source test.vim
    s, bt, frame, up, down
    echo myint
    quit
