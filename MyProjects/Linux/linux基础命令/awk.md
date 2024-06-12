# awk

### References

-   [变量定义与使用](https://stackoverflow.com/a/19075707/16235950)

### awk 格式

mawk - pattern scanning and text processing language

    mawk [-W option] [-F value] [-v var=value] [--] 'program text' [file ...]

    mawk [-W option] [-F value] [-v var=value] [--] -f <program-file> [file ...]

*program text 是 program-file 的内容。*

#### program text 格式

program text 格式

    [pattern] {<action>} [pattern] {<action>} ...

        pattern: 默认是返回真
        {<action>}: 默认是 {print }

### awk 的 variable, pattern, action

#### 常量

for example

```shell
# 10: Numeric constants
# "ABC": String constants。记得要加双引号，因为 awk 的自定义变量是没有 '$'。
echo test | awk '{print 10; print "ABC"}'
```

#### awk 的环境变量

    $0: 一行
    $1: 第一个
    $2: 第二个
    ...
    NF: $0 拥有的字段总数
    NR: 当前正在处理的行数
    FS: 当前的分隔符，默认是空格

for example

```shell
echo -e "abc:def\nghi:jkl" | awk -F':' '{print $0, NF, NR, FS}'
```

#### Pattern

    BEGIN：在读入第一行数据之前。非 BEGIN 的 pattern 都是在读入第一行数据之后执行的。
    END:   在读入最后一行数据之后
    >
    <
    >=
    <=
    ==
    !=
    ...

##### 容易忽略的 BEGIN 问题

因为 awk 读入第一行时，都是按原来的环境（比如：FS）读入数据的。

因为非 BEGIN 的匹配都是在读入第一行数之后，所以没有 BEGIN 则是按原来环境来读入数据。

for example

```shell
echo -e "abc:def\nghi:jkl" | awk -F':' '{printf "%s\t%s\n", $1, $2}'
# BEGIN：在读入第一行数据之前。非 BEGIN 的 pattern 都是在读入第一行数据之后执行的。
echo -e "abc:def\nghi:jkl" | awk '{FS=":"} {printf "%s\t%s\n", $1, $2}'
echo -e "abc:def\nghi:jkl" | awk 'BEGIN {FS=":"} {printf "%s\t%s\n", $1, $2}'
```

#### Action

bash 中的命令不能用 awk program 中，只能 awk 中提供的命令，且 awk 有提供专门的环境变量。比如：shell 没有 print 命令，shell printf 与 awk printf 用法不一样。

for example

    awk '$1 > 0 {print $1}' <file> ...

for example

```shell
# 每读入一行会执行一次 print 10 。print 的输出是有换行的。
echo -e "abc\ndef" | awk '{print 10}'
echo -e "abc\ndef" | awk '{printf "%s=%d\n","key", 10}'
```

### 自定义的变量

for example

```shell
echo -e "abc\ndef" | awk '{ key = "key"; print key} {print key}'
```

### 使用外部变量

    # 创建自定义变量 var。value 中可以使用外部变量。
    awk -v var=<value>

for example

```shell
shell_var_a="SHELL_VAR_A"
shell_var_b="SHELL_VAR_B"
echo "line one\nline two" | awk -v awk_var_a="$shell_var_a" -v awk_var_b="$shell_var_b" 'BEGIN {print awk_var_a} END {print awk_var_b}'
echo $awk_var_a
echo $awk_var_b
```

在 `''` 中使用外部变量

    awk '<innerEnviroment> '<outerEnviroment>'{<innerEnviroment>'<outerEnviroment>'}'

for exmple

```shell
var=ABC DEF
awk 'innervar="'$var'"{print innervar}'

awk '{print "'$var'"}'
    相当于 awk '{print "ABC DEF"}'
```

### 使用正则表达式过滤行

ref: [regexp](https://www.tutorialspoint.com/awk/awk_regular_expressions.htm)

`awk '[string!~]/<regexp>/ <code_block>'`

    [string!~]: 默认为 $0~
    '~' 表示是否符合匹配，如果是则返回真
    '!~' 反向匹配

for example

```shell
echo -e "cat\nbat\nfun\nfin\nfan" | awk '/n$/ {print $0}'
echo -e "cat\nbat\nfun\nfin\nfan" | awk '/(f|c|b).(t|n)/ {print $0}'
echo -e "cat\nbat\nfun\nfin\nfan" | awk '$0~/f.n/ {print $0}'
echo -e "cat\nbat\nfun\nfin\nfan" | awk '$0!~/f.n/ {print $0}'
```

### awk 的 `$()`

for example

```shell
# awk 的 $() 类似于 shell $(())
echo ABC_DEF_GHI_JKL | awk -F '_' '{print $(NF - 1)}'
echo ABC_DEF_GHI_JKL | awk -F '_' '{print $(2 - 1)}'
```

## Others

### awk 读取配置

ref: [awk 读取配置](https://www.jb51.net/article/60854.htm)

for example

```shell
# ### config file
[section_a]
item_a = abc
item_b = def

[section_b]
item_a = hij
item_b = klm

# ### test file
#!/bin/bash
# __readINI [配置文件] [节点名] [键值]
function __readINI() {
    INIFILE=$1; SECTION=$2; ITEM=$3
    _readIni=`awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' $INIFILE`

    #去空格
    echo ${_readIni} | sed s/[[:space:]]//g
}

__readINI "config_file" "section_a" "item_b"
```
