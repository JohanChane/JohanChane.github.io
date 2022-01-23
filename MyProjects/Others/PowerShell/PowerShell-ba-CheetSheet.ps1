<#
# PowerShell Cheet Sheet

### Refers

### PowerShell Cheet Sheet
#>

function funcForOutput {
    rite-host '### funcForOutput'

    write-host '#### 直接输出'
    100
    "ABC"

    write-host '##### 输出数组'
    # 数组的每个 item 为一行。
    # `"ABC", "XYZ"` 表示是一个数组
    "ABC", "XYZ"
    # 出错的。因为不是一个数组。
    # "ABC" "XYZ"

    write-host '#### var'
    $var="ABC"
    $var

    write-host '#### echo'
    # 不用加引号
    # 逗号和空格都是分隔符
    echo ABC, XYZ
    echo ABC XYZ

    write-host '#### write-host'
    # 输出空白行
    write-host ''
    # 与 echo 不同，输出 item 不换行
    write-host ABC, XYZ
    write-host ABC XYZ

    write-host '##### write-host nonewline'
    write-host ABC -nonewline
    write-host XYZ -nonewline
}

funcForOutput

function funcForQuote {
    rite-host '### funcForQuote'

    # 在单引号中，转义字符失效
    # write-host '`'
    write-host 'str1''str2'
    write-host "'"

    write-host '"'
    write-host "`""
    write-host "str1""str2"
}

funcForQuote

function funcForConcatStr {
    rite-host '### funcForConcatStr'

    $first = "abcde"
    $second = "FGHIJ"
    "$first $second"

    "aaa " + "ccc" + " bbb"
}

funcForConcatStr

function funcForVariable {
    rite-host '### functionForVariable'

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

function funcForBranch {
    rite-host '### functForBranch'

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
    rite-host '### funcForLoop'

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

function funcForFunction {
    # 要放在首行
    param ([int]$a, [int]$b)

    rite-host '### funcForFunction1'
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


function funcForFuncParam([int]$a, [int]$b) {
    rite-host '### funcForFunction2'

    write-host $a, $b
    write-host $Args
}

funcForFuncParam 1 2 3 4

function funcForPassParam([ref]$i) {
    rite-host '### funcForPassParam'

    $i = 100
}

[int]$param=10
# 这里括号不是函数的括号
funcForPassParam ([ref]$param) ([ref]$param)
write-host "`$param = $param"

function funcForInputProcFunc1($Param1) {
    rite-host '### funcForInputProcFunc1'

    # `$_` 为空的
    write-host "`$_ = $_"
}

Echo Testing1, Testing2 | funcForInputProcFunc1 Sample

function funcForInputProcFunc($Param1) {
    # 不能在此添加语句
    # write-host "test"

    Begin{ write-host "Starting"}
    Process{ write-host "processing" $_ for $Param1}
    End{write-host "Ending"}

    # 不能在此添加语句
    # write-host "test"
}

Echo Testing1, Testing2 | funcForInputProcFunc Sample

rite-host '### funcForFilter'
filter funcForFilter() {
    write-host $_
}

Echo Testing1, Testing2 | funcForFilter Sample

# ### Classes

# #### basic

rite-host '### class basic'

class Base {
}

# 在终端上输入时，类中不要出现空行，否则出现 `表达式或语句中包含意外的标记“}”。`的错误。
class MyClass : Base, System.IComparable {
    hidden [int]$i=100
    static [string]$str="ABC"
    MyClass() {
    }
    # `[void]` 可以不写
    hidden [void] method1([int]$i) {
    }
    static [void] method2([int]$i) {
    }
    [int] CompareTo([object] $obj) {
        return 0
    }
}

[MyClass]$myClass=[MyClass]::new()
write-host $myClass.i
$myClass.method1(10)


# #### attribute

write-host '### class attribute'

class MyExampleAttribute : attribute {
    # This is a property
    [String]$String

    #This is a constructor
    MyExampleAttribute([string]$String) {
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
