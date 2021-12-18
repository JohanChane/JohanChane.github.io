# Shell 语言特性

## 说明

只是介绍 Shell 的语言特性

## 变量

### 变量的作用域

有全局和局部变量（只能在函数中定义）

declare 与 local 用法相同，它们的区别是 local 只用于定义局部变量。

for example

```shell
#!/usr/bin/env bash

globalVar1="ABC"
declare globalVar2="DEF"
function funcForVarScope() {
    globalVar2="def"
    globalVar3="HIJ"
    declare localVar1="abc"
    # 建议用此方法，因为直观
    local localVar2="def"
}

funcForVarScope

echo $globalVar2
echo $globalVar3
echo $localVar1
echo $localVar2
```

### 变量的属性

*变量是有属性的，可用 `declare -p` 查看其属性。*

#### 整数

    # 不支持浮点类型
    declare -i

#### 字符

    默认
    var=100     # 相当于 var="100"

#### 数组

    declare -a      # indexed arrays. e.g. array[1]
    declare -A      # associative arrays. e.g. array[key]

*indexed arrays 类似于 c 的数组，associative arrays 类似于 python 的字典。*

for example

```shell
#!/usr/bin/env bash

# ## indexed array
declare -a indexedArray1

indexedArray1[0]=10
indexedArray1[1]=20

echo ${indexedArray1[@]}

# 声明并赋值
indexedArray2[0]=100

echo ${indexedArray2[@]}

indexedArray3=(1000 2000 3000)

# 移除元素
unset indexedArray3[0]
echo ${indexedArray3[@]}
unset indexedArray3
echo ${indexedArray3[@]}

# ## associative array
declare -A assocArray1

assocArray1[a]=10
assocArray1[b]=20

echo ${assocArray1[@]}

# 声明并赋值
assocArray2[a]=100

echo ${assocArray2[@]}

assocArray3=(a=1000 b=2000 c=3000)

echo ${assocArray3[@]}

# 移除元素
unset assocArray3[a]
echo ${assocArray3[@]}
unset assocArray3
echo ${assocArray3[@]}
```

#### 只读属性

    declare -r

#### 引用

    declare -n

for example

```shell
#!/usr/bin/env bash

var="value"
declare -n varRef="var"
echo "$varRef"
varRef="new value"
echo $var
```

#### export 属性

    # 相当于 export 这个变量
    declare -x

for example

```shell
declare -x var1=100
printenv | grep 'var1=100'
```

## 数组的 expansion

`${name[@]}, ${name[*]}`

    表示 name 数组的所有内容。区别与 $@, $* 相同。

