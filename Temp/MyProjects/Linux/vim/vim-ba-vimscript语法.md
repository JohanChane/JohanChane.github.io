# Vim Script

## References

-   `help expression`

## 说明

这里主要记录 Vim Script 语法

## 变量

`help variables`

### 变量类型

#### Number

    123, -123, -0x10, -0777, -0b111, ...

#### Float

    123.455, -1.23e-2, ...

#### String

    "ABC", 'ABC'

#### Blob

```vim
" 点只是为了方便阅读。相当于 0zFF00FF00
0zFF00.FF00, 0zFF00FF00
" 输出 `225, 0, 255, 0`
for j in 0zFF00.00FF
    echo j
endfor
```

#### List

```vim
[1, 2, ['a', 'b']]

let mylist = [1, 2, ['a', 'b']]
echo mylist[2][0]
```

#### Dictionary

```vim
" 两者等价。`#` 在前则表示键名都是字符类型。
{'blue': "#0000ff", 'red': "#ff0000"}
"{blue: "#0000ff", red: "#ff0000"}

let mydict = {1: 'one', 'key': 'two'}
echo mydict[1]
echo mydict['key']
```

#### FuncRef

```vim
" function 是一个 builtin 函数，返回一个函数引用。printf 不会输出，类似于 C 的 sprintf。
let FuncRef = function('printf', ["var=%d\n"])
echo FuncRef(10)

" funcRef 的更多用法 `help function()`
```

### 变量的范围

refs

-   <http://yyq123.blogspot.com/2017/05/vim-script-variables-and-expressions.html>
-   `help variable-scope`

学习变量，了解其作用域与生命周期即可。属于某事物的变量一般只能在这个事物内访问且与事物的生命周期相同。

*按名称理解即可，简单的不做解释*

-   buffer 变量 `b:`
-   window 变量 `w:`
-   tabpage 变量 `t:`

    t:<var_name>	当前标签页的变量

-   global 变量 `g:`

    生命周期是 vim 程序结束时。

-   local 变量 `l:`

    在函数中定义的变量

-   script 变量 `s:`

    作用域是脚本内。生命周期是脚本运行时，即 `source` 时。

-   function 形参 `a:`
-   vim 变量 `v:`

    这是 vim 预设的值。用户可修改部分变量，但是不可修改变量的类型。比如：`v:argv`。

***不写 scope 时， 脚本的默认范围***

> 在脚本内，不在函数内时，是 `g:`。<br>
> 在函数内时是 `l:`。<br>
> 在命令行时是 `g:`。

## 引号

### 单引号 `help expr-'`

除了两个单引号代表一个引号外，其它字符都没有特殊意义。

### 双引号

有特殊意义的字符 `help expr-quote`

    \
    "

    " 注意：这些是无特殊意义的字符
    单引号
    还有一些变量的特殊字符。比如：&, $, ...

### 转义引号

```vim
" ### 转义单引号
echo 'aa''bb'
echo "'"

" ### 转义双引号
echo '"'
" 输出 `aa bb`
"echo "aa""bb"
echo "\""
```

## 字符串的连接

用 `..` 或 `.`(已弃用)。

```vim
'stra' .. 'strb'
"stra" .. "strb"
'stra' .. "strb"
```

### 数字与字符串之间的转换

```vim
echo "123" + 1
echo "123" .. 456
```

## vim script 变量与 shell 变量不同之处

for example

```vim
let var1 = 'AA BB'
" var1 被当作一个整体
let var2 = 'stra' .. var1 .. 'strb'
echo var2
```

## 表达式

ref: `help expression`

一个变量，函数，lambda 是一个表达式，但是一个 Command 不是一个表达式。

一个表达式可含有多个表达式。表达式之间进行算术，逻辑运算，比较，连接等操作还是一个表达式。

`help expression-syntax` 有详细的举例。重点留意: `help expr5, help expr9`。

for example

```vim
expr1 + expr2
expr1 && expr2
expr1 == expr2
expr1 .. expr2
expr1[expr2]

" 表示 option（set <option>） 的值。比如：echo &number
&<option>
" 表示环境变量的值。比如：echo $VIMRUNTIME
$<environmentVar>
" 表示寄存器的值。比如：echo @0
@<register>
```

### expr-entry, method, expr-[:]

#### `expr-entry`

另外一个方法访问 list 和 directory。

expr.name 相当于 expr[name]

for example

```vim
let dict = {"one": 1, 2: "two"}
echo dict.one          " shows "1"
echo dict.2            " shows "two"
```

#### `method`

函数调用的别名一种方法。

`expr8->name([args])` 相当于 `name(expr8 [, args])`。比如：`mylist->filter(filterexpr)->map(mapexpr)->sort()->join()`。

#### `expr-[:]`

表达式内容的剪切。shell 也有相应的功能。

for example

