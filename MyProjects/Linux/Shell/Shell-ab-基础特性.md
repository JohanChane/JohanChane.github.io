# Shell 的基础特性

## Content

${toc}

## 说明

这里只是介绍 Shell 的基础特性。比如：转义字符，`$IFS` 等。

## 基本概念

shell 命令的执行过程。[Shell Operation](https://www.gnu.org/software/bash/manual/html_node/Shell-Operation.html#Shell-Operation)

## Lists of Commands

[Lists of Commands](https://www.gnu.org/software/bash/manual/html_node/Lists.html#Lists) 是由 `;`, `&`, `&&`, `||` 隔开每个命令，且由 `;`, `&`, `<newline>` 终止。

## Quoting（引号）

### quoting rules

    \: 转义字符。\newline
    "": $, `, \ 有效
    '': 转义字符无效，不能包含'''。
    $'': ANSI-C Quoting。\a, \b ... 有特殊意义。比如：IFS=$' \t\n' && printf %q "$IFS"
    $"": 转换为本地编码

### 引号与转义

在有些 shell 中转义字符在单引号中是失效的。ksh, bash, and zsh 不失效。

单引号在双引号中是失效的。双引号在单引号中是失效的。

单引号在单引号中是有效的。双引号在双引号中是有效的。


    # ### 输出单引号
    echo '\''               # ksh, bash, and zsh only
    echo 'str'\''str'       # all shells, single quote is outside the quotes
    echo 'str''str'         # 有些脚本是这样设计的，在单引号中，两个单引号则代替一个引号。

    echo "'"                # all shells
    # ### 输出双引号
    echo "\""
    echo '"'

## 插入命令

`(), $(), (( )), $(( ))`

    # 在 subshell 中执行。
    (), $(), ``
    # 在本 shell 中执行。
    {}
    # 添加算术表示式。比如：$(( a + b ))    # 不用这样写 $(( $a + $b ))
    (( )), $(( ))

***`() 与 $()` 的区别。`$()` 有表示 substitution 而 `()` 则没有 substitution。`$()` 的输出没有重定向到标准输出，而 `()` 则是。***

for example

```shell
var=$(echo "ABC")
echo $var
var=(echo "ABC")        # 不应该有这样的写法
echo $var
```

## 重写向

ref: [重定向](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirections)

    `<, >` 等价于 `0<, 1>`
    `>file 2>&1` 等价于 `&>file`
    >>
    # 将错误信息添加到未尾。注意不是 `2>>&1`
    `>>file 2>&1` 等价于 `&>>file`

## Shell Expansions

ref: [Shell Expansions](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html#Shell-Expansions)

brace expansion: `{}`

    echo a{d,c,b}e
        ade ace abe
    echo /usr/local/src/bash/{old,new,dist,bugs}            # 逗号之后不要有空格
    echo /usr/{ucb/{ex,edit},lib/{ex?.?*,how_ex}}

tilde expansion: `~`

    # '~' 必须是前缀。
    ~: $HOME
    ~+: $PWD
    ~-: $OLDPWD

Command Substitution:

    $()
    ``

Arithmetic Expansion:

    $(( ))

Quote Removal

    # 这些字符不在引号中时，都会自动删除
    ‘\’, ‘'’, and ‘"’

    echo aa\nbb
    echo 'aa'
    echo "aa"

### Process Substitution

Process Substitution 与管道类似，但是比管道更加灵活。

    # 实际传递一个文件，而读取该文件的内容会获取 list 的输出。
    <(list)
    # 实际传递一个文件，而向该文件写入的内容补 list 作为输入。
    >(list)

for example

```sh
cat <(date)
cat < <(date)
# output: `/proc/self/fd/11`。因为 echo 不会像 cat 一样，去读取文件的内容，使用 xargs 即可。
echo <(date)
xargs echo < <(date)

# output: date: invalid date ‘/proc/self/fd/13’.
date >(cat)
date > >(cat)
```

所以有：

```sh
# 三者等价
cmd1 | cmd2
cmd2 < <(cmd1)
cmd1 > >(cmd2)

date | cat
cat < <(date)
date > >(cat)
```

实际应用:

```sh
# 管道是无法实现的
diff -u <(echo aa) <(echo bb)
while read line; do echo $line; done < <(seq 5)
```

### shell 对通配符的扩展

Filename Expansion:

    # 通配符
    ‘*’, ‘?’, and ‘[’

只要通配符能匹配到文件则将其转换所匹配的文件名。如果没有匹配的文件名则不转换。在引号中无效。

[`**`](https://stackoverflow.com/questions/28176590/what-do-double-asterisk-wildcards-mean)

> 有些 shell 支持 `**`, 表示匹配多个目录。比如：bash 则要用 `shopt -s globstar` 开启这个功能。

    # 对目录
    dir/*/subdir            # dir, subdir 之间隔着一层目录
    dir/**/subdir           # 隔着多层目录

for example

    # testsh
    #!/usr/bin/bash
    echo $@

    ./testsh *
        test.c test.o
    ./testsh test.?
        test.c test.o
    ./testsh test?
        test?

#### 匹配隐藏文件

为了防止误操作 '.' 开头的文件，除非明确地指定的 '.' 开头的文件模式，否则都不会匹配 '.' 开头的文件。

for example

    echo *
    echo .*

### Word Splitting:

$IFS 默认是空格，tab, 换行符（不包含逗号）。

If IFS is unset, or its value is exactly `<space><tab><newline>`, the default, then sequences of `<space>, <tab>, and <newline>`

for example

```shell
#!/usr/bin/env bash

# 输出 IFS
IFS=$' \t\n' && printf %q "$IFS"

# ### [$IFS 作用的地方](https://mywiki.wooledge.org/IFS)。
IFS=','

for i in "aa,bb,cc"; do
    echo $i
done

set -- aa,bb,cc
echo $@
```

### Shell Parameter Expansion

#### 变量的定义

    # 如果 $parameter 是 unset or null, 返回 word，否则返回 $parameter
    ${parameter:-word}

    # 如果 $parameter 是 unset or null, 则用 word 对 $parameter 赋值，并返回赋值后的 $parameter。否则返回 $parameter。此方法对位置参数和特殊参数无效。
    ${parameter:=word}

    # 如果 $parameter 是 unset or null, word 输出到 stderr 和 shell（not interactive）。否则，${parameter}。
    ${parameter:?word}

    # 如果 $parameter 是 unset or null, 不作任何处理, 返回 null。否则返回 word。
    ${parameter:+word}

#### 变量内容的剪切

```
`${parameter:offset}, ${parameter:offset:length}`

    截取从 offset 开始的 length 个的字符或数组单元。
    offset 为负数是从左开始数
    length 为负数是(从 offset 开始到未尾的长度 + length) 个字符或数组单元。
    offset 与 length 不能同为负数。

    ${@}, ${*} 被当成数组

`${parameter#word}, ${parameter##word}`

    从左到右匹配，如果匹配第一个到 n 个字符的字符串，则删除 1~n 个字符。
    `#, ##` 区别
        `##` 是尽量匹配长一些，而 # 是尽量匹配短一些。

`${parameter%word}, ${parameter%%word}`

    从右到左匹配，如果匹配最后一个到 n 个字符的字符串，则删除 n~$ 个字符。
    `%, %%` 区别
        `%%` 是尽量匹配长一些，而 % 是尽量匹配短一些。

`${parameter/pattern/string}, ${parameter//pattern/string}`

    将匹配到 pattern 的字符串，替换成 string。
    `/, //` 区别
        `//` 是尽量匹配长一些(全局匹配)，而 / 是尽量匹配短一些(只匹配一个)。
```

#### Others

```
# 如果 name 是数组，返回 keys。否则，如果 name 定义了且为 null, 则返回 0。
${!name[@]}
${!name[*]}

# 如果 parameter 是数组则返回，数组的元素个数。否则，返回字符的个数。
${#parameter}

# 返回前缀是 prefix 的变量。
${!prefix*}
${!prefix@}
```

## `--` 的作用

    表示参数是 `-`, 这个一般用于分隔作用，由程序内部决定，而不是 shell 决定的。比如：git, getopt, ...

## `-` 的作用

用 '-' 代替命令参数中的 filename 代表是 STDIN/STDOUT(/dev/stdin; /dev/stdout)。某些程序不支持，这个功能取决于程序，而不是 shell 决定的。

for example

    cat -;
    cat /dev/stdin

## Here Documents, Here Strings

### Here Documents

    [n]<<[-]word
        here-document
    delimiter

for example

    cat>test<<end      # 定义 end 为结束字符
        abc
        efg
        end

    xargs echo>test
        abc
        efg
        <eof>

### Here Strings

    [n]<<< word

Here Strings is A variant of here documents. 它们是有区别的，here string 一般用于输入一行字符串，而 here documents 则用于输入多行字符串，且 here string 会作更多的解析，比如：

    VAR1='value1'
    cat >testfile<<<"$VAR1"
    cat testfile

    cat >testfile<<EOF
        "$VAR1"
        EOF
    cat testfile

    gcc -xc -E -v - <<<"" 2>&1

## 环境变量，全局变量，局部变量

环境变量: 是进程环境列表。可传给其子进程。exec。
全局变量: 在函数外中定义。
局部变量: 只能在函数定义。

export 将变量加本进程的进程环境列表。

