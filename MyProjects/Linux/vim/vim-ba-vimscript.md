# Vim Script

### Refer

- vim help

### 基本概念

#### buffer, window

一个 buffer 对应一个文件，保存 buffer 时，会将 buffer 的内容写入文件。

window 是一个窗口，一个 buffer 可以有多个窗口。

package 是一个文件夹，包含多个 vim 脚本。

### 使用说明

结合 vim 帮助使用，不会详细列出各种条款，只做一个大概的总结，用于入门。要看详细的条款可在 vim 帮助中查询。

vim script 有很多知识点是类似的。

从 `help expression` 看起。


### 查看信息
    
先学会查看信息再学习，这样才能有反馈。

    filter
        filter /<path>/ <cmd>       # 能过虑命令的输出

    查看所有变量
        let      有哪些                       # 列出所有变量及它们的值。值前面为 `#` 是数字类型，而 `*` 是函数引用。
        filter /<pattern>/ let                # 用过虑器查找所有变量

    查看 option 的值
        set <option>?

    查看 expr 的内容
        echo        # 查看 expr 的内容

    查看所有函数
        fun         # 列出所有函数和它们的参数
        fun <name>  # 查看函数内容
        fun /<pattern>  # 搜索函数
    
    查看所有用户命令
        com             # 列出所有用户命令
        com <cmd>       # 查看以 <cmd> 开头的命令

    查看加载了哪些脚本
        scriptnames

### 变量

`help variables`

#### 变量类型

- Number

        123, -123, -0x10, -0777, -0b111, ...

- Float

        123.455, -1.23e-2, ...

- String

        "ABC", 'ABC'

- Blob
    
        " 点只是为了方便阅读。相当于 0zFF00FF00
        0zFF00.FF00, 0zFF00FF00
        function FunctionForLoop()
            for j in 0zFF00.00FF
                echo j
            endfor
        endfunction
        call FunctionForLoop()      " 225, 0, 255, 0

- List

        [1, 2, ['a', 'b']]

        let mylist = [1, 2, ['a', 'b']]
        echo mylist[2][0]

- Dictionary
    
        # 两者等价。`#` 在前则表示键名都是字符类型。
        {'blue': "#0000ff", 'red': "#ff0000"}
        #{blue: "#0000ff", red: "#ff0000"}

        let mydict = {1: 'one', 'key': 'two'}
        echo mydict[1]
        echo mydict['key']

- FuncRef

        # function 是一个 builtin 函数，返回一个函数引用。printf 不会输出，类似于 C 的 sprintf。
        let FuncRef = function('printf', ["var=%d\n"])
        echo FuncRef(10)
        
        # funcRef 的更多用法 `help function()`


#### 引号问题
    
这是一个 shell 无法规避的问题。

- 单引号 `help expr-'`
    
    除了两个单引号代表一个引号外，其它字符都没有特殊意义。

- 双引号

    - 特殊意义 `help expr-quote`

            \
            "

    - 无特殊意义
            单绰号
            还有一些变量的特殊字符。比如：&, $, ...

*变量内容与字符串拼接*

    let var1 = 'AA BB'
    let var2 = 'stra' .. var1 .. 'strb'
    echo var2

> ***`let var = 'AA' 'BB'` 是错的，因为只能接受一个表达式，而 `let var2 = 'stra' .. var1 .. 'strb'` 能定义成功是因为 `var1` 被当作了一个整体而不是简单地替换内容再赋值。***
> 
> ***变量是内容是不包含引号的，除非用转义字符***

#### 输入单双引号与特殊字符

    echo 'stra''strb'
    echo '"'
    echo '\'

    echo "'"
    echo "\""
    echo "\\"

#### 字符串的连接
    
    用 `..` 或 `.`(已弃用)。

    'stra' .. 'strb'
    "stra" .. "strb"
    'stra' .. "strb"

#### 数字与字符串之间的转换

    echo "123" + 1
    echo "123" .. 456

#### 变量的范围

学习变量，了解其作用域与生命周期即可。属于某事物的变量一般只能在这个事物内访问且与事物的生命周期相同。

`help variable-scope`

*按名称理解即可，简单的不做解释*

- buffer 变量 `b:`
- window 变量 `w:`
- tabpage 变量 `t:`

    ??

- global 变量 `g:`

    生命周期是 vim 程序结束时。

- local 变量 `l:`
    
    在函数中定义的变量

- script 变量 `s:`

    作用域是脚本内。生命周期是脚本运行时，即 `source` 时。

- function 形参 `a:`
- vim 变量 `v:`

    这是 vim 预设的值。用户可修改部分变量，但是不可修改变量的类型。比如：`v:argv`。

***不写 scope 时， 脚本的默认范围***
    
    在脚本内，不在函数内时，是 `g:`。
    在函数内时是 `l:`。
    在命令行时是 `g:`。


### 表达式

一个变量，函数，lambda 是一个表达式，但是一个 Command 不是一个表达式。

`help expression`

一个表达式可含有多个表达式。表达式之间进行算术，逻辑运算，比较，连接等操作还是一个表达式。

    `help expression-syntax` 有详细的举例。重点留意: `help expr5, help expr9`。

    for example:
        expr1 + expr2
        expr1 && expr2
        expr1 == expr2
        expr1 .. expr2
        expr1[expr2]

        &<option>
            表示 option（set <option>） 的值。比如：echo &number
        $<environmentVar>
            表示环境变量的值。比如：echo $VIMRUNTIME
        @<register>
            表示寄存器的值。比如：echo @0

#### expr-entry, method, expr-[:]
    
    expr-entry
        另外一个方法访问 list 和 directory。
        
        expr.name 相当于 expr[name]
    method
        函数调用的别名一种方法。

        expr8->name([args])	相当于 name(expr8 [, args])
    expr-[:]
        表达式内容的剪切。shell 也有相应的功能。