```vim
" ### var
let var = 'ABCDE'
" 截断前面 1 个字符
echo var[1:]
" 截断最后 1 个字符
echo var[:-2]
" 取前面 1 个字符
echo var[:0]
" 取最后 1 个字符
echo var[-1:]
" 取中间
echo var[2:-3]
" 取第 N 个字符
echo var[3:3]

" ### list
let mylist = [1, 2, 3, 4, 5]
echo mylist[1:]
echo mylist[:-2]
echo mylist[:0]
echo mylist[-1:]
echo mylist[2:-3]
echo mylist[3:3]

" let mylist1 = mylist[:]          " shallow copy of a List. 浅复制. 有点像 python。可用于传参。

" 不能对字典操作
" let mydict = {1: 2}
" " 不能对字典操作
" let mydict1 = mydict[:]
" echo mydict
```

## 分支

for example

```vim
if a:num < 0
    return "less then 0"
elseif a:num == 0
    return "equal to 0"
else
    return "greater than 0"
endif
```

## 循环

for example

```vim
" ## for
" ### list
" for 的 in 之后要接 list or blob
for i in [1, [1, 2]]
    echo i
endfor
" i 还可以被访问
"echo i

" list 的元素全是 list 时，可用此方法
for [x, y] in [[1, 2], [3, 4]]
  echo x .. ", " .. y
endfor

" ### blob
for j in 0zFF00.00FF
    echo j
endfor

" ## while
let k = 1
let sum = 0
while k < 10
    let sum += k
    let k += 1
endwhile
echo "sum = " sum

" 还有 break, continue. 没有 switch, do while
```

## 用户函数

ref: `help user-functions`

用户可以自定义函数。

用户函数的规范

-   函数名要大写开头，为了区分 builtin 函数，用户函数名要以大写开头。
-   函数名还可以以 `s:`（但不能以 `l:`, `g:` 开头） 开头，表示该函数只能在脚本内使用。在脚本中也要写 `s:` 才能调用。

`s:` 开头的函数只能在脚本内访问是如何实现的

> 被 `source` 时，加载后 `s:` 被替换成了一个前缀，虽然能访问加前缀的函数名，但是不能以 `s:<fun_name>` 去访问函数了。这点与 Python 的 name mangling 相似。

### 用户函数的格式

用户函数的格式

    fu[nction][!] {name}([arguments]) [range] [abort] [dict] [closure]

#### range

当 `:{range}call` 时，range 会被当成两个实参传给函数的形参 `a:firstline, a:lastline`。这些细节由解释器实现被隐藏起来不用程序员维护 range 也是一件好事。

for example

```vim
function RangeFunc() range
    echo a:firstline .. ', ' .. a:lastline
endfunction

" 文件的行数必须有 8 行
4,8call RangeFunc()
```

#### abort

When the `[abort]` argument is added, the function will abort as soon as an error is detected.

*不了解 abort*。

#### dict

如果加了 dict, 则必须通过字典的 entry 来调用。

for example

```vim
function Mylen() dict
   return len(self.data)
endfunction

let mydict = {'data': [0, 1, 2, 3], 'len': function("Mylen")}
echo mydict.len()
echo mydict['len']()
```

#### closure

表示函数是一个闭包。该闭包能获得外部的变量。

for example

```vim
function! Foo()
    let x = 0

    function! Bar() closure
        let x += 1
        return x
    endfunction

    return funcref('Bar')
endfunction

let F = Foo()
echo F()   " 1
echo F()   " 2
echo F()   " 3
```

## 异常

for example

```vim
try
    throw "error"
catch /.*/
finally
    echomsg "cleanup"
endtry

" 只能抛出 string?, 且无法保存 throw 的表达式
" try
"     throw 100
"     throw ['ABC']
" catch /100/
"     echo "error"
" endtry

" cat vim error
try
    " 要测试时再打开
    " sleep 100
catch /^VIM:Interrupt$/         " dos 用 C-break, 实测没有捕获。。。
    echo "catch VIM:Interrupt"
catch /^Vim\%((\a\+)\)\=:E/	 " catch all Vim errors
    echo "catch all vim error"
catch /.*/
    echo "catch all error"
endtry
```

## 闭包

for example

```vim
" for Closure
function FunctionForClosure()
    let x = 0

    function! Bar() closure
        let x += 1
        return x
    endfunction

    return funcref('Bar')

endfunction

" get funcRef of Bar
let TheBar = FunctionForClosure()

echo TheBar()
echo TheBar()
```

## lambda

    {args -> expr1}

for example

```vim
let F = {arg1, arg2 -> arg1 - arg2}
echo F(5, 2)
```

## Curly braces names

可用 expression 的内容组成一个新 expression。`help curly-braces-names`

for example

```vim
let usera=johan
let userb=johan
let johanVar=10
let kerryVar=100
echo {usera}Var         " 相当于 echo johanVar
echo {userb}Var         " 相当于 echo kerryVar
```
