# Get help with vim

## References

-   vim help
-   <https://vim.fandom.com/wiki/Learn_to_use_help>
-   [vim 中文官方文档](http://vimcdoc.sourceforge.net/doc/help.html)

## Help

vim 有多个帮助文档, 每个文档有多个 tags, 每个 tags 都有其说明。tags 包含了命令，option, 快捷键，函数, pattern 等。

帮助文档的排版

> 文件头部都有标题汇总，接下来是每个标题的详细说明。每一部分都有相应的 tag，使用户可以快速定位文档的位置。

### tag 的格式

如果 tag 包含两个词，则用 `-` 连接。比如：`help user-commands`。

命令的格式 `:<cmd>`<br>
函数的格式 `<function>()`

Key notation

    `help key-notation`
    `C-c, S-c, M/A-c 分别表示 ctrl-c, shift-c, Alt-c`
    `<Up>, <Down>, <Left>, <Right> 表示方向键`
    tab 键可能用 `<tab>, Tab`

    # ctrl 快捷方式的 tag 可能不包 `C-`, 但是会包含 `ctrl`。所以搜索时如果用 `C-` 找不到可用 `ctrl` 代替。

tag 前缀

    `help help-context` 可查看。
    包含四种模式下的命令( , v_, i_, :)，命令行编辑的快捷键(c_)，命令的参数(')，vim 程序的命令参数(-)，还有正则表达式(/)。

### 搜索 tag

    # 只列出一个匹配的 tag
    help <tag>

    # 进入 help 帮助文档后用此命令，则是用正则表达式搜索 help tags（列出所有符合的 tags），然后可以用 ts 等命令操作这些 tags。
    tag /<pattern>

    # 搜索整个 help 文档。
    # cwindow 导航搜索结果。
    helpgrep <pattern>

*tag 的进入与退出：C-], C-t*

### 命令格式的说明

-   `[]` 可选的
-   `{}` 一定要有的
-   无颜色的字符。不用更改的。
-   有颜色的字符。要用根据意思来替换合适的值得。

### 重要的文档

    # 学习 vim 应从处开始
    help help-context

    # 学习使用 help
    help help

    # 类似 help 的索引
    help quickref

    # :!vimturtor -g zh         # 可调出 vimtutor 中文文档
    help vimtutor

    # 学习 vim script
    help expression

### help 例子

for example

    help d
    help v_V
    help i_ctrl-w
    help :help

    help c_ctrl-w
    # 查看 option
    help 'number'
    help -t
    help /[
