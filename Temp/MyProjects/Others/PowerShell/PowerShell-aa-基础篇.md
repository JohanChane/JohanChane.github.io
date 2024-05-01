# PowerShell 基础篇

## References

-   <https://ss64.com/ps/syntax.html>
-   [microsoft powershell doc en](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7)
-   [microsoft powershell doc zh](https://docs.microsoft.com/zh-cn/powershell/scripting/overview?view=powershell-7)

## 基础概念

### Objects

所有东西都是对象

for example

```PowerShell
(123).GetType()
"ABC".GetType()
(echo "ABC").GetType()
```

### Cmdlet

[Cmdlet 是 .NET 类的实例](https://docs.microsoft.com/zh-cn/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7#:~:text=A%20cmdlet%20is%20a%20lightweight,them%20programmatically%20through%20PowerShell%20APIs.)

Cmdlet 的相关命令

```PowerShell
# 列出所有 cmdlet
Get-Command

# gets all types of commands, including all of the non-PowerShell files in the Path environment variable ($env:Path), which it lists in the Application command type.
get-command *
```

### Module

[A module is a package that contains PowerShell commands, such as cmdlets, providers, functions, workflows, variables, and aliases.](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7#:~:text=A%20module%20is%20a%20package,workflows%2C%20variables%2C%20and%20aliases.&text=People%20who%20receive%20modules%20can,how%20to%20use%20PowerShell%20modules.)

module 的相关命令

```PowerShell
# 列出所有 module
Get-Module -ListAvailable

# 列出指定 module 的所有 commands
Get-Command -Module Microsoft.PowerShell.Security, Microsoft.PowerShell.Utility

# source 字段有列出命令的来源
get-command | more
```

### PowerShell 与 Linux Shell 的区别

它们大体上大同小异，较大的差别有

1.  PowerShell 的管道是以 object 形式传递的，而 Linux Shell 是文本的形式。
2.  PowerShell 的 cmdlet 与一般命令不同，是 .NET(C#) 类的实例。
3.  PowerShell 的转义字符是反引号, 因为 `\` 用于文件路径中，所以不能以 `\` 作为转义字符。

### Others

#### PSDrive

除了 `C:\, D:\` 等常规 PSDrive 还有 `Env:\, Function:\, Variable:\, Alias:\` 等。`Variable:\` 表示所有变量都在这个 PSDrive 之下。`Env:\` 表示所有环境变量都在这个 PSDrive 之下。其他同理。

```PowerShell
# 列出所有 PSDrive。
Get-PSDrive
```

#### Common Information Model (CIM), Windows Management Instrumentation (WMI) 的区别

[Common Information Model (CIM), Windows Management Instrumentation (WMI) 的区别](https://blog.ipswitch.com/get-ciminstance-vs-get-wmiobject-whats-the-difference)

> CIM 是一种访问和显示计算机信息的开源行业标准，而 WMI 是 Microsoft 版本的 CIM。VMI 已过时。

for example

```PowerShell
Get-CimClass
Get-WmiObject -List
```

## Get Help

```PowerShell
Get-Help <cmdlet-name>
# 概念性主题的标题会以“About_”开头。比如：`get-help About_Classes`
Get-Help About_<topic-name>
# 在所有帮助文件中搜索某个词或短语
Get-Help <search-term>

<command> -?
```

## ScriptBlock `{}`

[ScriptBlock `{}`](https://ss64.com/ps/syntax-scriptblock.html)

*作用是表示是一个整体，可放置多个命令*

for example

```PowerShell
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
```

## 输出

for example

```PowerShell
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
```

### 输出位置的区别

write-host 与 `echo` 不同，write-host 只是将结果写到 host 上。

for example

```PowerShell
$var="$(100; "ABC"; echo EFG; write-host HIJ)"
# 可查看命令输出的位置的不同。
$var
```

## 重定向

```PowerShell
echo abc > $null
```

## 管道与 `$_`

[The `$_` is a variable created automatically by PowerShell to store the current pipeline object. All properties of the pipeline object can be accecced via this variable.](https://ss64.com/ps/syntax-pipeline.html)

`$_` 只能是 `{}` 中使用。

for example

```PowerShell
10, "abc" | %{$_.GetType()}
```

## Escape characters, Delimiters and Quotes

[Escape characters, Delimiters and Quotes](https://ss64.com/ps/syntax-esc.html)

-   escape char

    The PowerShell escape character is the grave-accent(反引号)。但正则表达式的转义字符是反斜杠。

-   Delimiters

    The standard delimiter for PowerShell is the `space` character. 比如：命令与参数或参数之间的分隔符是空格。

-   quotes

    单双引号的区别。比如：在单引号中，转义字符和 `$` 失效，而双引号中则不失效。

### 输出单双引号

for example

```PowerShell
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
```

### Concatenating Strings

for example

```PowerShell
$first = "abcde"
$second = "FGHIJ"
"$first $second"

"aaa " + "ccc" + " bbb"
```

### Here strings

for example

```PowerShell
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
```

## operator

[about operator](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7)

[operator](https://ss64.com/ps/syntax-operators.html)

### `( )` Grouping Expression operator

    括号内东西会优先运行。会被替换为输出结果。

for example

```PowerShell
(Get-Item *.txt).Count -gt 10
```

### `$( )` Subexpression operator

> Returns the result of one or more statements. For a single result, returns a scalar. For multiple results, returns an array. Use this when you want to use an expression within another expression. For example, to embed the results of command in a string expression.

for example

```PowerShell
# ### `(), $() 区别`
"Today is $(Get-Date)"
"Today is (Get-Date)"

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
```

### `@( )` Array Subexpression operator

与 `$()` 一样，区别只是其返回结果保证是一个数组。

### `::` Static member operator

用于访问类的静态成员

### `,` Comma operator

数组的 items 的分隔符。

for example

```PowerShell
$myArray = 64, "Hello", 3.5, "World"
$myArray.GetType()
# 输出 `aa, bb` 数组
echo aa, bb
write-host aa, bb
```

### `&` Call operator

创建一个子 scope 来运行。

for example

```PowerShell
$var = 10
& {$var = 100}; $var
```

### `.` Dot sourcing operator

有当前 scope 中运行。

for example

```PowerShell
$var = 10
. {$var = 100}; $var
```

### `-f` Format operator

```PowerShell
"{0:n3}" -f 123.45678
"{0,10}" -f 4,5,6
```

### `..` Range operator

for example

```PowerShell
10..20
5..25
```

### Comparison Operators

[Comparison Operators](https://ss64.com/ps/syntax-compare.html)

    -eq, -ne, ...

因为是一切都是对象所以会调用对象的比较函数。

### 常用的比较操作

    -like <通配符>
    -clike			# 区别大小写

    -match <正则表达式>
    -cmatch 		# 区别大小写

    -eq
    -ieq			# 大小写不敏感
    -ne

    -lt
    -gt
    -ge
    -le

    -in
    -notin

for example

```PowerShell
Get-Process | Where-Object {$_.Name -match 'svchost'}

'Ziggy stardust' -match 'Z[xyi]ggy'
```

## 命令组合

```PowerShell
command; commands

# ### PowerShell 不支持 `&&,||`，可用此代替
# #### `&&, ||`
echo aa; if ($?) {echo bb}
echo aa; if (! $?) {echo bb}

# #### `-and, -or` 输出逻辑运算结果
$(echo aa | Out-Host;$?) -and $(echo bb | Out-Host;$?)
$(echo aa | Out-Host;$?) -or $(echo bb | Out-Host;$?)
```

## Run a PowerShell script

[Run a PowerShell script](https://ss64.com/ps/syntax-run.html)

### 设置 PowerShell 使其能调用脚本

```PowerShell
# 查看是否能调用脚本
get-executionpolicy

# 以管理员身份运行即可。
set-executionpolicy remotesigned
```

### 调用脚本或程序的方式

```PowerShell
# call operator. 最常用。
& <file> <arg1> <arg2>

# 在本进程中运行。类似于 bash 的 source。
. <file> <arg1> <arg2>

# 在子进程中运行。
用脚本或程序相对路径或绝对路径调用

# 在子进程中运行。
powershell.exe [-File] <script_file> <arg1> <arg2>

# 在子进程中运行。
Start-Process
Start-Process [-FilePath] <file> -ArgumentList "<arg1>", "<arg2>"
```

for example

```c
# ### test.c
#include <stdio.h>

int main(int argc, char* argv[]) {
    for (int i = 0; i < argc; i++) {
        printf("%s\n", argv[i]);
    }
    system("pause");
}
```

```PowerShell
start-process a.exe -ArgumentList "aa", "bb", "cc"
```

```PowerShell
# ### test.ps1
echo $Args
pause

start-process powershell -ArgumentList ".\test.ps1 aa bb cc"
```

for example: 以管理员身份运行

```PowerShell
Start-Process -FilePath "powershell" -Verb RunAs
```

```Windows Registry Entries
# 注册表
@="powershell -windowstyle \"hidden\" -Command \"Start-Process \"D:\\PortableProgramFiles\\Alacritty\\Alacritty.exe\" -ArgumentList \"--working-directory\", \"%V\" -Verb \"runas\"\""
```

#### 调用一组命令

    & \{<commands>\}
    . \{<commands>\}
    powershell.exe [-command] \{<commands>\}

## New Object

for example

```PowerShell
$newobj = New-Object -TypeName System.Version -ArgumentList "1.2.3.4"
$newobj | Get-Member
```