`${#parameter}`

    parameter 字符个数或数组元素个数。${@}, ${*} 被当成数组, 所以 ${#@}, ${#*} 返回的是数组的大小。

`${!prefix@}, ${!prefix*}`

    将前缀为 prefix 的数组的名字组合。区别与 $@, $* 相同。

`${!name[@]}, ${!name[*]}`

    将 name 数组的所有下标组合。区别与 $@, $* 相同。

for example

```shell
#!/usr/bin/env bash

array1=(10 20 30)

# ### "${array1[@]}" 与 "${array1[*]}" 的区别
for i in "${array1[@]}"; do
    echo $i
done

for i in "${array1[*]}"; do
    echo $i
done

# ### 数组长度
echo ${#array1[@]}

array2=(100 200 300)

# ### 匹配数组名
echo ${!array@}

# ### 收集数组下标
echo ${!array1[@]}
```

## 分支控制

### 条件

[`test, [ ] , [[ ]]`](https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs)

[`[ ], [[ ]]` 是有区别的](https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs)

condition 可取反的位置

for example

```shell
# !(!0 && !0) && !(0) = 1
if ! [[ ! (0 -ne 1) || ! (0 -ne 1) ]] && ! [[ 0 -eq 1 ]] ; then echo true; else echo false; fi
```

`&&, ||` 与 `-a, -o` 的区别

> `-a, -o` 只能用于 test 中，当然还有 `[ ]`。

for example

    if [ 1 -a 1 ]
    if [[ 1 -a 1 ]]          # 出错
    if [ 1 ] -a [ 1 ]       # 出错

### 比较

#### 数字的比较

    greater than: lt
    equal: eq
    less than: lt
    not: n

    -eq, -ne
    -lt, -le
    -gt, -ge,

#### 字符的比较

    =, !=
    -z, -n

#### 文件的判断

    -e, -f, -d

### if, case

    if, elif, else, fi, then
    case, esac, in

for example

```shell
#!/usr/bin/env bash

while :
do
  read INPUT_STRING
  case $INPUT_STRING in
	hello)
		echo "Hello yourself!"
		;;
	bye)
		echo "See you again!"
		break
		;;
	*)
		echo "Sorry, I don't understand"
		;;
  esac
done
```

### 循环控制

    for, do, done
    while, do, done
    until, do, done
    select, do, done

for example: for

```shell
#!/usr/bin/env bash

for i in 'aa' 'bb' 'cc'; do
    echo -ne "$i\t"
done
echo ""

for ((i=0; i<10;i++)); do
    echo -ne "$i\t"
done
echo ""
```

for example: while

```shell
#!/usr/bin/env bash

i=0
while [[ $i -lt 10 ]]; do
    echo -ne "$i\t"
    let "i++"
done
echo ""
```

for example: until

```shell
#!/usr/bin/env bash

# until 与 while 的区别：until 与 while 相反，until 是条件不成立则进入循环，成立则退出循环。
i=0
until [[ $i -ge 10 ]]; do
    echo -ne "$i\t"
    let "i++"
done
echo ""
```

for example: select

```shell
#!/usr/bin/env bash

select choice in 'option1' 'option2' 'quit'; do
    case $choice in
        'option1')
            echo selected option1
            ;;
        'option2')
            echo selected option2
            ;;
        'quit')
            break;
            ;;
        *)
            echo unknown option
            ;;
    esac
done
```

### Shell Parameters

Positional 与 Special Parameters 都无法直接修改，因为不符合变量命令规则。

#### Positional Parameters

    $1, $2, ...

*$0 不是 Positional Parameters。*

设置 Positional Parameters

    set -- <Positional Parameters>

*The positional parameters are temporarily replaced when a shell function is executed.*

#### Special Parameters

`$*, $@, $#`

    $*, $@ 其实是数组。$# 表示数组大小。

    $@=($1 $2 ...)
    $*=($1 $2 ...)

    # "$@", "$*" 区别与 "$array[@]", "$array[*]" 的区别相同
    "$@": "$1" "$2" ..
    "$*": "$1c$2c..."           # c 是 IFS 的第一个字符

for example

```shell
#!/usr/bin/env bash

set -- one two "three four"

for i in "$@"; do
    echo $i
done

for i in "$*"; do
    echo $i
done
```

Other Parameters

    $?: the exit status of the most recently executed foreground pipeline.
    $0: shell name or shell script name
    $$: the process ID of the shell.
    $!: the process ID of the job most recently placed into the background

## Function

#### 定义函数

    [ function ] <funname> [()] {
        ...
        [return [<大于 0 的整数>]]

    }

***return 只是改变 $? 的值而不改变 function substitution（$(<function>)）。function substitution 是函数的输出结果。***

    # 只列出声明
    declare -F
    # 只列出声明与定义
    declare -f

#### parameters

Positional Parameters 同样适合于函数。

进入函数时，$1, $2, ... 会被修改，函数结束后，它们会被还原。

#### 传参方式

Positional 与 Special Parameters 都无法直接修改，因为不符合变量命令规则。所以不用考虑传参方式。

#### 名字空间

函数名可以有 `:`, 约定 my::func 中的 my 为名字空间。shell 本身没有名字空间。
