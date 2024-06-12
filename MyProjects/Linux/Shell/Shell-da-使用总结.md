# Shell 的使用总结

## Content

${toc}

## 保留多行结果

```sh
output=$(seq 5)
# 一行
echo $output
# 多行
echo "$output"
```

将结果保存到数组

```sh
my_array=($(seq 5))
echo "${my_array[@]}"
declare -p my_array
```

## `~, *` 有双引号中无效

```sh
echo "~"
echo "./*"
```

## `$*` 和 `$@` 的区别

```sh
#!/bin/sh

myarray[0]="one"
myarray[1]="two"
myarray[3]="three four"

echo "with quotes around myarray[*]"
for x in "${myarray[*]}"; do
        echo "ARG[*]: '$x'"
done

echo "with quotes around myarray[@]"
for x in "${myarray[@]}"; do
        echo "ARG[@]: '$x'"
done

echo "without quotes around myarray[*]"
for x in ${myarray[*]}; do
        echo "ARG[*]: '$x'"
done

echo "without quotes around myarray[@]"
for x in ${myarray[@]}; do
        echo "ARG[@]: '$x'"
done
```

```sh
#!/bin/sh

set -- "one" "two" "three four"

echo "with quotes around $*"
for x in "$*"; do
    echo "ARG[*]: '$x'"
done

echo "with quotes around $@"
for x in "$@"; do
    echo "ARG[@]: '$x'"
done

echo "without quotes around $*"
for x in $*; do
    echo "ARG[*]: '$x'"
done

echo "without quotes around $@"
for x in $@; do
    echo "ARG[@]: '$x'"
done
```

## printf

```sh
# 如果格式的字符不够时，会重头开始利用
printf "%s,%s" "a" "b" "c"
printf "%s,%s" "a" "b" "c" "d"
```

## join 数组

```sh
my_array=($(seq 5))
str=$(printf ",%s" "${my_array[@]}")
str=${str:1}
echo $str
```

## 查询 builtin 命令的文档

```sh
# in sh/bash
help declare
```

## 删除开头或结尾的空白符

See [How to trim whitespace from a Bash variable?](https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable)

删除前后空白字符

```
echo "   lol  " | xargs -l1
```

删除前或后空白字符

```sh
echo -e " \t   blahblah  \t  " | sed 's/^[ \t]*//;s/[ \t]*$//'
```

## range

```sh
for i in {1..5}; do
    echo $i
done

for i in $(seq 5); do
    echo $i
done

for i in $(seq 10 20); do
    echo $i
done

for i in $(seq 10 2 20); do
    echo $i
done
```

## Generate random numbers

```sh
function gen_rand_nums {
    local start=$1
    local end=$2
    local len=$3
    for i in $(seq $len); do
        echo -n $(($RANDOM % $end + $start))
        echo -n ' '
    done
    echo ''
}

gen_rand_nums 10 20 10
```
