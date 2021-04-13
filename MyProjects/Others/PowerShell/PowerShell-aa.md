# PowerShell

### Refers

- <https://ss64.com/ps/syntax.html>
- <https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7>

### 基本概念

- Objects

    所有东西都是对象

    for example

        (123).GetType()
        "ABC".GetType()
        (echo "ABC").GetType()

- cmdlet

    [Cmdlet 是 .NET 类的实例](https://docs.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7#:~:text=A%20cmdlet%20is%20a%20lightweight,them%20programmatically%20through%20PowerShell%20APIs.)

    `Get-Command`

        列出所有 cmdlet

    `get-command *`

        gets all types of commands, including all of the non-PowerShell files in the Path environment variable ($env:Path), which it lists in the Application command type.

- module

    [A module is a package that contains PowerShell commands, such as cmdlets, providers, functions, workflows, variables, and aliases.](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7#:~:text=A%20module%20is%20a%20package,workflows%2C%20variables%2C%20and%20aliases.&text=People%20who%20receive%20modules%20can,how%20to%20use%20PowerShell%20modules.)
    

    `Get-Module -ListAvailable`

        列出所有 module

    `Get-Command -Module Microsoft.PowerShell.Security, Microsoft.PowerShell.Utility`

        列出指定 module 的所有 commands

    `get-command | more`
        
        source 字段有列出命令的来源

#### PowerShell 与 Linux Shell 的区别

它们大体上大同小异，较大的差别有:

> PowerShell 的管道是以 object 形式传递的，而 Linux Shell 是文本的形式。
> 
> PowerShell 的 cmdlet 与一般命令不同，是 .NET(C#) 类的实例。
> 
> PowerShell 的转义字符是 ```, 因为 `\` 用于文件路径中，所以不能以 `\` 作为转义字符。

#### Others

- PSDrive

    除了 `C:\, D:\` 等常规 PSDrive 还有 `Env:\, Function:\, Variable:\, Alias:\` 等。`Variable:\` 表示所有变量都在这个 PSDrive 之下。`Env:\` 表示所有环境变量都在这个 PSDrive 之下。其他同理。

    `Get-PSDrive` 列出所有 PSDrive。

- [Common Information Model (CIM), Windows Management Instrumentation (WMI) 的区别](https://blog.ipswitch.com/get-ciminstance-vs-get-wmiobject-whats-the-difference)

    CIM 是一种访问和显示计算机信息的开源行业标准，而 WMI 是 Microsoft 版本的 CIM。VMI 已过时。

    for example

        Get-CimClass
        Get-WmiObject -List

### Get Help

- `Get-Help <cmdlet-name>`
- `Get-Help About_<topic-name>`

        概念性主题的标题会以“About_”开头。比如：`get-help About_Classes`

- `Get-Help <search-term>`

        在所有帮助文件中搜索某个词或短语

- `<command> -?`

### Tab Key

使 `<tab>` 按键像 bash

    `Set-PSReadlineKeyHandler -Key Tab -Function Complete`

    # 生成 Profile.ps1
    `echo 'Set-PSReadlineKeyHandler -Key Tab -Function Complete' >> "$Env:USERPROFILE\Documents\WindowsPowerShell\Profile.ps1"`

### profile file

`get-help About_Profiles`

常用的 profile

| Description                | Path                                                             |
| --                         | --                                                               |
| Current User, All Hosts    | $Home\[My ]Documents\PowerShell\Profile.ps1                      |
| Current user, Current Host | $Home\[My ]Documents\PowerShell\Microsoft.PowerShell_profile.ps1 |


### 获得信息（方便学习）

- 查看对象类型

    for example

        (1).GetType()
        "abc".GetType()
        # 数组
        (1,2,3).GetType()

        $i = 100
        $str = 'abc'
        $i.GetType()
        $str.GetType()
        $i|get-member
        $str|get-member

*还有[常用命令](#CommonCommands)*

### [ScriptBlock `{}`](https://ss64.com/ps/syntax-scriptblock.html)

*作用是表示是一个整体，可放置多个命令*

for example

    # 类型是 `ScriptBlock`
    {}.GetType()

    {"Hello World"}
    & {"Hello World"}
    
    $alert = { "Hello World" }
    & $alert

    $mysb = {
        $a = 123
        Echo $a
    }
    & $mysb

    $mysb = {$b = 456 ; Echo $b }
    & $mysb

### 输出

for example
    
    function funcForOutput {
        write-host '## funcForOutput'

        write-host '### 直接输出'
        100
        "ABC"

        write-host '#### 输出数组'
        # 数组的每个 item 为一行。
        # `"ABC", "XYZ"` 表示是一个数组
        "ABC", "XYZ"
        # 出错的。因为不是一个数组。
        # "ABC" "XYZ"

        write-host '### var'
        $var="ABC"
        $var

        write-host '### echo'
        # 不用加引号
        # 逗号和空格都是分隔符
        echo ABC, XYZ
        echo ABC XYZ

        write-host '### write-host'
        # 输出空白行
        write-host ''
        # 与 echo 不同，输出 item 不换行
        write-host ABC, XYZ
        write-host ABC XYZ

        write-host '#### write-host nonewline'
        write-host ABC -nonewline
        write-host XYZ -nonewline
    }

    funcForOutput

#### 输出位置的区别

write-host 与 `echo` 不同，write-host 只是将结果写到 host 上。

for example

    $var="$(100; "ABC"; echo EFG; write-host HIJ)"
    # 可查看命令输出的位置的不同。
    $var

### 重定向

    echo abc > $null

### 管道与 `$_`

[The `$_` is a variable created automatically by PowerShell to store the current pipeline object. All properties of the pipeline object can be accecced via this variable.](https://ss64.com/ps/syntax-pipeline.html)

`$_` 只能是 `{}` 中使用。

for example

    10, "abc" | %{$_.GetType()}

### [Escape characters, Delimiters and Quotes](https://ss64.com/ps/syntax-esc.html)

- escape char

    The PowerShell escape character is the grave-accent(\`)。但正则表达式的转义字符是 (\`)。

- Delimiters

    The standard delimiter for PowerShell is the `space` character. 比如：命令与参数或参数之间的分隔符是空格。

- quotes

    单双引号的区别。比如：在单引号中，转义字符和 `$` 失效，而双引号中则不失效。

#### 输出单双引号

for example

    function funcForQuote {
        write-host 'funcForQuote:'

        # 在单引号中，转义字符失效
        # write-host '`'
        write-host 'str1''str2'
        write-host "'"

        write-host '"'
        write-host "`""
        write-host "str1""str2"
    }

    funcForQuote


#### Concatenating Strings

for example

    $first = "abcde"
    $second = "FGHIJ"
    "$first $second"

    "aaa " + "ccc" + " bbb"

#### Here strings

for example

    $myHereString = @'
    some text with "quotes" and variable names $printthis
    some more text
    '@

    $anotherHereString = @"
    The value of `$var is $var
    some more text
    "@

    echo $myHereString
    echo $anotherHereString

### [operator](https://ss64.com/ps/syntax-operators.html)

- `( ) Grouping Expression operator.`

    括号内东西会优先运行。会被替换为输出结果。
    
- `$( ) Subexpression operator.`

        While a simple ( ) grouping expression means 'execute this part first', a subexpression $( ) means 'execute this first and then treat the result like a variable'.
        Unlike simple ( ) grouping expressions, a subexpression can contain multiple ; semicolon（分号） ; separated ; statements.

    for example

        # ### `(), $() 区别`

        # #### 分号
        # 出错，因为 `()` 中不能有分号
        # (echo aa; echo bb) 
        # 可以有分号
        $(echo aa; echo bb)

        # #### 单双引号
        $var = 'abc'
        echo ($var)
        # `()` 在双引号中失效。
        echo "($var)"

        # ### 逗号
        # 输出 `(1,2,3)` 因为 `()` 和逗号在双引号中是失效的。
        "(1,2,3)"
        # 输出 `1 2 3` 因为 `$()` 在双引号中是有效的，且使得逗号不失效。
        "$(1,2,3)"

        # #### 区别
        $city="Copenhagen"
        $strLength = ($city.length)
        # 输出 `10`
        echo $strLength

        $city="Copenhagen"
        $strLength = "($city.length)"
        # 输出 `(Copenhagen.length)`。因为 `$city` 的结果不被当成一个变量，所以 `.length` 只是普通字符。也可以理解为点号没有在双双引号中失效。
        echo $strLength

        $city="Copenhagen"
        $strLength = "$($city.length)"
        # 输出 `10` 因为 `$()` 在双引号中是特殊字符
        echo $strLength

- `@( ) Array Subexpression operator.`

    与 `$()` 一样，区别只是其返回结果保证是一个数组。

- `:: Static member operator`

    用于访问类的静态成员

- `, Comma operator`

    数组的 items 的分隔符。

    for example

        $myArray = 64, "Hello", 3.5, "World"
        $myArray.GetType()
        # 输出 `aa, bb` 数组
        echo aa, bb
        write-host aa, bb

- `& Call operator`

    创建一个子 [scope](#Scopes) 来运行。

    for example

        $var = 10
        & {$var = 100}; $var

- `. Dot sourcing operator`

    有当前 scope 中运行。

    for example

        $var = 10
        . {$var = 100}; $var

- `-f Format operator`

        "{0:n3}" -f 123.45678
        "{0,10}" -f 4,5,6

- `..Range operator

    for example

        10..20
        5..25

#### [Comparison Operators](https://ss64.com/ps/syntax-compare.html)

    -eq, -ne, ...
        
因为是一切都是对象所以会调用对象的比较函数。

#### 常用的比较操作

    -like <通配符>
    -clike			# 区别大小写
    -match <正则表达式>
    -cmatch 		# 区别大小写
    -eq
    -ieq			# 大小写不敏感

for example

    Get-Process | Where-Object {$_.Name -match 'svchost'}

    'Ziggy stardust' -match 'Z[xyi]ggy'

### 命令组合

    command; commands

    # ### PowerShell 不支持 `&&,||`，可用此代替
    # #### `&&, ||`
    echo aa; if ($?) {echo bb}
    echo aa; if (! $?) {echo bb}

    # #### `-and, -or` 输出逻辑运算结果
    $(echo aa | Out-Host;$?) -and $(echo bb | Out-Host;$?)
    $(echo aa | Out-Host;$?) -or $(echo bb | Out-Host;$?)

### [run script](https://ss64.com/ps/syntax-run.html)

设置 PowerShell 使其能调用脚本

- `get-executionpolicy`

    查看是否能调用脚本

- `set-executionpolicy remotesigned`
    
    以管理员身份运行即可。

调用脚本或程序的方式

- `& <file> <arg1> <arg2>` 

- `. <file> <arg1> <arg2>`

- 用脚本或程序相对路径或绝对路径调用
    
    在子进程中运行。
    
- ```powershell.exe [-File] <script_file> <arg1> <arg2>```

    在子进程中运行。

- Start-Process

    在子进程中运行。

    `Start-Process [-FilePath] <file> -ArgumentList "<arg1>", "<arg2>"`

    for example

        # ### test.c
        #include <stdio.h>

        int main(int argc, char* argv[]) {
            for (int i = 0; i < argc; i++) {
                printf("%s\n", argv[i]);
            }
            system("pause");
        }

        start-process a.exe -ArgumentList "aa", "bb", "cc"

        # ### test.ps1
        echo $Args
        pause

        start-process powershell -ArgumentList ".\test.ps1 aa bb cc"

        # 以管理员身份运行
        Start-Process -FilePath "powershell" -Verb RunAs
        
        # 注册表
        @="powershell -windowstyle \"hidden\" -Command \"Start-Process \"D:\\PortableProgramFiles\\Alacritty\\Alacritty.exe\" -ArgumentList \"--working-directory\", \"%V\" -Verb \"runas\"\""

        
调用一组命令

    & \{<commands>\}
    . \{<commands>\}
    powershell.exe [-command] \{<commands>\}

### <a name="Scopes"></a>[Scopes](https://ss64.com/ps/syntax-scopes.html)

You can place variables, aliases, functions, or PowerShell drives in one or more scopes.

[*官方文档*](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-7)

The current scope is always the Local scope.

默认范围是当前范围。

Global, Local, Script, Private.

for example

    # ### local 与 global
    # $local:var = 100
    $var = 100

    function func() {
        # $local:var = 1000
        $var = 1000
        $var
        
        $global:var
    }

    func

    # ### Script
    # #### test1.ps1
    $script:scriptVar=1000

    # #### test.ps1
    remove-variable scriptVar
    . .\test1.ps1
    echo 'in test1.ps1'
    # 有定义
    get-variable | where Name -eq 'scriptVar'

    # #### terminal
    remove-variable scriptVar
    . .\test.ps1
    # 没有定义
    get-variable | where Name -eq 'scriptVar'
    
    # ### Private
    remove-variable privateVar
    $private:privateVar=1000
    function func() {
        echo "in func: $privateVar"
    }
    func
    $privateVar

### 变量

[Variables and Operators](https://ss64.com/ps/syntax-variables.html)

[Define PowerShell Data Types](https://ss64.com/ps/syntax-datatypes.html)

`get-Variables` 可查看所有变量。

定义或赋值变量

    $MyVariable = SomeValue
    $MyVariable = "Some String Value"
    [DataType]$MyVariable = SomeValue
    
    # `Variable:` 与 `Env:` 一样，都是 psdrive
    `New-Item Variable:\MyVariable -value SomeValue`
        Create a new variable called $MyVariable

    `New-Variable MyVariable -value SomeValue`
        Create a new variable called $MyVariable

变量类型

    int, string, int[], ...


for example

    function funcForVariable {
        write-host 'functionForVariable:'

        [int]$i = 100
        [string]$str = "ABC"
        
        [int[]]$iArray = @(1,2,3)

        $iArray[0] = 10
        write-host $iArray
        # $iArray -join ','

        $hash = @{Kevin = '1'; Alex= '9'; Margit= '12'}
        $orderedhash = [ordered]@{Kevin = '1'; Alex= '9'; Margit= '12'}

        $hash['Kevin']=10
        Write-Host ($hash | Out-String)
        $orderedhash['Kevin']=10
        Write-Host ($orderedhash | Out-String)
    }

    funcForVariable

    New-Item Variable:\MyVariable1 -value SomeValue
    New-Variable MyVariable2 -value SomeValue
    get-variables

#### Automatic Variables

[Automatic Variables](https://ss64.com/ps/syntax-automatic-variables.html)

    $_
    $$, $?, $^
    $Args
        $Args[0], ...
    $MyInvocation.MyCommand.name
        获得函数名
        
for example

    function funcForFunction {
        # 要放在首行
        param ([int]$a, [int]$b)

        write-host 'funcForFunction1:'
        write-host $a, $b
        # param 之后的参数
        write-host $Args
        write-host $Args[0]
        write-host $MyInvocation.MyCommand.name
        write-host ('$_ = ' + $_)
        write-host $$, $?, $^
    }

    funcForFunction 1 2 3 4


#### Environment Variables

[Windows environment variables are visible as a PS drive called `Env:`](https://ss64.com/ps/syntax-env.html)

    ls Env:
    ls Env:\<valueName>
        ls Env:\PATH

### [Flow Control](https://ss64.com/ps/statements.html)

Conditional Statements.

    if .. else        Conditionally perform a command
    Switch            Multiple if statements

Looping statements:

    Do .. while       Loop while a condition is True
    ForEach           Loop through each item in a collection
    For               Loop through items that match a condition
    While             Loop while a condition is True

Flow control statements:

    break             Halt execution of the current loop.
    continue          Return to top of a program loop immediately.

    return value      Return a value from a script/function
    Exit errorlevel   Return an error code from the current script.

for example

    function funcForBranch {
        write-host 'functForBranch:'

        if (0 -eq 1) {
        } elseif (0 -eq 1) {
        } else {
        }

        $fruit=""
        switch ($fruit) {
            "apple"  {
                write-host "We found an apple"
                break
            }
            "pear"   {
                "We found a pear"
                break
            }
            "orange" {
                write-host "We found an orange"
                break
            }
            "peach"  {
                write-host "We found a peach"
                break
            }
            "banana" {
                write-host "We found a banana"
                break
            }
            default {
                write-host "Something else happened"
                break
            }
        }
    }

    funcForBranch

    function funcForLoop {
        write-host 'funcForLoop:'

        do {
        } while (0 -eq 1)

        foreach ($num in 1,2,3,4,5) {
            if ($num -eq 2) {
                continue
            }
            write-host "$num`t" -nonewline
        }
        write-host ''

        for($i=1; $i -le 10; $i++){
            Write-Host "$i`t" -nonewline
        }
        write-host ''

        while($val -ne 10) {
            $val++
            Write-Host "$value`t" -nonewline
        }
        write-host ''
    }

    funcForLoop

### Functions and Filters

#### 定义格式

    function [scope_type:]name
    { 
        [ param(param_list) ]
        script_block
    }
    filter [scope_type:]name
    {
        [ param(param_list) ]
        script_block 
    }

#### 传参方式

for example

    function funcForFuncParam([int]$a, [int]$b) {
        write-host 'funcForFunction2:'

        write-host $a, $b
        write-host $Args
    }

    funcForFuncParam 1 2 3 4

#### return

return 会输出结果。不会改变 `$?`。

for example

    
    function func() {
        return 'abc'
    }

    $ret = func
    $ret
    func
    # True
    $?

    # ### `$?`
    function func() {
         Write-Error 'bad'
         # False
         $?
    }

    func
    # True
    $?

#### functions

for example

    function funcForFunction {
        # 要放在首行
        param ([int]$a, [int]$b)

        write-host 'funcForFunction1:'
        # 定义全局函数
        $global:myGlobalVar=100
        
        write-host $a, $b
        # param 之后的参数
        write-host $Args
        write-host $Args[0]
        write-host $MyInvocation.MyCommand.name
        write-host ('$_ = ' + $_)
        write-host $$, $?, $^

        "test ret"
        echo "test ret"
        return 1
    }

    funcForFunction 1 2 3 4
    $ret="$(funcForFunction)"
    # return 会输出结果
    write-host "ret = $ret"
    # return 不改变 `$?`
    write-host "`$? = $?"

    # 查看函数定义
    cat function:Add-Numbers
    ${function:Add-Numbers}
    (get-command Add-Numbers).definition


#### Filters

> With a filter function, data is processes while it is being received, without waiting for all input. A filter receives each object from the pipeline through the $_ automatic variable, and the script block is processed for each object.

for example

    filter myfilter {
        echo $_
    }
    echo AA, BB | myfilter

    function myfunc {
        echo $_
    }

    # 没有输入结果。因为结果没有传给 myfunc
    echo AA, BB | myfunc


#### Function Input Processing Methods (Begin..Process..End)

定义能从管道中获取数据的函数。

begin, process, end 分别定义管道输入前，中，后的操作

for example

    Function Test-Demo {
        Param ($Param1)
        Begin{ write-host "Starting"}
        Process{ write-host "processing" $_ for $Param1}
        End{write-host "Ending"}
    }

    Echo Testing1, Testing2 | Test-Demo Sample

### new Object

for example

    $newobj = New-Object -TypeName System.Version -ArgumentList "1.2.3.4"
    $newobj | Get-Member

### Namespaces

格式

    <namespace>.<namespace>.<class>

[Microsoft.PowerShell Namespace](https://docs.microsoft.com/en-us/dotnet/api/microsoft.powershell?view=powershellsdk-7.0.0)

[System.IO Namespace](https://docs.microsoft.com/en-us/dotnet/api/system.io?view=dotnet-plat-ext-3.1)

### Classes

[`About_Classes`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7)

- `[<className>]`

    方括号是必须要写的，表示是 PowerShell 的类型。
    
    for example

        [int]$i = 100
        function func([int]$i) { }

        [<className>]::<staticMember>

- 定义类的语法

        class <class-name> [: [<base-class>][,<interface-list]] {
        [[<attribute>] [hidden] [static] <property-definition> ...]
        [<class-name>([<constructor-argument-list>])
          {<constructor-statement-list>} ...]
        [[<attribute>] [hidden] [static] <method-definition> ...]
        }

    `<attribute>`

        `<attribute>` 则是类似 [java Annotation（注解）](https://www.runoob.com/w3cnote/java-annotation.html)，是 [`C#` 的 attribute](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/)

        [`<attribute> 教程`](https://www.nickjames.ca/custom-powershell-attributes/)

    `<property-definition>`

        [int]$property1=10
        [int] $property1=10

    `<method-definition>`
        
        for example
            
            # `[void]` 可以省略
            [void] method() { }
            
            [int] method([int]$i) { }

    `hidden, static`

        hidden 的 property or method 还是可被访问，只是 Get-Member 不显示它，还有在类的定义域外，tab 不会补它。
        static 表示属于类的而不是对象的。与一般语言的 static 一样。

- 生成类对象

        `[<class-name>]::new()` 生成并返回对象，然后用调用对象调用类的东西。比如：[Rack]$r1 = [Rack]::new(); $r1.method()

- 类继承与实现的语法

        # 花括号表示类的定义
        Class Derived : Base {...}
        Class Derived : Base, Interface {...}

for example

    class Base {
    }

    # 在终端上输入时，类中不要出现空行，否则出现 `表达式或语句中包含意外的标记“}”。`的错误。
    class MyClass : Base, System.IComparable {
        hidden [int]$i=100
        static [string]$str="ABC"
        MyClass() {
        }
        hidden [void] method1([int]$i) {
        }
        static [void] method2([int]$i) {
        }
        [int] CompareTo([object] $obj) {
            return 0
        }
    }

    [MyClass]$myClass=[MyClass]::new()
    $myClass.i
    $myClass.method1(10)


for example: attribute

    # 在脚本中运行
    class MyExampleAttribute : attribute {
        # This is a property
        [String]$String

        #This is a constructor
        MyExampleAttribute ([string]$String) {
            $this.String = $String
        }
    }

    function Get-Foo {
        [MyExample('Hello World')]
        param()

        return 'Foo'
    }

    $Funct = Get-Command Get-Foo
    $Funct.ScriptBlock.Attributes | Where-Object { $_.TypeID.Name -eq 'MyExampleAttribute' }

## <a name="CommonCommands"></a>常用命令

### 过滤器

- select-string

    Finds text in strings and files. 如果对象不是 string 类型则将其转换为 string 类型再过滤。

        # 列出符合正则表达式为 `get-` 的字符，且是不区分大小写的。
        Get-Command | Select-String 'get-'
        get-variable | Select-String '.*'
        get-variable | % {$_.ToString()}

        get-variable | out-string -stream | select-string '^PS'

- select-object

    Selects objects or object properties.

    *根据 property 的名称来过虑*

        Get-Process | Select-Object -Property ProcessName, Id, WS
        Get-Process | Select-Object ProcessName, Id, WS

- where-objects

    Selects objects from a collection based on their property values.

    *根据 property 的值来过虑*

        Get-Service | Where-Object {$_.Status -eq "Stopped"}
        Get-Service | Where-Object Status -eq "Stopped"
        Get-Service | Where Status -eq "Stopped"

        Get-Process | Where-Object {$_.ProcessName -Match "^p.*"}

### 列出条目

- Get-PSDrive
    
    get-ChildItem Env:\
    get-ChildItem Function:\
    get-ChildItem Variable:\
    get-ChildItem Alias:\

- `Get-Module -ListAvailable`

        列出所有 module

    `Get-Command -Module Microsoft.PowerShell.Security, Microsoft.PowerShell.Utility`

        列出 module 的命令

- get-command

- get-alias

- get-variable

### 查看 "Item" 的信息

- get-item

    Gets the item at the specified location.

    item 可以是目录，PSDrive，注册表

        get-item C:\
        get-item C:\*
        Get-Item HKLM:\Software\Microsoft\Powershell\
        Get-Item HKLM:\Software\Microsoft\Powershell\*

- get-ChildItem

    Gets the items and child items in one or more specified locations.

        get-item C:\
        get-ChildItem C:\
        get-ChildItem .
        get-ChildItem . -File
        get-ChildItem . -Directory

        get-ChildItem . -Recurse -Name
        get-ChildItem . -Recurse | % {$_.fullname}


- get-content

    Gets the content of the item at the specified location.

    *一般用于读取文件*

        echo aa, bb, cc > testfile
        Get-Content .\testfile
        Get-Content .\testfile -Tail 2
        del testfile

- get-member

    Gets the properties and methods of objects.

         echo abc|Get-Member

- 查看定义

    `<object>.definition`

        (get-command get-item).definition
        (get-item Function:\).definition
        # 变量的定义一般是空白
        (get-item Variable:\).definition
        (get-item Alias:\).definition

    `[<class>].GetMembers()|more`

        class MyClass {
        }

        [MyClass].GetMembers()

        [MyClass].GetMembers()|%{$_.Name}


    `cat Function:\Get-Verb`

### Substring

#### Substring

`.Substring( StartIndex [, length] )`

    StartIndex, length 不能是负数
    
for example

    "abcdef".substring(0,1)
    "abcdef".substring(0)

#### split

    "Lastname:FirstName:Address" -split ":"

#### replace

    # ### `-replace <regex>, <replacement>`
    "abcdef" -replace "def","xyz"
    # 大小不敏感
    "abcdef" -replace "dEf","xyz"

    # ### `.Replace(<literalString>, <replacement>)`
    '\dir\file'.Replace('\dir', '')

#### path

- System.io.path

    `[io.path].GetMembers()|%{$_.Name}`

        [io.path]::GetFullPath("c:\temp\myfile.txt")
        [io.path]::GetDirectoryName("c:\temp\myfile.txt")
        [io.path]::GetFileName("c:\temp\myfile.txt")
        [io.path]::GetFileNameWithoutExtension("c:\temp\myfile.txt")
        [io.path]::GetExtension("c:\temp\myfile.txt")
        [io.path]::GetPathRoot("c:\temp\myfile.txt")
        
- System.IO.DirectoryInfo, TypeName:System.IO.FileInfo

    for example

        (Get-Item *).FullName

        (get-item *).BaseName
        (Get-Item *).Extension

        # 目录的 Parent，文件（非目录）的 DirectoryName
        (get-item *).Parent; (Get-Item *).DirectoryName

- Split-Path

### [操作文件](https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-files-and-folders?view=powershell-7)

for example

    # ### 普通文件
    new-item testfile
    # out-file testfile
    echo aa,bb > testfile
    move-item testfile mytestfile
    remove-item mytestfile

    # ### 目录
    new-item testdir -itemtype directory
    echo aa,bb > testdir\testfile
    move-item testdir mytestdir
    Remove-Item .\mytestdir\ -Force -Recurse

### Others

- ForEach-Object

        1,2,3 | ForEach-Object {$_}
        get-alias %
        1,2,3 | % {$_}

- out-string

    将对象变为 string 类型

        get-variable | % {$_.GetType()}
        get-variable | out-string | % {$_.GetType()}
        # `-stream` 表示将每个对象转换为一个 string 对象。
        get-variable | out-string -stream | % {$_.GetType()}

- more

        Get-Alias|more

- out-file

        Get-Command|Out-File testfile

- Get-Location 

        pwd
        
- Measure-Object

        "AA BB", "CC", "DD" | Measure-Object
        "AA BB", "CC", "DD" | Measure-Object -Line
        "AA BB", "CC", "DD" | Measure-Object -Word
        "AA BB", "CC", "DD" | Measure-Object -Character

- 检测文件

        # 文件（包括目录）是否存在
        Test-Path <path> -PathType
        # 目录是否存在
        Test-Path <path> -PathType Container
        # 文件（不包括目录）是否存在
        Test-Path <path> -PathType Leaf

## 例子

