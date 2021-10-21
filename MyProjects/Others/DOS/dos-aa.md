# Windows CMD Shell

*世上最难的语言没有之一。。。*

### Refers

- <https://ss64.com/nt/syntax.html>
- 特殊字符

    - <https://www.robvanderwoude.com/escapechars.php>

- <https://www.cnblogs.com/mq0036/p/3509033.html>

### 基本概念

window cmd shell 已经淘汰了，但还有使用（主要是写一些功能非常简单的脚本）。所以简单了解即可，方便看懂别人的 windown cmd shell，能做一些简单的修改。

window cmd shell 与 shell 特殊字符有很大的差别。比如：单引号，转义字符等。所以要了解其特殊字符。

*因为其提供的循环语句不能制造死循环。所以从设计上来看，喜欢 goto 语句而不喜欢循环语句。所以应该是追捧 goto 时代的语言了。*

### 容易出错做法

#### batch 脚本文件的格式与 ANSI 编码

batch 脚本的编码最好是 ANSI 编码且换行符是 windows 换行符。

有意思的是，ANSI 编码不是特定的字符编码。在不同的系统中，ANSI表示不同的编码。比如：英文系统是 ASCII 编码，简体中文系统则是 cp936(GBK) 编码。[ANSI encoding](https://blog.csdn.net/imxiangzi/article/details/77370160)

[虽然 cmd 支持 Unicode，但是有点地方必须是 ANSI。](https://ss64.com/nt/chcp.html)

有意思的是，有时 cmd 的 chcp 是 936 时，batch 脚本是 utf-8 的，就算有中文也是可以成功运行的，但是有时是会出现乱码的。这应该是之前的中文的 gbk 编码与 utf-8 编码是相同时则不会出现，但是出现了 gbk 编码与 utf-8 编码不同的中文时，则会导致乱码。这点让人很困惑。

#### 语句的解析

终端上的语句 ==> 根据环境解析终端语句 ==> 运行最终语句
脚本上的语句 ==> 根据环境解析脚本语句 ==> 运行最终语句

- 终端语句的解析

    如果变量有定义则将变量替换为变量内容，否则不替换。

        set var=10
        :: 最终语句 `echo 10`
        echo %var%
        set var=
        :: 最终语句 `echo %var%`
        echo %var%

- 脚本语句的解析

    如果只有 `%` 则会省略。
    如果有 `%%` 则转义为 `%`。
    如果变量有定义则将变量替换为变量内容，否则从语句上删除变量。

        :: 最终语句为 `echo `
        echo %
        :: 最终语句为 `echo %`
        echo %%
        set var=
        :: 最终语句为 `echo `
        echo %var%

- 运行最终语句

    没有关闭 echo 时，会输出最终语句。

    在 for 的最终语句中还保留 `%v`，接下来 do 还会生成最终语句，那 do 部分是如何生成最终语句的？

            直接将 `%v` 内容替换即可。

            :: 最终语句为 `for %v in (a) do echo %%v`，do 生成的最终语句 `echo %a`
            for %%v in (a) do echo %%%%v
            :: 最终语句为 `for %v in (a) do echo ^%v`，do 生成的最终语句 `echo ^a`
            for %%v in (a) do echo ^^%%v

            for %%v in (a) do echo %%v %%
            :: 无法输出 `%v` 因为 `%v` 被直接替换了。这应该是设计上的缺陷了。
            for %%v in (a) do echo %%v %%%%v

终端上的百分号的转义问题

    set var=100
    :: 最终语句为 `echo 100`
    echo ^%var%
    :: 最终语句为 `echo 100`
    echo %%var%
    :: 最终语句为 `echo %var%`
    echo ^%var^%

DelayExpansion

    问题:

        Set "var=first"

        :: 最终语句 `Set "var=second" & Echo first`。`%var%` 不是 second 的原因是解析命令时，是先解析一条语句，然后再运行最终语句。
        Set "var=second" & Echo %var%

    SETLOCAL EnableDelayedExpansion
    Set "var=first"
    :: 最终语句是 `Set "var=second" & Echo first seconde`。`!var!` 是被延时赋值，而 `%var%` 不会。
    Set "var=second" & Echo %var% !var!
    endlocal

    `(), if, for` 都是一条语句，会一起解析生成最终语句。所以在它们中修改变量并使用变量时，要设置 `SETLOCAL EnableDelayedExpansion`。

    `setlocal EnableDelayedExpansion` 与 `setlocal` 有一样的作用，且不过是多开启了 delayedExpansion。

    `()` 内不能有 comment

        :: 此时不应有 )
        (
            command
            :: comment
        )


#### 双引号内外的环境

第一个引号的作用是打开内环境，而接下的引号是关闭内环境。依此类推。

    echo "内环境"外环境"内环境

    内环境表示在引号内，很多特殊字符是无效的。而外环境则表示不在引号内。

for example

    在双引号中输出双引号的问题
        :: 虽然可以输出双引号但是 str2 是在双引号的外环境中，如果包含特殊字符则不行了。
        echo "str1"str2"
        :: echo "str2"str2>"
        echo ^"str2^"str2^>^"

        所以 echo "%var%" 时，`%var%` 中包含引号且引号之后有特殊字符时，则会出错。这点要注意。

    有引号字符串与非引号字符串的拼接（重点）

        :: ### 引号中转义 `"`
        :: `stra"strb`
        if "stra""strb"=="stra""strb" echo true

        :: ### 两种字符串的拼接。`strastrcstrb` 而 `strc` 引号中
        if "stra"strc"strb"=="stra"strc"strb" echo true
        :: `stra%strb`
        if "stra"^%"strb"=="stra"^%"strb" echo true
        :: `stra"strb`
        if "stra"^""strb"=="stra"^""strb" echo true

#### set

显示、设置或删除 cmd.exe 环境变量。
注意这里是用环境变量。

#### unset

    set var=
    set "var="

在终端上检测变量是否定义，不能用 if 的方法，而是要使用 `set var` 的方法。

    :: ### 终端上运行
    set var=
    :: 因为终端中未定义的变量是不替换的，所以最终语句为 `if %var%"=="" echo true`。
    if "%var%"=="" echo true
    :: 输出 var 是否定义
    set var

    :: ### 脚本上运行
    set var=
    :: 最终语句为 `if ""=="" echo true`
    if "%var%"=="" echo true

#### 运行脚本

用绝对相对路径的方式运行脚本是在本程序中运行。会改变当前的程序的环境变量。
call 脚本也是在本程序中执行，只能用来调用脚本。

#### setlocal

Starts localization of environment variables in a batch file.

*在终端中使用是无效的。*

可以理解每个 setlocal, endlocal 是新建一个环境，且是继承外部环境的。定义的环境变量没有延伸到。unset, 修改外部变量无效。类似于新建子进程的环境。

    for example

        ```
        @echo off

        set var=10
        setlocal
            set var=100
            setlocal
                echo %var%
                set var=1000
            endlocal
            :: 100
            echo %var%
        endlocal
        :: 10
        echo %var%
        ```

        ```
        @echo off

        set var=10
        setlocal
            set vara=100
            set var=
        endlocal
        :: 环境变量 vara 没有定义
        set vara
        :: var=10
        set var
        ```
##### setlocal delayedexpansion 例子

建议还是开启 `setlocal EnableDelayedExpansion` 要不处理 if, for 多重嵌套且要赋值时，会很不方便。

for example

    @echo off

    setlocal EnableDelayedExpansion
    :: # 去除 `%var%` items 的双引号

        :: str1, str2 不能有空格或 tab，否则 tokens 会不符合预期。
        set "var="str1" "str2""

            if 1 equ 1 (
                for /f "tokens=1-2" %%i in ("%var%") do (
                    set "item1=%%i"
                    set "item2=%%j"
                )

                set "item1=!item1:~1,-1!"
                set "item2=!item2:~1,-1!"
                echo "parsed var: !item1!,!item2!"
            )

        echo "parsed var: %item1%,%item2%"

    endlocal

##### 管道与转义字符 `^`

向管道输出时，还会解析转义字符 `^`，而向文件输出时，不会解析转义字符

    :: 最终语句为 `echo ^> | find /v ""`，因为向管道输出，所以还会转义 `^`, 最终输出 `>`。
    echo ^^^>|find /v ""
    :: 最终语句为 `echo ^^ | find /v ""`，因为向管道输出，所以还会转义 `^`, 最终输出 `^`。
    echo ^^^^|find /v ""

    :: 最终语句为 `echo ^> >testfile & find /v "" testfile`, 最终输出 `^>`。
    echo ^^^> >testfile & find /v "" testfile
    :: 最终语句为 `echo ^> >testfile  & find /v "" testfile`, 最终输出 `^>`。
    echo ^^^^ >testfile & find /v "" testfile
    del testfile

    :: ### 向管道输出时，不会转义 `%`
    :: 最终语句为 `echo % | find /v ""`, 最终输出 `%`。
    echo %% | find /v ""


#### `goto :eof, exit /b 0, exit`

`exit 0` 退出进程。
`exit /b 0` 只退出脚本。
`goto :eof` 将控制权移交调用者，如果没有调用者，则退出进程。

调用脚本或函数时，都会移交控制权

    for example

        控制权移交过程:
            cmd.exe
            test1.bat
            test1.bat::func1
            test1.bat::func2
            test2.bat
            test2.bat::func1
            test2.bat::func2

        test2.bat::func2
            exit /b 0

        控制权移交过程:
            cmd.exe
            test1.bat
            test1.bat::func1
            test1.bat::func2

        test1.bat::func2
            goto :eof

        控制权移交过程:
            cmd.exe
            test1.bat
            test1.bat::func1

        test1.bat::func1
            :: cmd.exe 进程退出
            exit 0

### get help

`help <command>`

`<command> /?`

指令格式

> 大写字符则要直接写
>
> 小写字符则要根据相应意思来填写


### [特殊字符](https://www.robvanderwoude.com/escapechars.php)

*有很多特殊字符，在此不列举，查看链接即可。*

- [Escape Characters](https://www.robvanderwoude.com/escapechars.php)

    `^<specialChar>`
        一般情况下使用这种方式即可

    特殊的转义

        `%%`
            转义 for 语句的 `%`，还有脚本中的 `%%` 会转义为 `%` 然后在终端上运行。
        `""`
            转义双引号中的双引号。原因是 `^` 在双引号中无效
        `\<specialChar>`
            Some commands (e.g. REG and FINDSTR) use the standard escape character of \ (as used by C, Python, SQL, bash and many other languages.)
        `^^!`
            `SETLOCAL EnableDelayedExpansion` 模式下，转义 `!` 则是 `^^!`。

    for example

        :: ### `^` 在 echo 中是特殊字符
        echo ^^ ^>

        :: ### `%%` 转义百分号
        :: 脚本语句生成最终语句时，`%%` 会转义为 `%`
        :: 最终语句 `echo %`
        echo %%
        :: 最终语句 `for %v in (aa) do echo %v`
        for %%v in (aa) do echo %%v

        :: ### `""` 转义双引号
        echo ^" | find """"

        :: 最终语句 `echo % | find %`
        echo %% | find "%%"

        :: ### `\<specialChar>`
        echo \ | findstr /R \\

        :: ### `^^!`
        echo ^!
        SETLOCAL EnableDelayedExpansion
        :: `^^!` 表示转义 `!`
        :: echo ^!
        echo ^^!
        endlocal

- Delimiters

        Comma (,)
        Semicolon (;)
        Equals (=)
        Space ( )
        Tab (     )

        for example

            for %v in (aa,bb) do echo %v
            for %v in (aa;bb) do echo %v
            for %v in (aa=bb) do echo %v
            for %v in (aa bb) do echo %v
            for %v in (aa   bb) do echo %v

- Quotes（双引号）

    作用是表示一个整体。

    [以下的特殊字符在双引号中是无效的](https://datacadamia.com/lang/dos/character)

        <space>
        &()[]{}^=;!'+,`~


### 环境变量的定义与使用

    set <varname>=<content>
    :: <content> 含有特殊字符时
    set "<varname>=<content>"
    :: unset var
    set <varname>=
    set "<varname>="

for example

    echo funcForVar:

    :: 创建或修改变量
    set "var=ABC"
    echo %var%

    :: unset var
    set | find "var"
    set var=
    set | find "var"

### arguments of batch script

    $*, %0, %1 %2 %3 %4 %5 ...%255

#### [Parameter Expansion](https://ss64.com/nt/syntax-args.html)

*这里用 `%1` 举例*

    %~f1
    %~d1
    %~p1
    %~n1
    %~x1
    %~1
    %~$PATH:1
        在 PATH 变量中搜索 `%~1` 指定的路径。`%~1` 可以是文件名（不包含所在目录）也可以是全路径，但是不能是相对路径（就算 PATH 中存在相对路径）。

    常用组合
        :: 获得所在目录
        %~dp1
        :: 获得文件名（不包含目录）
        %~nx1
        :: 获得文件路径
        %~dpnx1

    for example

        test.bat

        ```
        echo f %~f1
        echo d %~d1
        echo p %~p1
        echo n %~n1
        echo x %~x1
        echo %~1
        echo dp %~dp1
        echo dp %~nx1
        echo dp %~dpnx1
        ```

        test.bat "C:\directory\filename.extend"
        test.bat ".\filename.extend"
        test.bat "filename"

        test.bat

        ```
        echo %PATH%
        echo %~1
        echo %~$PATH:1
        ```

        test.bat "System32"
        test.bat "C:\Windows\System32"
        test.bat ".\System32"
        set "PATH=%PATH%;.\System32"
        :: 还是没有结果
        test.bat ".\System32"

        test.bat "Windows"
        test.bat "\System32"

### [Extract part of a variable (substring)](https://ss64.com/nt/syntax-substring.html)

Syntax

    %variable:~num_chars_to_skip%
    %variable:~num_chars_to_skip,num_chars_to_keep%

    num_chars_to_keep 为负数时，表示减去未尾 N 个字符。`-0` 则表示为 `0`，而不是不减。

for example

    set "var=ABCDE"
    echo %var:~1%
    echo %var:~0,-1%
    echo %var:~0,1%
    echo %var:~-1,1%
    echo %var:~2,1%

    :: num_chars_to_keep 为负数时
    echo %var:~2,-2%
    echo %var:~2,-3%
    echo %var:~2,-0%

### [Edit/Replace text within a Variable](https://ss64.com/nt/syntax-replace.html)

Syntax

      %variable:StrToFind=NewStr%

      %~[param_ext]$variable:Param      # Parameter Extensions 有提及


for example

    set "var=ABCDE"
    echo %var:ABC=abc%
    :: 支持通匹配符模式
    echo %var:*C=%

    set "var=A B C D E"
    :: 去除空格
    echo %var: =%

### [Delayed Expansion](https://ss64.com/nt/delayedexpansion.html)


运行每条语句时都是先 expand 再执行 expand 之后语句。

&, (), if, for 虽然可有多个命令，但属于一条语句。

for example

    :: 在脚本中测试
    set "_var="
    Set "_var=first"
    :: 最终语句为 `Set "_var=second" & Echo first`
    Set "_var=second" & Echo %_var%
    set "_var="

    ::SETLOCAL DisableDelayedExpansion
    SETLOCAL EnableDelayedExpansion
    :: `^^!` 表示转义 `!`
    set "_var="
    Set "_var=first"
    :: 最终语句为 `Set "_var=second" & Echo first second`
    Set "_var=second" & Echo %_var% !_var!
    set "_var="
    endlocal

### Conditional Execution

if command1 succeeds then execute command2 (IF)

    command1 && command2

Execute command1 and then execute command2 (AND). 不管 command1 是否出错，command2 都会执行。

    command1 & command2

Execute command2 only if command1 fails (OR)

    command1 || command2

### Loop

#### Using brackets

括号的作用是将多个命令组合成一个整体。

Parenthesis (小括号) are most commonly used for the command action in a `FOR` loop or an `IF` conditional.

      (command)

      (
       command
       command )

#### Match filenames with Wildcards

The * wildcard will match any sequence of characters

The ? wildcard will match a single character

##### 匹配文件

`.\*` 只配文件（不是目录）。这点与 shell 不同。

for example

    :: 这里的 `.\*` 只匹配当前目录下的文件而不包括目录
    for %v in (.\*) do @(echo %v)
    :: 这里的 `.\*` 只匹配当前目录下的目录
    for /d %v in (.\*) do @(echo %v)

    :: 这里的 `.\*` 匹配子目录下的文件（还是不包括目录）
    for /r ".\" %v in (*) do @(echo %v)
    :: 这里的 `.\*` 匹配子目录下的目录
    for /d /r ".\" %v in (*) do @(echo %v)

#### Loop

- if

    总体格式

        :: 左括号与右括号分别要与 if, else 在同一行。
        :: 括号内至少有一条语句。
        if <options> (
            <commands>
        ) [else (
            <commands>
        )]

        if <options> (
            <commands>
        ) else if <options> (
            <commands>
        ) [else (
            <commands>
        )]

    <options>

        逻辑命令
            not

        字符串比较
            <string_a>==<string_b>
            "<string_a>"=="<string_b>"

        数值比较
            EQU, NEQ, LSS, LEQ, GTR, GEQ

        与文件相关的命令
            exist, /f, /d

    for example

        if not 0 equ 1 echo true
        if "str"=="str" echo true

        if 1 equ 1 (
            type nul
        ) else if 1 equ 1 (
            type nul
        ) else (
            type nul
        )

        :: 判断文件或目录是否存在
        echo. > "txtfile"
        if exist "txtfile" echo true
        del "txtfile"

        :: 判断目录是否存在
        mkdir "directory"
        if exist "directory\" echo true
        if exist "directory" echo true
        rmdir "directory"

        :: 判断文件（不是目录）是否存在
        echo. > "txtfile"
        if exist "txtfile" (if not exist "txtfile\" (echo true))
        del "txtfile"

- [for](https://ss64.com/nt/for.html)

    *`匹配文件`, `分隔符` 章节中有提及。*

    for example

        for %v in (aa bb) do @echo %v
        :: `%v` 包含双引号
        for %v in ("aa" "bb") do @echo %v

        :: ### 不会读取文件内容
        (echo aa & echo bb & echo cc) > txtfile1
        type txtfile1 > txtfile2
        for %v in (txtfile1 txtfile2) do @echo %v
        del txtfile1 txtfile2

        :: ### 列出文件
        for %v in (.\*) do @echo %v
        :: #### `/d`
        for /d %v in (.\*) do @echo %v
        :: #### `/r`
        for /r ".\" %v in (*) do @echo %v
        for /d /r ".\" %v in (*) do @echo %v

        :: ### 生成一串数字
        :: `FOR /L %%parameter IN (start,step,end) DO command `
        :: output: 0, 2, 4 ... 10
        for /l %i in (0, 2, 10) do (echo %i)

        :: ### 处理文件内容 `/f`
        :: 在单引号表示命令，会执行命令并返回结果
        :: 列出所有文件（包含目录）
        for /f %v in ('dir /s /b') do @echo %v

        for /f "delims=, tokens=1,2,3" %i in ("AA,BB,CC") do (echo %i %j %k)
        for /f "delims=, tokens=1-3" %i in ("AA,BB,CC") do (echo %i %j %k)
        :: 星号表示取剩余的字符
        for /f "delims=, tokens=1,*" %i in ("AA,BB,CC") do (echo %i %j)

        :: 括号内如果字符串没有引号时，则会读取与字符串同名的文件
        echo AA,BB,CC> txtfile
        for /f "delims=, tokens=1,2,3" %i in (txtfile) do (echo %i %j %k)
        del txtfile

### function

- `call /?`

    CALL 命令现在将卷标当作 CALL 的目标接受。语法是:

        CALL:label arguments

    一个新的批文件上下文由指定的参数所创建，控制在卷标被指定后传递到语句。你必须通过达到批脚本文件末两次来 "exit" 两次。 第一次读到文件末时，控制会回到 CALL 语句的紧后面。第二次会退出批脚本。


    `CALL:label arguments` 是在本进程中运行脚本的。

- `goto /?`

    GOTO 命令现在接受目标标签 :EOF，这个标签将控制转移到当前批脚本文件的结尾。不定义就退出批脚本文件。


- `setlocal /?`

    开始批处理文件中环境改动的本地化操作。在执行 SETLOCAL 之后所做的环境改动只限于批处理文件。用 ENDLOCAL 结束。

    for example

        call :funcForFunction aa bb
        call :funcForFunLocal

        exit /b 0

        :funcForFunction
            echo ### funcForFunction

            echo %*
            echo %0, %1, %2

            set "ret=retValue"

        goto :eof


        :funcForFuncLocal
            echo ### funcForFuncLocal

            set "var=10"
            setlocal
            set "var=100"
            endlocal

            echo %var%

        goto :eof

### [Redirection](https://ss64.com/nt/syntax-redirection.html)

`nul` 相当于 linux dev/null

for example

    :: ### 输出
    (echo aa & echo bb & echo cc) > txtfile
    (echo aa & echo bb & echo cc) 1> txtfile
    (echo aa & echo bb & echo cc) 2> txtfile
    :: 不支持
    :: (echo aa & echo bb & echo cc) &> txtfile
    (echo aa & echo bb & echo cc) > txtfile 2>&1

    (echo aa & echo bb & echo cc) >> txtfile
    (echo aa & echo bb & echo cc) 1>> txtfile
    (echo aa & echo bb & echo cc) 2>> txtfile
    (echo aa & echo bb & echo cc) >> txtfile 2>>&1

    :: ### 输入
    find /v "" <txtfile
    find /v "" 0<txtfile
    del txtfile

### 命令前缀

command echoing feature(命令回显功能)

    与 bash 不同，dos 是默认打开命令回显的。打开回显一般用于命令调试。
    echo off        :: 关闭命令回显示。但是在命令执行之后才关闭，所以这个命令会回显。
    @<command>      :: 关闭当前行命令回显。
    @echo off       :: 这样是常用的做法。

### Windows Environment Variables

`set` 查看所有环境变量
`set <eVarPrefix>` 查看部分变量。比如：set PAT

    echo %PATH%
    echo %PWD%
    echo %OLDPWD%
    ...

`set "PATH=%PATH%;..."`

### [运行脚本的方式](https://ss64.com/nt/syntax-run.html)

执行脚本和程序

    用相对路径与绝对路径执行 <program>
        新建一个子 cmd 进程来执行，父子是同步执行。

    call "{<program>/<command>}"
        用当前的 cmd 进程来执行脚本。
        相当于 source

    start "{<program>/<command>}"
        启动一个单独的窗口运行指定的程序或命令。两个窗口是异步执行的。可用 /waite 来达到同步。
        脚本开启二进制程序的常用方法。

    cmd {/K | /C} "{<program>/<command>}"
        新建一个子 cmd 进程来执行，父子是同步执行。
        cmd /C 执行完命令后，如果可以 exit，则会自动 exit。
        cmd /K 执行完命令后，不会自动 exit。所以会停留在子进程。

        for example

            :: `/s` [修改 /C 或 /K 之后的字符串处理](https://stackoverflow.com/questions/9866962/what-is-cmd-s-for)
            cmd /s /c "echo "ABC""
            cmd /s /k "echo "ABC""
            exit

### 过虑器

- [find](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/find)

    `/i` 表示不匹配大小写。

    `/v` 表示取反

    `/n` 表示搜索结果的行号

    `/c` 表示统计行数

    不支持 pattern 和 regex。

        echo aa & echo bb & echo. & echo cc
        :: 查看内容。
        (echo aa & echo bb & echo. & echo cc) | find /v /n ""
        :: 统计行数
        (echo aa & echo bb & echo. & echo cc) | find /v /c ""
        :: 不区分大小写搜索
        (echo aa & echo bb & echo. & echo cc) | find /i "Aa"
        (echo aa & echo bb & echo. & echo cc) | find "aa"
        :: ### 不支持 pattern 和 regex
        (echo aa & echo bb & echo. & echo cc) | find "*"
        (echo aa & echo bb & echo. & echo cc) | find ".*"

- [findstr](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr)

    `/I` 不区分大小写
    `/R` 启用正则表达式
    `/C:<string>` 指定搜索的文本
    `/M` 只显示文件名
    `/S` 递归搜索目录

    支持 regexp，但不支持扩展正则表达式

        echo aa bb & echo cc dd & echo. & echo ee ff
        :: 搜索含有 `aa`, `cc` 的行
        (echo aa bb & echo cc dd & echo. & echo ee ff) | findstr "aa cc"
        :: 不区分大小写搜索
        (echo aa bb & echo cc dd & echo. & echo ee ff) | findstr /I "AA CC"
        :: 搜索含有 `aa cc` 的行
        (echo aa bb & echo cc dd & echo. & echo ee ff) | findstr /C:"aa bb"
        :: 使用 regex
        (echo aa bb & echo cc dd & echo. & echo ee ff) | findstr /R /C:"^a"
        :: 查看文件
        (echo aa bb & echo cc dd & echo. & echo ee ff) | findstr /R ".*"
        :: 查看文件并显示行号
        (echo aa bb & echo cc dd & echo. & echo ee ff) | findstr /N /R ".*"

        :: 显示含有 `aa bb` 的文件的文件名
        (echo aa bb & echo cc dd & echo. & echo ee ff) > test1.log & (echo aa bb & echo cc dd & echo. & echo ee ff) > test2.log & findstr /M /C:"aa bb"  *.log
        :: 显示当前目录下含有 `aa bb` 的文件的文件名
        findstr /S /C:"aa bb" ".\*"
        del test1.log test2.log

### 常用命令

#### 操作文件

for example

    :: ### 列出文件
    dir /b
    dir /s /b
    :: 只列出目录
    dir /b /a:d /b
    :: 文件名称来排序。目录与文件分组。
    dir /b /o:gn

    :: ### 普通文件
    :: 新建一个空的文件
    type nul > testfile
    copy nul testfile

    move testfile mytestfile
    del mytestfile

    :: ### 目录
    mkdir testdir
    type nul > testdir\testfile
    move testdir mytestdir
    rmdir /s mytestdir
    :: `rmdir /s /q mytestdir` 不需要确认

    :: ### move
    type nul > testfile
    mkdir testdir
    move testfile testdir\
    :: move testfile testdir\mytestfile
    rmdir /s /q testdir


#### 网络

netstat

    netstat -aon
    netstat -r      :: 路由表

#### 进程

tasklist

    tasklist /v
    tasklist /m     :: 查看进程加载的模块

taskkill

    taskkill {/T | /F} {/PID | /IM}
        /t: terminal
        /f: 强制退出
        /im: 根据映像来 kill

for example

    tasklist
    taskkill /f /im "chrome.exe"

#### Others

    cd /d <path>

    type <file>
        查看文件内容

