# Google Shell Style Guide

## Content

${toc}

## References

-   [Shell 风格指南](https://zh-google-styleguide.readthedocs.io/en/latest/google-shell-styleguide/contents/)

## Name Convention(优先级从上到下):

### 文件名

小写加下划线

#### 扩展名

library 要后缀 .sh, 设置为不可执行
可执行文件不要后缀

### 函数名

小写加下划线

如果是包的函数则函数前面加前缀（`::` 无特殊意义，可用于名称）：

    <package_name>::<function_name>

for example

    # Single function
    my_func() {
      ...
    }

    # Part of a package
    mypackage::my_func() {
      ...
    }

    # call the function
    mypackage::my_func


### 常量和环境变量名

大写加下划线

for example

```sh
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr ORACLE_SID='PROD'
```

`declare -x` 在函数中无效，建议使用 `export`。

for example

```sh
function func {
    declare -x VAR=10
}

func

printenv | grep VAR
```

### 自定义全局变量

小写加下划线

### 局部变量(在函数内):

小写加下划线

for example

    ### 自定义只读局部变量
    local -r <variable>

    # OR
    # [Bash local AND readonly variable](https://stackoverflow.com/questions/45409822/bash-local-and-readonly-variable)
    local <variable>
    readonly <variable>

#### 循环的局部变量（如紧接 for 的变量）

小写加下划线

### 错误信息应该重写向到标准错误

    err() {
      echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
    }

## Others

### 尽量检查返回值

    if [[ "$?" -ne 0 ]]

### 字符串变量要用 ""

### 尽量用 [[ ]], 少用 [], test

    [[ ]] -a 改为 &&

### 使用 `$()` 比反引号更加容易阅读

### 少用 eval

### 管理导向循环的变量问题

使用管道会创建子进程来执行。

for example

```sh
### 操作
./test > aa | ./test > bb
cat aa bb

### test file
#!/bin/bash
echo $$

### 问题

echo -e 'AA\nBB' | while read line; do
    var1=10
done
# var1 没有定义
echo $var1

### 解决
echo -e 'aa\nbb' > txtfile; while read line; do echo $line; done < txtfile
while read line; do echo $line; done < <(echo -e 'aa\nbb')
```

### 当赋值的值由命令替换提供时，声明和赋值必须分开。

for exmple

    my_func2() {
      local name="$1"

      # Separate lines for declaration and assignment:
      local my_var
      my_var="$(my_func)" || return

      # DO NOT do this: $? contains the exit code of 'local', not my_func
      local my_var="$(my_func)"
      [[ $? -eq 0 ]] || return

      ...
    }

## 个人风格

readonly 定义局部变量比较麻烦，所以不使用了。所以声明变量都是使用 `declare, local`。不用 `declare -x` 而用 `export`。

函数的声明风格：

```sh
# 因为不用写形参，所以不写括号。
function func {
}
```
