# Shell 笔记

*读 <https://www.gnu.org/software/bash/manual/html_node/index.html> 之后的笔记，虽然这文档总结思路与网上大多数资料不相同，但是有很细的解释。*

### Refers

- <https://www.gnu.org/software/bash/manual/html_node/index.html>

## Shell Operation（运行）

*描述了 shell 命令的具体执行过程。*

1. 从文件或 `-c` 或用户终端中读取命令。

1. 根据 [quoting rules](https://www.gnu.org/software/bash/manual/html_node/Quoting.html#Quoting) 将命令拆分为多个操作或多个词，还有别名也会被转换。

1. 将上个步骤所得的东西解析为命令或组合命令。

1. 执行 [shell expansions](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html#Shell-Expansions)，将解析所得的东西为文件名或命令或参数。

1. 执行[重定向](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirections)并从命令中移除重定向操作符和它们的参数。

1. [执行命令](https://www.gnu.org/software/bash/manual/html_node/Executing-Commands.html#Executing-Commands)

1. 等待命令执行完毕并收集其[退出码](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html#Exit-Status)。*此步可选*


## Quoting（引用）

#### quoting rules

    \: 转义字符。\newline
    "": $, `, \ 有效
    '': 转义字符无效，不能包含'''。
    $'': ANSI-C Quoting。\a, \b ... 有特殊意义。比如：IFS=$' \t\n' && printf %q "$IFS"
    $"": 转换为本地编码


## Shell Commands

### Lists of Commands

list 是由 `;`, `&`, `&&`, `||` 隔开每个命令，且由 `;`, `&`, `<newline>` 终止。

### Compound Commands

    Grouping Commands
        命令的组合。可以当作是一个命令，比如：(echo A; echo B) > out。
        ( list ): 创建子 shell 执行。
        { list; }: 在当前的 shell 执行。
    Looping Constructs
        until test-commands; do consequent-commands; done
        while test-commands; do consequent-commands; done
        for name [ [in [words …] ] ; ] do commands; done
        for (( expr1 ; expr2 ; expr3 )) ; do commands ; done

    Conditional Constructs
        if test-commands; then
          consequent-commands;
        [elif more-test-commands; then
          more-consequents;]
        [else alternate-consequents;]
        fi

        case word in
            [ [(] pattern [| pattern]…) command-list ;;]…
        esac

        select name [in words …]; do commands; done

        (( expression ))

        [[ expression ]]

## Shell Parameters

### Positional Parameters
### Special Parameters

## Shell Expansions

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

    parameter and variable expansion
        ${parameter}    # 基本格式

        # 如果 parameter 为空时的处理
        ${parameter:-word}
        ${parameter:+word}
        ${parameter:=word}
        ${parameter:?word}
            当 parameter 指示的参数没有被设值的时候，将会通过标准错误的方式显示 word 中的语句。
            ${var:?var is not exist}

        ${!prefix@}, ${!prefix*}
            将前缀为 prefix 的数组的名字组合。区别与 $@, $* 的区别一样。
        ${!name[@]}, ${!name[*]}
            将 name 数组的所有下标组合。区别与 $@, $* 的区别一样。

        ${parameter:offset}, ${parameter:offset:length}
            截取从 offset 开始的 length 个的字符或数组单元。
            offset 为负数是从左开始数
            length 为负数是(从 offset 开始到未尾的长度 + length) 个字符或数组单元。
            offset 与 length 不能同为负数。

            ${@}, ${*} 被当成数组

        ${#parameter}
            parameter 字符个数或数组元素个数。${@}, ${*} 被当成数组

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

    command substitution
        在子 shell 中执行命令，并用结果替换命令。$(command) 与 ( list ) 的区别是用结果替换命令。

        $(command)
        `command`
            如果结果是多行的，则用空格将每行连接成一行。

    arithmetic expansion
        All tokens in the expression undergo parameter and variable expansion, command substitution, and quote removal.
        $(( expression ))
            $(( a + b ))    # 不用这样写 $(( $a + $b ))

    word splitting
        $IFS
        If IFS is unset, or its value is exactly <space><tab><newline>, the default, then sequences of <space>, <tab>, and <newline>

    filename expansion
        ‘*’, ‘?’, and ‘[’
        为了防止误操作 '.' 开头的文件，除非明确地指定的 '.' 开头的文件模式，否则都不会匹配 '.' 开头的文件。

        for example:
            echo *
            echo .*

## Redirections

### Redirecting Input

    [n]<word
        word: 表示从文件描述符 word 中读取数据。如果不指定则从 0 文件描述符中读取。

### Redirecting Output

    [n]>[|]word
        word: 表示文件描述符，如果不指定则写入 1 文件描述符。

### Appending Redirected Output

    [n]>>word

### Redirecting Standard Output and Standard Error

    &>word 或 >&word
        word: 代表文件名。
        两个形式都等价于 `>word 2>&1`。首选第一种。

### Appending Standard Output and Standard Error

    &>>word
        word: 代表文件名。
        等价于 `>>word 2>&1`。

### Here Documents

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

### Duplicating File Descriptors

    [n]<&word 或 [n]>&word
        word: 表示文件描述符
        使 word 与 n 指向同一地方。参考 dup2() 可理解。

### Moving File Descriptors

    [n]<&digit- 或 [n]>&digit-
        moves the file descriptor digit to file descriptor n.

### Opening File Descriptors for Reading and Writing

    [n]<>word
        word: 表示文件名
        以读写的形式打开文件，且读写的文件描述符都是 n。如果不指定 n 则 n=0。

## Command Execution Environment

shell 进程维护着 Command Execution Environment。
