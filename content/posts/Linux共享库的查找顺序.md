+++ 
draft = true
date = 2024-06-11T20:50:23+08:00
title = "Linux 共享库的查找顺序"
description = ""
slug = ""
authors = ["johanchane"]
tags = ["Linux操作系统", "共享库", "查找顺序"]
categories = ["Linux操作系统"]
externalLink = ""
series = []
+++

# Linux 共享库的查找顺序

## 共享库

通知动态链接器共享库的位置的方式:
-   LD_LIBRARY_PATH   
-   标准库目录 (ldconfig 会依次搜索下面的目录生成 `/etc/ld.so.cache`)
    -   /etc/ld.so.conf: 在一些发行版中应该会包含 `/usr/local/lib` 目录, 否则需要手动添加。
    -   /lib
    -   /usr/lib
-   run path
    -   DT_RPATH
    -   DT_RUNPATH

在运行时找出共享库:
1.  如果共享库是绝对路径, 则直接加载。
2.  否则动态链接器会使用下面的规则来搜索共享库:
    1.  DT_RPATH (前提是没有 DT_RUNPATH)
    2.  LD_LIBRARY_PATH (前提是可执行文件不是一个 set-user-ID 或 set-group-ID 程序。这项安全措施是为了防止用户欺骗动态链接器让其加载一个与可执行文件所需的库的名称一样的私有库)
    3.  DT_RUNPATH
    4.  /etc/ld.so.config
    5.  /lib
    6.  /usr/lib

它们的应用场景:
-   标准库目录: 为所有程序设置共享库的查找位置
-   LD_LIBRARY_PATH: 为某个可执行文件设置共享库的位置
-   run path: 也是为某个可执行文件设置共享库的位置, 但是它放在可执行文件中的。

添加 run path 的方式:
-   gcc 使用 `-rpath`
-   构建可执行文件时使用 LD_LIBRARY_PATH

`DT_RPATH` vs `DT_RUNPATH`:
-   在第一版 ELF 规范中，只有一种 rpath 列表能够被嵌入到可执行文件或共享库中，它对应于 ELF 文件中的 DT_RPATH 标签。后续的 ELF 规范舍弃了 DT_RPATH，同时引入了一种新标签 DT_RUNPATH 来表示 rpath 列表。
-   理解 DT_RUNPATH 标签的链接器会忽略 DT_RPATH 标签.

`/lib` vs `/usr/lib`:
-   根据 [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) 可知, `/lib` 是系统启动时用到的库。`/usr/lib` 是大多数标准库安装的目录。和 `/bin` vs `/usr/bin` 类似。

## 共享库的 soname 和版本管理

共享库的版本格式:
-   `<libname>.so.<主要版本号>.<次要版本号>`。
-   主要和次要版本标识符可以是任意字符串。按照惯例, 主要版本号是一个数字。次要版本号是一个数字或是两个由点分隔的数字, 其中第一个数字标识出了次要版本，第二个数字表示该次要版本中的补丁号或修订号。

soname 是共享库的别名, 不是真实名称。`DT_SONAME`

### 例子

## 例子

## References

-   《Unix/Linux系统编程手册》
