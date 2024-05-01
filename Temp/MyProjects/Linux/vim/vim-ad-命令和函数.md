# Vim 命令和函数

## 命令或函数的基础知识

查看设置的值

    set <option>?

在命令中，将 expr 的内容作为命令，并执行该命令。可用表达式拼接成命令并执行。

    exe <expr>

for example

```vim
exe "echo 'AA'"
let cmd="echo 'BB'"
exe cmd
```

执行命令并返回命令 output string

    # <cmd> can be a string or a List.
    execute(<cmd>)

for example

```vim
let outputStr = execute("set fileencodings?")
put =outputStr
```

输出寄存器或表达式的内容，还有命令的 output string 到文件

    put <reg>
    # 注意：`expr` 中的 `|` `"` 要转义。
    put =<expr>

for example

```vim
put "0
put =$VIMRUNTIME
put ='ABC'
put =\"ABC\"

# 函数也是一个 expr
put =execute(\"echo 'AA' \| echo 'BB'\")
```

过虑命令的结果

    filter /<pattern>/ <cmd>

for example

```vim
filter /v:version/ let
```

调用一个函数

    :[range]cal[l] {name}([arguments])

输出消息

    # 不包括 echo 的输出
    message
    # 输出一个正确的消息到 message
    echom
    # 输出一个错误的消息到 message
    echoe

## grep

ref: `help grep`

vim 有两种搜索方式，internal grep(vimgrep) 和 external grep(grep)。

内部 grep 的好处是能在所有系统上使用，和能使用强大的 vim search patterns。坏处是比外部 grep 慢，因为文件都要读入内存。

vimgrep, grep 会生成 quickfix list, 而 lvimgrep, lgrep 会生成 location list。

### internal grep

格式

    vim[grep][!] /{pattern}/[g][j] {file} ...
        g: 如果没有 g, 则添加每行第一次匹配（match）。如果有 g, 则每行的所有匹配。
        j: jump。表示跳到第一次匹配的位置，否则只是更新 quickfix list。
        !: With the [!] any changes in the current buffer are abandoned.
    <count>vim ...
        <count>: 匹配的最大次数。

lvimgrep 也 grepvim 是一样的格式，lvimgrep 只是添加匹配到 location list.

vimgrepadd, lvimgrepadd 也与 vimgrep 有一样的格式，不同的是 <vimgrep>add 添加 list 到 current list, 而 <vimgrep> 生成新的 list。


for example

```vim
:vimgrep /stdio\.h/ /usr/include/*.h
```

### external grep

与 linux grep 有相同的接口，即用法一样。grep 不是系统提供的，而是 vim 提供的。比如：windown gvim 的 grep 是用 findstr 查找的。

格式

    grep [arguments]
    lgrep
    grepadd, lgrepadd

for example

```vim
:grep -ir 'stdio\.h' /usr/include/*.h
```
