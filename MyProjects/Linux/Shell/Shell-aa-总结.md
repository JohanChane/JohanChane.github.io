Shell 总结

### 使用

全部列出细节是不可能的，太多了，只列出个人认为重要或容易忘记的。

### References

- <https://www.gnu.org/software/bash/manual/html_node/index.html>
- <https://www.tldp.org/LDP/abs/html/special-chars.html>

    bash 的所有特殊字符

- <https://github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh>

- <https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and>
- <https://unix.stackexchange.com/questions/187651/how-to-echo-single-quote-when-using-single-quote-to-wrap-special-characters-in>

### 基本概念

shell 命令的执行过程。[Shell Operation](https://www.gnu.org/software/bash/manual/html_node/Shell-Operation.html#Shell-Operation)

[Lists of Commands](https://www.gnu.org/software/bash/manual/html_node/Lists.html#Lists) 是由 `;`, `&`, `&&`, `||` 隔开每个命令，且由 `;`, `&`, `<newline>` 终止。

[Shell Expansions](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html#Shell-Expansions)

变量是有属性的，可用 `declare -p` 查看其属性。

### 变量

`declare -p` 列出所有变量

#### 变量的作用域

declare 与 local 用法相同，它们的区别是 local 只能用于函数中。

- 全局
- 局部（只能在函数中定义）

for example:

    gVar1="ABC"
    declare gVar2="ABC"
    function funcForVarScope() {
        gVar2="DEF"
        declare lVar1="abc"
        local lVar2="def"           # 建议用此方法，因为直观
    }

#### 变量的属性

- 整数

    declare -i
    不支持浮点类型，但是可通过 bc, awk 来进行浮点运算。

- 字符

    默认
    var=100     # 相当于 var="100"

- 数组

        declare -a      # indexed arrays
        declare -A      # associative arrays

- 只读属性

    declare -r

- 引用

    declare -n

- export 属性

    declare -x

#### 数组的 expansion

    ${name[@]}, ${name[*]}
        表示 name 数组的所有内容。区别与 $@, $* 相同。
    ${!name[@]}, ${!name[*]}
        将 name 数组的所有下标组合。区别与 $@, $* 相同。
    ${!prefix@}, ${!prefix*}
        将前缀为 prefix 的数组的名字组合。区别与 $@, $* 相同。

#### Arrays

    indexed arrays
    associative arrays

    declare indexed arrays
        declare -a name
        declare -a name[subscript]      # the subscript is ignored.

    declare associative arrays
        declare -A name
        associative arrays 必须要声明才能用，否则会出问题。

    name[subscript]=value           # 创建或赋值 indexed arrays
    name=(value1 value2 … )         # 创建或赋值 indexed arrays

    name[key]=value                             # 赋值 associative arrays
    name=([keya]=value1 [keyb]=value2 … )       # 赋值 associative arrays


### 分支控制


### [`test, [ ] , [[ ]]`](https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs)

[`[ ], [[ ]] 是有区别的`](https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs)

condition 可取反的位置

    for example:
        # !(!0 && !0) && !(0) = 1
        if ! [[ ! (0 -ne 1) || ! (0 -ne 1) ]] && ! [[ 0 -eq 1 ]] ; then echo true; else echo false; fi

#### `&&, ||` 与 `-a, -o` 的区别

`-a, -o` 只能用于 test 中，当然还有 `[ ]`。

for example:

    if [ 1 -a 1 ]
    if [[ 1 -a 1 ]]          # 出错
    if [ 1 ] -a [ 1 ]       # 出错

#### 数字的比较

    greater than: lt
    equal: eq
    less than: lt
    not: n

    -eq, -ne
    -lt, -le
    -gt, -ge,

#### 字符的比较

    ==, !=
    -z, -n

#### 文件的判断

    -e, -f, -d

#### Others

    if, elif, else, fi, then
    case, esac, in

### 循环控制

    for, do, done
    while, do, done
    until, do, done
    select, do, done

### Shell Parameters

Positional 与 Special Parameters 都无法直接修改，因为不符合变量命令规则。

#### Positional Parameters

    $1, $2, ...

*$0 不是 Positional Parameters。*

    设置 Positional Parameters
        set -- <Positional Parameters>

#### Special Parameters

    $*, $@, $#:
        与 Positional Parameters 相关。
        $@ 与 $* 区别:
            $@: $1 $2 ...
            $*: $1 $2 ...
            "$@": "$1" "$2" ...
            "$*": "$1c$2c..."           # c 是 IFS 的第一个字符

            ./test.sh one two "three four"
                $1=one
                $2=two
                $3=three four

    $?: the exit status of the most recently executed foreground pipeline.
    $0: shell name or shell script name
    $$: the process ID of the shell.
    $!: the process ID of the job most recently placed into the background

*The positional parameters are temporarily replaced when a shell function is executed.*

### Function

### 列出 shell 的已知的函数

    declare -F
        只列出声明
    declare -f
        只列出声明与定义

#### 定义函数

    [ function ] <funname> [()] {
        ...
        [return [<大于 0 的整数>]]

    }

    return 只是改变 $? 的值而不改变 function substitution（$(<function>)）。function substitution 是函数的输出结果。

#### 名字空间

函数名可以有 ':', 约定 my::func 中的 my 为名字空间。shell 本身没有名字空间。

#### parameters

    Positional Parameters 同样适合于函数。
    进入函数时，$1, $2, ... 会被修改，函数结束后，它们会被还原。

#### 传参方式

Positional 与 Special Parameters 都无法直接修改，因为不符合变量命令规则。所以不用考虑传参方式。


### Quoting（引用）

#### quoting rules

    \: 转义字符。\newline
    "": $, `, \ 有效
    '': 转义字符无效，不能包含'''。
    $'': ANSI-C Quoting。\a, \b ... 有特殊意义。比如：IFS=$' \t\n' && printf %q "$IFS"
    $"": 转换为本地编码

### 字符串拼接

    str=${str1}${str2}

### 引号

在有些 shell 中转义字符在单引号中是失效的。ksh, bash, and zsh 不失效。

单引号在双引号中是失效的。双引号在单引号中是失效的。

单引号在单引号中是有效的。双引号在双引号中是有效的。


    输出单引号
        echo '\''               # ksh, bash, and zsh only
        echo 'str'\''str'       # all shells, single quote is outside the quotes
        echo 'str''str'         # 有些脚本是这样设计的，在单引号中，两个单引号则代替一个引号。

        echo "'"                # all shells
    输出双引号
        echo "\""
        echo '"'

### 输出函数

echo
printf

    printf "%s\n" "hello world!"
    IFS=$' \t\n'printf %q $IFS

### 插入命令

    (), $(), ``
        在 subshell 中执行。
    {}
        在本 shell 中执行。
    (( )), $(( ))
        添加算术表示式。比如：$(( a + b ))    # 不用这样写 $(( $a + $b ))

`() 与 $() 的区别。$() 有表示 substitution 而 () 则没有 substitution。$() 的输出没有重定向到标准输出，而 () 则反。`

    var=$(echo "ABC")
    echo $var
    var=(echo "ABC")        # 不应该有这样的写法
    echo $var

### [重定向](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirections)

    <, >, 0<, 1>
    >>
    >file 2>&1, &>file
    # 注意不是 `2>>&1`
    >>file 2>&1, &>>file

### Here Documents, Here Strings

#### Here Documents

    [n]<<[-]word
            here-document
    delimiter

    for example:
        cat>test<<end      # 定义 end 为结束字符
            abc
            efg
            end

        xargs echo>test
            abc
            efg
            <eof>

#### Here Strings


    [n]<<< word

Here Strings is A variant of here documents. 它们是有区别的，here string 一般用于输入一行字符串，而 here documents 则用于输入多行字符串，且 here string 会作更多的解析，比如：

    VAR1='value1'
    cat >testfile<<<"$VAR1"
    cat testfile

    cat >testfile<<EOF
        "$VAR1"
        EOF
    cat testfile

### Shell Expansions 中的 `{}, ~, *`

    brace expansion({})
        echo a{d,c,b}e
            ade ace abe
        echo /usr/local/src/bash/{old,new,dist,bugs}            # 逗号之后不要有空格
        echo /usr/{ucb/{ex,edit},lib/{ex?.?*,how_ex}}

    tilde expansion(~)
        '~' 必须是前缀。

        ~: $HOME
        ~+: $PWD
        ~-: $OLDPWD


#### shell 对通配符的扩展

    filename expansion
        ‘*’, ‘?’, and ‘[’

只要通配符能匹配到文件则将其转换所匹配的文件名。如果没有匹配的文件名则不转换。在引号中无效。

[`**`](https://stackoverflow.com/questions/28176590/what-do-double-asterisk-wildcards-mean)

    有些 shell 支持 `**`, 表示匹配多个目录。比如：bash 则要用 `shopt -s globstar` 开启这个功能。

    对目录：
        dir/*/subdir            # dir, subdir 之间隔着一层目录
        dir/**/subdir           # 隔着多层目录

    for example:
        # testsh
        #!/usr/bin/bash
        echo $@

        ./testsh *
            test.c test.o
        ./testsh test.?
            test.c test.o
        ./testsh test?
            test?


##### 匹配隐藏文件

为了防止误操作 '.' 开头的文件，除非明确地指定的 '.' 开头的文件模式，否则都不会匹配 '.' 开头的文件。

        for example:
            echo *
            echo .*


### 环境变量，全局变量，局部变量

    环境变量: 是进程环境列表。可传给其子进程。exec。
    全局变量: 在函数外中定义。
    局部变量: 只能在函数定义。

    export 将变量加本进程的进程环境列表。

### word splitting

    IFS=$' \t\n' && printf %q "$IFS"

    If IFS is unset, or its value is exactly <space><tab><newline>, the default, then sequences of <space>, <tab>, and <newline>

### 变量内容的剪切

    ${parameter:offset}, ${parameter:offset:length}
        截取从 offset 开始的 length 个的字符或数组单元。
        offset 为负数是从左开始数
        length 为负数是(从 offset 开始到未尾的长度 + length) 个字符或数组单元。
        offset 与 length 不能同为负数。

        ${@}, ${*} 被当成数组

    ${parameter#word}, ${parameter##word}
        从左到右匹配，如果匹配第一个到 n 个字符的字符串，则删除 1~n 个字符。
        #, ## 区别
            ## 是尽量匹配长一些，而 # 是尽量匹配短一些。
    ${parameter%word}, ${parameter%%word}
        从右到左匹配，如果匹配最后一个到 n 个字符的字符串，则删除 n~$ 个字符。
        %, %% 区别
            %% 是尽量匹配长一些，而 % 是尽量匹配短一些。
    ${parameter/pattern/string}, ${parameter//pattern/string}
        将匹配到 pattern 的字符串，替换成 string。
        /, // 区别
            // 是尽量匹配长一些(全局匹配)，而 / 是尽量匹配短一些(只匹配一个)。

### 脚本执行方式

    shell 执行 `. <shell script>` OR `source <shell script>`
        在当前的 shell 进程执行。
    `bash <shellScript>`
        新建一个 bash 子进程（subshell）来执行。
    `<shellScript> 的相对路径或绝对路径`
        新建一个 '#!' 指定的 shell 子进程（subshell）来执行。
    `<binaryProgram>` 或 `<binaryProgram 的相对路径或绝对路径>`
        新建一个 binary program 子进程（subprocess）来执行。

### 调试

    set -x; set +x
    bash -x <shell_script>

### `-` 的作用

用 '-' 代替命令参数中的 filename 代表是 STDIN/STDOUT(/dev/stdin; /dev/stdout)。某些程序不支持，这个功能取决于程序，而不是 shell 决定的。

        for example:
            cat -;
            cat /dev/stdin

### `--`

    表示参数是 `-`, 这个一般用于分隔作用，由程序内部决定，而不是 shell 决定的。比如：git, getopt, ...

### Others

    ${#parameter}
        parameter 字符个数或数组元素个数。${@}, ${*} 被当成数组

    let
