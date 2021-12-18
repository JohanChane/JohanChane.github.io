# Shell 的杂项

## Shell 的参考资料

- <https://www.gnu.org/software/bash/manual/html_node/index.html>
- <https://www.tldp.org/LDP/abs/html/special-chars.html>

    bash 的所有特殊字符

- <https://github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh>

- <https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and>
- <https://unix.stackexchange.com/questions/187651/how-to-echo-single-quote-when-using-single-quote-to-wrap-special-characters-in>

## 脚本执行方式

    # 在当前的 shell 进程执行。
    shell 执行 `. <shell script>` OR `source <shell script>`
    # 新建一个 bash 子进程（subshell）来执行。
    bash <shellScript>
    # 新建一个 '#!' 指定的 shell 子进程（subshell）来执行。
    <shellScript> 的相对路径或绝对路径

## 调试

    set -x; set +x
    bash -x <shell_script>

### 字符串拼接

    str=${str1}${str2}

## Others

    let

    # [100, 999]
    for i in {1..5}; do echo $(( $RANDOM % 999 + 100 )); done
