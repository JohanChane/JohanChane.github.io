# PowerShell 常用命令

## 过滤器

### select-string

Finds text in strings and files. 如果对象不是 string 类型则将其转换为 string 类型再过滤。

```PowerShell
# 列出符合正则表达式为 `get-` 的字符，且是不区分大小写的。
Get-Command | Select-String 'get-'
get-variable | Select-String '.*'
get-variable | % {$_.ToString()}

get-variable | out-string -stream | select-string '^PS'
```

### select-object

Selects objects or object properties.

根据 property 的名称来过虑

```PowerShell
Get-Process | Select-Object -Property ProcessName, Id, WS
Get-Process | Select-Object ProcessName, Id, WS
```

### where-objects

Selects objects from a collection based on their property values.

根据 property 的值来过虑

```PowerShell
Get-Service | Where-Object {$_.Status -eq "Stopped"}
Get-Service | Where-Object Status -eq "Stopped"
Get-Service | Where Status -eq "Stopped"

Get-Process | Where-Object {$_.ProcessName -Match "^p.*"}
```

## 列出条目

-   Get-PSDrive

    ```PowerShell
    get-ChildItem Env:\
    get-ChildItem Function:\
    get-ChildItem Variable:\
    get-ChildItem Alias:\
    ```

-   Get-Module -ListAvailable

    列出所有 module

    ```PowerShell
    # 列出 module 的命令
    Get-Command -Module Microsoft.PowerShell.Security, Microsoft.PowerShell.Utility
    ```

-   get-command

-   get-alias

-   get-variable

## 查看 "Item" 的信息

-   get-item

    Gets the item at the specified location.

    item 可以是目录，PSDrive，注册表

    ```PowerShell
    get-item C:\
    get-item C:\*
    Get-Item HKLM:\Software\Microsoft\Powershell\
    Get-Item HKLM:\Software\Microsoft\Powershell\*
    ```

-   get-ChildItem

    Gets the items and child items in one or more specified locations.

    ```PowerShell
    get-item C:\
    get-ChildItem C:\
    get-ChildItem .
    get-ChildItem . -File
    get-ChildItem . -Directory

    get-ChildItem . -Recurse -Name
    get-ChildItem . -Recurse | % {$_.fullname}
    ```

-   get-content

    Gets the content of the item at the specified location.

    一般用于读取文件

    ```PowerShell
    echo aa, bb, cc > testfile
    Get-Content .\testfile
    Get-Content .\testfile -Tail 2
    del testfile
    ```

-   get-member

    Gets the properties and methods of objects.

     ```PowerShell
     echo abc|Get-Member
     ```

-   查看定义

    `<object>.definition`

    ```PowerShell
    (get-command get-item).definition
    (get-item Function:\).definition
    # 变量的定义一般是空白
    (get-item Variable:\).definition
    (get-item Alias:\).definition
    ```

    `[<class>].GetMembers()|more`

    ```PowerShell
    class MyClass {
    }

    [MyClass].GetMembers()

    [MyClass].GetMembers()|%{$_.Name}
    ```

    `cat Function:\Get-Verb`

## Substring

### Substring

    # StartIndex, length 不能是负数
    .Substring( StartIndex [, length] )

for example

```PowerShell
"abcdef".substring(0,1)
"abcdef".substring(0)
```

### split

    "Lastname:FirstName:Address" -split ":"

### replace

```PowerShell
# ### `-replace <regex>, <replacement>`
"abcdef" -replace "def","xyz"
# 大小不敏感
"abcdef" -replace "dEf","xyz"

# ### `.Replace(<literalString>, <replacement>)`
'\dir\file'.Replace('\dir', '')
```

### path

-   System.io.path

    `[io.path].GetMembers()|%{$_.Name}`

    ```PowerShell
    [io.path]::GetFullPath("c:\temp\myfile.txt")
    [io.path]::GetDirectoryName("c:\temp\myfile.txt")
    [io.path]::GetFileName("c:\temp\myfile.txt")
    [io.path]::GetFileNameWithoutExtension("c:\temp\myfile.txt")
    [io.path]::GetExtension("c:\temp\myfile.txt")
    [io.path]::GetPathRoot("c:\temp\myfile.txt")
    ```

-   System.IO.DirectoryInfo, TypeName:System.IO.FileInfo

    for example

    ```PowerShell
    (Get-Item *).FullName

    (get-item *).BaseName
    (Get-Item *).Extension

    # 目录的 Parent，文件（非目录）的 DirectoryName
    (get-item *).Parent; (Get-Item *).DirectoryName
    ```

-   Split-Path

## 操作文件

[操作文件](https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-files-and-folders?view=powershell-7)

for example

```PowerShell
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
```

## Others

-   ForEach-Object

    ```PowerShell
    1,2,3 | ForEach-Object {$_}
    get-alias %
    1,2,3 | % {$_}
    ```

-   out-string

    将对象变为 string 类型

    ```PowerShell
    get-variable | % {$_.GetType()}
    get-variable | out-string | % {$_.GetType()}
    # `-stream` 表示将每个对象转换为一个 string 对象。
    get-variable | out-string -stream | % {$_.GetType()}
    ```

-   more

    ```PowerShell
    Get-Alias|more
    ```

-   out-file

    ```PowerShell
    Get-Command|Out-File testfile
    ```

-   Get-Location

    ```PowerShell
    pwd
    ```

-   Measure-Object

    ```PowerShell
    "AA BB", "CC", "DD" | Measure-Object
    "AA BB", "CC", "DD" | Measure-Object -Line
    "AA BB", "CC", "DD" | Measure-Object -Word
    "AA BB", "CC", "DD" | Measure-Object -Character
    ```

-   检测文件

    ```PowerShell
    # 文件（包括目录）是否存在
    Test-Path <path> -PathType
    # 目录是否存在
    Test-Path <path> -PathType Container
    # 文件（不包括目录）是否存在
    Test-Path <path> -PathType Leaf
    ```
