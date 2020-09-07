# Linux 下查看结构体和常量等标志符的定义

*又到了磨刀环节*

### refer

- <https://stackoverflow.com/questions/4980819/what-are-the-gcc-default-include-directories>

    gcc, include path

- <https://stackoverflow.com/questions/1932396/c-source-tagging>
    
    ctags, c++


### 问题

在开发时，man 虽然能查看 function 帮助文档，但是查找结构体或常量等标识符的定义则是比较难。

可用 ctags 解决。但网上大多的解决方案都不够方便。

### 解决方案

C 用 `tcman <要找的标识符>`， C++ 用 `tcppman <要找的标识符>` 就可找到其定义。


### 过程

- 安装 ctags (这里我是用 ArchLinux)

    ```
    pacman -S ctags
    ```

- 创建 tags 文件

    ```
    列出 gcc 查找的 include path
        For C:
            gcc -xc -E -v -
        For C++:
            gcc -xc++ -E -v -

    mkdir /var/ctags

    ctags -o /var/ctags/tagsForC -R \
    /usr/lib/gcc/x86_64-pc-linux-gnu/*/include* \
    /usr/local/include \
    /usr/include
    
    ctags -o /var/ctags/tagsForCpp --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ -R \
    /usr/include/c++/* \
    /usr/lib/gcc/x86_64-pc-linux-gnu/*/include* \
    /usr/local/include \
    /usr/include
    ```

- alias tcman, tcppman

    ```
        有 ~/.bashrc 中加入:
            alias tcman='vim -R --cmd "let &tags.=\",/var/ctags/tagsForC\"" -t'
            alias tcppman='vim -R --cmd "let &tags.=\",/var/ctags/tagsForCpp\"" -t'

        source ~/.bashrc

        这时就可用 tcman, tcppman 了，比如：
            tcman environ
            tcman NULL
            tcman sockaddr
            tcman printf

            tcppman environ
            tcppman NULL
            tcppman ostream
            tcppman string
    ```

- vim 操作 tags

    ```
    用 tcman, tcppman 打开 vim 之后，会有很多 tags，这样要学会在 vim 操作 tags 了。

    :ts, :tn, :tp, C-], C-t         # 用 :help 查它们作用
        :ts /<regex>            # 用正则表达式搜索 tags
    ```
