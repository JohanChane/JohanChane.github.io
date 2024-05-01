# PowerShell 语法篇

## Scopes

[Scopes](https://ss64.com/ps/syntax-scopes.html)

> You can place variables, aliases, functions, or PowerShell drives in one or more scopes.

[about scope](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes?view=powershell-7)

> The current scope is always the Local scope.

默认范围是当前范围。

Global, Local, Script, Private.

for example

```PowerShell
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
```

## 变量

[Variables and Operators](https://ss64.com/ps/syntax-variables.html)

[Define PowerShell Data Types](https://ss64.com/ps/syntax-datatypes.html)

`get-Variables` 可查看所有变量。

定义或赋值变量

```PowerShell
$MyVariable = SomeValue
$MyVariable = "Some String Value"
[DataType]$MyVariable = SomeValue

# `Variable:` 与 `Env:` 一样，都是 psdrive
# Create a new variable called $MyVariable
New-Item Variable:\MyVariable -value SomeValue

# Create a new variable called $MyVariable
New-Variable MyVariable -value SomeValue
```

变量类型

    int, string, int[], ...

for example

```PowerShell
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
```

### Automatic Variables

[Automatic Variables](https://ss64.com/ps/syntax-automatic-variables.html)

    $_
    $$, $?, $^
    # $Args[0], ...
    $Args
    # 获得函数名
    $MyInvocation.MyCommand.name

for example

```PowerShell
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
```

### Environment Variables

[Windows environment variables are visible as a PS drive called `Env:`](https://ss64.com/ps/syntax-env.html)

    ls Env:
    ls Env:\<valueName>
        ls Env:\PATH

## Flow Control

[Flow Control](https://ss64.com/ps/statements.html)

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

```PowerShell
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
```

## Functions and Filters

### 定义格式

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

### 传参

for example

```PowerShell
function funcForFuncParam([int]$a, [int]$b) {
    write-host 'funcForFunction2:'

    write-host $a, $b
    write-host $Args
}

funcForFuncParam 1 2 3 4
```

### return

return 会输出结果。不会改变 `$?`。

for example

```PowerShell
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
```

### Functions

for example

```PowerShell
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
```

### Filters

> With a filter function, data is processes while it is being received, without waiting for all input. A filter receives each object from the pipeline through the $_ automatic variable, and the script block is processed for each object.

for example

```PowerShell
filter myfilter {
    echo $_
}
echo AA, BB | myfilter

function myfunc {
    echo $_
}

# 没有输入结果。因为结果没有传给 myfunc
echo AA, BB | myfunc
```

### Function Input Processing Methods (Begin..Process..End)

定义能从管道中获取数据的函数。

begin, process, end 分别定义管道输入前，中，后的操作

for example

```PowerShell
Function Test-Demo {
    Param ($Param1)
    Begin{ write-host "Starting"}
    Process{ write-host "processing" $_ for $Param1}
    End{write-host "Ending"}
}

Echo Testing1, Testing2 | Test-Demo Sample
```

## Namespaces

格式

    <namespace>.<namespace>.<class>

[Microsoft.PowerShell Namespace](https://docs.microsoft.com/en-us/dotnet/api/microsoft.powershell?view=powershellsdk-7.0.0)

[System.IO Namespace](https://docs.microsoft.com/en-us/dotnet/api/system.io?view=dotnet-plat-ext-3.1)

## Classes

[`About_Classes`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7)

### 类的使用

    # 方括号是必须要写的，表示是 PowerShell 的类型。
    [<className>]

for example

```PowerShell
[int]$i = 100
function func([int]$i) { }

[<className>]::<staticMember>
```

### 定义类的语法

    class <class-name> [: [<base-class>][,<interface-list]] {
    [[<attribute>] [hidden] [static] <property-definition> ...]
    [<class-name>([<constructor-argument-list>])
      {<constructor-statement-list>} ...]
    [[<attribute>] [hidden] [static] <method-definition> ...]
    }

`<attribute>`

> `<attribute>` 则是类似 [java Annotation（注解）](https://www.runoob.com/w3cnote/java-annotation.html)，是 [`C#` 的 attribute](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/)
>
> [`<attribute> 教程`](https://www.nickjames.ca/custom-powershell-attributes/)

`<property-definition>`

    [int]$property1=10
    [int] $property1=10

`<method-definition>`

for example

    # `[void]` 可以省略
    [void] method() { }

    [int] method([int]$i) { }

`hidden, static`

> hidden 的 property or method 还是可被访问，只是 Get-Member 不显示它，还有在类的定义域外，tab 不会补它。<br>
> static 表示属于类的而不是对象的。与一般语言的 static 一样。

for example: attribute

```PowerShell
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
```

### 类继承与实现的语法

    # 花括号表示类的定义
    Class Derived : Base {...}
    Class Derived : Base, Interface {...}

for example

```PowerShell
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
```