#### lambda

    {args -> expr1}
            
    for example:
        let F = {arg1, arg2 -> arg1 - arg2}
        echo F(5, 2)

### Curly braces names

可用 expression 的内容组成一个新 expression。`help curly-braces-names`

    for example:
        let usera=johan
        let userb=johan
        let johanVar=10
        let kerryVar=100
        echo {usera}Var         # 相当于 echo johanVar
        echo {userb}Var         # 相当于 echo kerryVar

### 用户函数

用户可以自定义函数。`help user-functions`

函数名要大写开头，为了区分 builtin 函数，用户函数名要以大写开头。函数名还可以以 `s:`（但不能以 `l:`, `g:` 开头） 开头，表示该函数只能在脚本内使用。

`s:` 开头的函数如何实现只能在脚本内访问的？

    被 `source` 时，加载后 `s:` 被替换成了一个前缀，能访问加前缀的函数名，但是不能以 `s:` 去访问函数了。所以是为了不让用户访问。
    在脚本中也要写 `s:` 才能访问。

定义用户函数的格式 `fu[nction][!] {name}([arguments]) [range] [abort] [dict] [closure]`
    
    - range

        `:{range}call` 时，range 会被当成两个实参传给函数的形参 `a:firstline, a:lastline`。这些细节由解释器实现被隐藏起来不用程序员维护 range 也是一件好事。
        
            for example:
                :function RangeFunc() range
                    echo a:firstline .. ', ' .. a:lastline 
                :endfunction
                :4,8call RangeFunc()
    - abort

        When the `[abort]` argument is added, the function will abort as soon as an error is detected.

        不了解。

    - dict

        如果加了 dict, 则必须通过字典的 entry 来调用。

            for example:
                :function Mylen() dict
                   return len(self.data)
                :endfunction
                let mydict = {'data': [0, 1, 2, 3], 'len': function("Mylen")}
                echo mydict.len()
                echo mydict['len']()

    - closure
        
        表示函数是一个闭包。该闭包能获得外部的变量。

            for example:
                :function! Foo()
                    let x = 0

                    :function! Bar() closure
                        let x += 1
                        return x
                    :endfunction

                    return funcref('Bar')
                :endfunction

                let F = Foo()
                :echo F()   " 1
                :echo F()   " 2
                :echo F()   " 3

### User Commands

用户可自定义命令。为了区分 builtin 命令（小写开头，除了 :Next, :X），用户命令名称应以大写开头。`help user-command`

用户命令定义格式 `com[mand][!] [{attr}...] {cmd} {rep}`

    - cmd
        
        用户命令名称

    - rep
        
        用于替换命令的文本。

    - attr
        

        可为用户设置一些属性。比如：`-complete`, 表示输入命令名称后，用户要补全参数时（C-d/tab），应该提示什么。`help command-complete` 可查看所有值。
    
    - `!`
        
        与函数的定义的 `!` 类似。如果存在同名的命令，则会被覆盖。


*cmd rep 不需要（也不能）用引号引着。`有替换文本中，可用 <args> 表示参数列表。`*

    for example:
        # var 表示补全 user variables
        com! -nargs=1 -complete=var Test echo <args>
        :Test <C-d>/tab
    
### Package

`help package`

当 vim 启时，加载 .vimrc 之后，它会扫描在 `<pack>/*/start(<pack> 是 'packpath' 目录)` 目录下包含 'plugin' 的文件夹，且这些文件夹加到 'rumtimpack'。这样设计的好处 `help packload-two-steps`。

    for example:
        In the example Vim will find "pack/foo/start/foobar/plugin/foo.vim" and adds "~/.vim/pack/foo/start/foobar" to 'runtimepath'.

`set packpath?`

`set runtimepath?`

runtime

### autoload

`help autolaod`

当 `call <filename>#<funcname>()` 的格式调用时，vim 会在 'runtimepath' 路径下 'autoload' 文件夹中查找 `<filename>.vim`，然后加载（如果还没有加载）并调用它里面定义的函数 `<filename>#<function>`。`help autoload, help packload-two-steps`

    for example:
        假如有 `~/.vim/foo/autoload/filename.vim`，`call filename#function()` 则会找到 `filename.vim`。

    # filename.vim
	function filename#funcname()
	   echo "Done!"
	endfunction

	call filename#funcname()

### Startup

`help startup` 可查看 vim 启动做了哪些工作。

工作大概如下
    
    - 执行 `--cmd` 参数的命令

    - 加载 vimrc file
    
    - 加载 plugin scripts
        当 vim 启时，加载 .vimrc 之后，它会扫描在 `<pack>/*/start(<pack> 是 'packpath' 目录)` 目录下包含 'plugin' 的文件夹，且这些文件夹加到 'rumtimpack'。
        加载在 'runtimepath' 路径中包含 'plugin' 目录的插件（目录以 'after' 结尾的除外）。相当于 `runtime! plugin/**/*.vim`。

    - 执行 GUI 初始化操作

    - 读 viminfo-file

    - 打开所有窗口

    - 执行 `-c` 参数的命令。

    - 设置 `$MYVIMRC, $MYGVIMRC` 为第一个发现的 vimrc file, gvimrc files（前提是找到文件都设置变量）。

### Pattern
    
vim 使用 pattern 不是标准的正则表达式，而是 regex dialet。但与标准正则表达式相差不在，只是有些特殊字符要加转义字符。`help non-greedy` 可查看例子。

`matchstr()` 中 pattern 是不支持一些 pattern 的，比如：\(\)。       # 结论是实测而来
