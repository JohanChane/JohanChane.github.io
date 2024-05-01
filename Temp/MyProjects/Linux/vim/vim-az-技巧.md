# Vim 技巧

## vim 快捷键

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

## 字符名称、合成符（digraphs）、不可见字符、编码

### [字符名称](https://en.wikipedia.org/wiki/List_of_Unicode_characters)

*可用 `help digraphs-default` 查看*

应用场景：当在网上搜索含有特殊字符的问题时，可用它们的名称搜索。

for example

| char name         | char |
| --                | --   |
| Colon             | :    |
| Comma             | ,    |
| Percent sign      | %    |


### 合成符（digraphs）

*可用 `help digraph-table` 查看*

应用场景：设置一些软件的快捷键。

for example

| char | digraph | hex  | dec | official name        |
| --   | --      | --   | --  | --                   |
| ^@   | NU      | 0x00 | 0   | NULL (NUL)           |
| ^@   | LF      | 0x0a | 10  | LINE FEED (LF)       |
| ^M   | CR      | 0x0d | 13  | CARRIAGE RETURN (CR) |

### 不可见字符

查看不可见字符: `set list`, `%!cat -A`

设置不可见字符的显示形式: `set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<`

#### 换行符

windows 的换行符为 `CRLF`（`CR` 即 `^M`）。，而 unix 的换行符为 `LF`。

`set listchars=eol:$` 表示将换行符显示为 `$`。那么如何查看换行符的区别呢？

> 可重新以 fileformat=unix 的形式打开 dos format 文件（`:e ++ff=unix`），而 `CR` 会显示为可见字体 `^M`。因为 `CR` 并不等于 `^M`，所以不要保存。以 :e ++ff=dos` 重新打开文件，再 `:e ++ff=unix` 即可将 windows 换行转为 unix 换行符。
>
> 如果已经保存则用 `:%s/r\//gc` 删除 `^M` 即可。

#### 替换换行符

`help :s` 查看用法，`:[range]s[ubstitute]/{pattern}/{string}/[flags] [count]`，注意在 pattern, string 的特殊字符是不同的。

> pattern 的换行符是 `\n`，string 的换行符是 `\r`。

for example

    # test.txt
    aa;bb;cc

    # 将分号转换为换行符
    :%s/;/\r/gc

    # 将换行符转为分号
    :%s/\n/;/gc

### 编码

转换 buffer 的编码。比如：`set fileencoding=gbk, set fileencoding=utf-8`。

因为 vim 以某种编码打开文件时，如果是不认识的字符，则会转换为问号，如果用 `set fileencoding=<encoding>`，则会转换 buffer 的编码,所以只是转换问号的编码而不是转换不认识字符的编码。那么该如何解决呢？

> 以某种编码重新打开文件即可。比如：`:e ++enc=gbk(help :e)`。然后再将 buffer 写入文件即可。还有，可以某种编码转换 buffer 再写入文件。比如：`w ++enc=utf-8`。一般是重新打开文件无乱码后，直接写入文件即可。

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
