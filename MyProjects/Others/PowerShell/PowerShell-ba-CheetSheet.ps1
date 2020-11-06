<# 
# PowerShell Cheet Sheet

### Refers


### PowerShell Cheet Sheet
#>

function funcForOutput {
    rite-host '### funcForOutput'

    write-host '#### ֱ�����'
    100
    "ABC"

    write-host '##### �������'
    # �����ÿ�� item Ϊһ�С�
    # `"ABC", "XYZ"` ��ʾ��һ������
    "ABC", "XYZ"
    # ����ġ���Ϊ����һ�����顣
    # "ABC" "XYZ"

    write-host '#### var'
    $var="ABC"
    $var

    write-host '#### echo'
    # ���ü�����
    # ���źͿո��Ƿָ���
    echo ABC, XYZ
    echo ABC XYZ

    write-host '#### write-host'
    # ����հ���
    write-host ''
    # �� echo ��ͬ����� item ������
    write-host ABC, XYZ
    write-host ABC XYZ

    write-host '##### write-host nonewline'
    write-host ABC -nonewline
    write-host XYZ -nonewline
}

funcForOutput

function funcForQuote {
    rite-host '### funcForQuote'

    # �ڵ������У�ת���ַ�ʧЧ
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
    # Ҫ��������
    param ([int]$a, [int]$b)

    rite-host '### funcForFunction1'
    # ����ȫ�ֺ���
    $global:myGlobalVar=100
    
    write-host $a, $b
    # param ֮��Ĳ���
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
# return ��������
write-host "ret = $ret"
# return ���ı� `$?`
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
# �������Ų��Ǻ���������
funcForPassParam ([ref]$param) ([ref]$param)
write-host "`$param = $param"

function funcForInputProcFunc1($Param1) {
    rite-host '### funcForInputProcFunc1'

    # `$_` Ϊ�յ�
    write-host "`$_ = $_"
}

Echo Testing1, Testing2 | funcForInputProcFunc1 Sample

function funcForInputProcFunc($Param1) {
    # �����ڴ�������
    # write-host "test"

    Begin{ write-host "Starting"}
    Process{ write-host "processing" $_ for $Param1}
    End{write-host "Ending"}
    
    # �����ڴ�������
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

# ���ն�������ʱ�����в�Ҫ���ֿ��У�������� `���ʽ������а�������ı�ǡ�}����`�Ĵ���
class MyClass : Base, System.IComparable {
    hidden [int]$i=100
    static [string]$str="ABC"
    MyClass() {
    }
    # `[void]` ���Բ�д
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
