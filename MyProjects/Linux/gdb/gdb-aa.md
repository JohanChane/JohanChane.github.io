# GDB

## Content

${toc}

## References

-   [gdb onlinedocs](https://sourceware.org/gdb/current/onlinedocs/gdb/#SEC_Contents)

## Get help

    # 列出所有 command classes 以及它们的 commands。
    help all

    # e.g. help info sources
    help <Command class>

    help <command>

    # 查找与 <word> 相关的命令。与 linux 命令 `apropos` 类似。
    apropos <word>

    # 与 `apropos <word>` 区别是显示每个命令的详细文档，而 `apropos -v <word>` 只显示命令和命令的简短说明。
    apropos -v <word>

## 查看源文件

### Source files

    # 查看所有 source files
    info sources [-dirname | -basename] [regexp]

    # 查看当前 source file
    info source

    # 查看 source files。每次运行都会显示下一次的结果。
    search <regexp>
    reverse-search <regexp>

### list

    list
    # 将当前的 list 位置上移/下移 N 行并显示。
    list {- | +}<N>
    # 对于垂直是 768 的分辨率的屏在，30 行刚好。
    set listsize <num>
    list <line_num>
    list <symbol>
    list <line_num>,<line_num>
    list <symbol | line_num>, +<N>

    # 显示行的地址
    info line <n>
    # 显示该地址的源代码
    list *<address>

## Location

    # file 可以绝对路径或相对路径
    list '<file>':<symbol>::<symbol>
    list '<file>':<lineNumber>

分号的作用

> 当文件名出名特殊字符时，如 `.` 也能自动补全。

## Expression

有多个命令会使用 exp。比如：print，watch 等。

用指针表示数组的 exp

```c
#define LIST_SIZE (5)

void func(int* list) {
}

int main() {
    int list[LIST_SIZE] = {1, 2, 3, 4, 5};
    func(list);
}
```

```gdb
# `print (*list)@5`. `@5` 表示 (*list) 是第一个数组单元，一共有 5 个单元。
print *list@5
# `print (int[5])(*list)`. `(int[5])` 与 `@5` 同理。
print (int[5])*list
# 不是打印数组
#print *(list@5)
#print *(int[5])list

# `int(*)[5]` 表示有 5 个元素的数组指针。和 C 一样。
print *(int(*)[5])list
```

取址时要注意的问题

    char buf[1024];

> `watch (long)*buf; watch *(long*)buf` 是有区别的。`watch (long)*buf` 因为会先执行 `*buf` 所以不一定是 sizeof(long) 个字节的单元。

## Value history

gdb 会将一些输出结果（比如：print）保存到 `$<N>` 的 gdb 变量中。除了这些变量， 用户也可以用 set 保存自己的信息到自定义的 gdb 变量中。

    # show value history
    show values

for example

    set $myvalue=10
    print $myvalue
    print $1

## info, show

### info

查看程序的信息。比如：info variables, info args, info breakpoint。

### show

查看 debugger(GDB 程序) 的信息。比如：show history, show listsize, show logging file。

## 操控程序的运行(start, run, continute, next, step, until, finish, return)

-   step

    单步执行，遇到函数则进入

-   next

    单步执行，遇到函数则步过（即一次执行完函数）。

    *next 过程中for init 部分与判断部分一起执行。*

-   contine

    从当前位置连续执行函数，直到遇到断点

-   until

    可用来跳过循环。没有参数时，会运行到当前行下面的行才停止。

    除了不能加条件，参数与 break 相同。

    *help 有比较好的说明。*

-   finish

    直到函数运行完成

## breakpoint, watchpoint, catchpoint(disable, enable, delete)

### break

    break <location> [if <condition>]

for example

    break 1 if i == 10 || i == 20

### watch, rwatch, awatch

    # expr 必须是一个 <内存单元>
    {watch, rwatch, awatch} <expr> [if (<condition>)]

watch

> 只有内存单元的内容发生改变时，才触发。写入相同的值并不能触发。

rwatch

> read only watch. 读内存单元时，会触发。注意：`sum = 10` 会触发，但是 `sum += 10` 并不触发。

awatch

> access watch. 读写都触发。

注意

> 它们使用的符号不是表示固定的东西，根据作用域的不同可能会表示不同的东西。比如：符号重名。解决这个问题，将符号换为地址即可。
>
> 符号消失时，watchpoint 会补自动删除。

### catch

当发生某些事件时，停止程序。

    # 当发生系统调用时会停止程序。
    catch syscall
    catch fork
    ...

### condition, command

condition 用于编辑 breakpoint 的条件。condition 很有用，比如在一个循环中调试。

    condition <breakpoint_num> [<expression> | <number>]

Set commands to be executed when a breakpoint is hit.

    command <breakpoint_num>

## 查看和修改内存的信息(print, x, disassemble)

### print

    print <exp>
    print /x <exp>

[查看宏的值](https://stackoverflow.com/questions/26881742/how-to-print-define-value-in-gdb)

### x

FMT

> FMT is a repeat count followed by a format letter and a size letter.

print 的 FMT 只支持 format letter.

    # o(octal), x(hex), d(decimal), u(unsigned decimal),t(binary),...
    format letter

    # b(byte), h(halfword), w(word), g(giant, 8 bytes)
    size letter

查看内存。

    # 默认为小端模式
    x /<count><o|x|d|u><b|h|w|g> <address>

for example

    x /2xb 0x555555554000
    x /2xh 0x555555554000

### set

set 是 gdb 的修改命令。比如：args, variables, ...

修改内存。

    set <process_variable> = <value>
    # 还能修改程序的信息
    set args <program_args>

## call

调用一个函数。

如果程序不调用某函数，而我们要调试时，可用该指令调用函数触发断点。

## 栈

    # 查看有哪些栈帧
    info stack(与 backtrace 相同)
    # 查看栈帧的内容
    info frame <n>
    # 选择栈帧。可用于查看当前运行的位置。
    frame <n>
    # 查看运行到的位置。信息比 frame 详细。
    where

## 查看哪些进程/线程，和选择操作

### 进程

    info inferiors
    inferior [Num]

    # fork 之后跟踪父或子进程。默认是 parent。
    {show | set} follow-fork-mode {parent | child}
    # fork 之后是否 detach 某个进程。默认是 on，所以 fork 之后，后台的进程会无法继教调试。
    # 如果是 off。则 fork 之后，父子进程都保留。step 之后，父子进程会停留在 fork 语句之后。
    {show | set} detach-on-fork {on | off}

### 线程

    info threads
    thread [Id]

*step `thread_create` 之后，后台的线程会继续运行。前台线程会停留在 thread_create 之后。*

## Log file

    set logging file [filename]
    # 只有打开 logging ，才会创建logging file 且 overwrite 和 redirect 才起作用。
    set logging enabled {on | off}

    # 默认是 on。如果 off, 则是 append 模式。
    set logging overwrite {on | off}

    # 默认是 off，与 tee 类似。如果是 on, 则只输出到 log file 而不会输出到控制台。
    set logging redirect {on | off}

常用

> 如果想过滤命令的输入时，用 `set logging on`，然后执行命令，再 `set logging off`。之后到 `!cat gdb.txt | grep -i <regexp>` 即可。

## Core file

    # core file will be generate in working directory.
    # 如果出现 Aborted (core dumped) 则表示产生 core 文件。
    generate-core-file

    # 程序死掉生成的 core 文件格式
    /proc/sys/kernel/core_pattern

### coredumpctl

    # 查看所有 core dumped 记录
    coredumpctl list [<match>]

    coredumpctl info <match>
    # 使用 gdb 调试。相当于 `gdb <executable> <core-file> or gdb <executable> -c <core-file>`。
    coredumpctl gdb <match>

## 设置程序的参数

    # 查看程序的参数
    show args

    # 在 gdb 内设置参数
    set args=<paraments>
    {start | run} [paraments]

## gdb 调试程序

    # ## shell 内
    gdb -pid <pid> [program_file]
    gdb [-c core_file] <program_file>

    # ## gdb 内
    attach <pid>
    detach

    # Use FILE as program to be debugged. 会加载文件的字符。
    file <file_to_be_debuged>

## 运行 gdb 脚本

    source <gdbScript>
    gdb -x <gdbScript>

## Cpp 的 vtbl

    # EXPRESSION 是代表一个 object.
    info vtbl EXPRESSION

## 解码 Cpp 的 Symbol

    nm <app> | c++filt | grep <regexp>
    objdump -S <app> | c++filt

## 查看信息

### 查看有关程序的信息

    ptype, whatis 查看 expr 的类型

    # 搜索变量
    info variables <REGEXP>
    info functions <REGEXP>
    info classes <REGEXP>
    # 搜索数据类型。`info types int`，会显示 int，short int，unsigned int, ...
    info types <REGEXP>
    info locals
    info source
    info sources <REGEXP>
    ...

For Example

```
# -n: 不打印 non-debug symbols
info variables -n -t int
info locals -t int
```

### 查看进程的信息

    # 显示进程的 process(pid) cmdline cwd exe
    info proc

    # Names of targets and files being debugged.
    # 与 info files 相同
    info target

    # 显示地址附近的符号。
    info symbol <addr>

## handle

[调试信号](https://www.cnblogs.com/dongzhiquan/p/4752649.html)

## 常用的短命令

    # step, next, continue, until
    s, n, c, u
    # info breakpoints
    i b
    # delete
    d
    # backtrace
    bt
    bt full         # 显示 frames 的所有变量
    # 执行上个命令
    <enter>

## TUI

[TUI Key Bindings](https://sourceware.org/gdb/onlinedocs/gdb/TUI-Keys.html)

    # ## 开关 TUI
    C-x a
    tui {enable | disable}
    # ## layout
    layout {src | next | asm | ...}
    C-x 1
    C-x 2
    # ## 切换 win
    C-x o
    # 查看打开的 win
    info win
    # ## Others
    winheight

## GDB Config

GDB 的配置文件是 `~/.gdbinit`。

## Examples

### Example1

```c
#include <stdio.h>

#define LIST_SIZE (5)

void func(int* list) {
    int sum = 0;
    for (int i = 0; i < LIST_SIZE; i++) {
        // 不会触发 `rwatch sum`。
        // sum += list[i];
        // 当 sum 的值没有发生变化时，不会触发 `watch sum`。
        // sum = list[0];
        // 触发 `rwatch sum`。
        // printf("sum = %d\n", sum);

        // 注意：会触发 `rwatch list[0]`。
        // list[0] = 10;

        // list[1] = 10;
    }

    printf("sum = %d\n", sum);
}

int main() {
    int list[LIST_SIZE] = {1, 2, 3, 4, 5};
    func(list);
}
```

gdb

```gdb
watch (*list)@5
rwatch (*list)@5
awatch (*list)@5

break <line_num> if num == 0 || num !=0
condition 1 num == 10
```

### Example: fork

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <wait.h>
#include <stdlib.h>

int main() {
    pid_t p1;
    switch (p1 = fork()) {
        case -1:
            perror("fork fail!");
            exit(EXIT_FAILURE);
        case 0: {
            printf("child: %d\n", getpid());
            _exit(EXIT_SUCCESS);

        }
        default: {
            int wstatus;
            int s = waitpid(-1, &wstatus, 0);
            if (s == -1) {
                perror("wait fail!");
                exit(EXIT_FAILURE);
            }

            printf("parent: %d\n", getpid());
            exit(EXIT_SUCCESS);
        }
    }

    return 0;
}
```

gdb

```gdb
set detach-on-fork off
info inferiors
inferior <N>
```

### Example: Thread

```c
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>

void* threadFunc(void* args ) {
    printf("%ld\n", args);
    sleep(20);
    return NULL;
}

void* threadFuncA(void* args ) {
    printf("%ld\n", (long) args);
    return (void*) 100;
}

int main() {
    pthread_t t1;
    void* retval;
    int s;
    if ((s = pthread_create(&t1, NULL, threadFunc, (void*)10)) != 0) {
        printf("pthread_create fail!: %s\n", strerror(s));
        exit(EXIT_FAILURE);
    }

    if ((s = pthread_detach(t1))  != 0) {
        printf("pthread_detach fail!: %s\n", strerror(s));
        exit(EXIT_FAILURE);
    }

    /****
    if ((s = pthread_join(t1, &retval)) != 0) {
        printf("pthread_join fail!: %s\n", strerror(s));
        exit(EXIT_FAILURE);
    }
    ***/

    printf("%ld\n", (long) retval);

    return 0;
}
```

gdb

```gdb
info threads
thread <N>
```

### Example: Signal

```c
#define _POSIX_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <wait.h>
#include <stdlib.h>
#include <signal.h>

static void sigHandler(int sig) {
    printf("sig: %d\n", sig);
}

int main() {
    sigset_t sigSet;
    sigaddset(&sigSet, SIGHUP);
    sigprocmask(SIG_BLOCK, &sigSet, NULL);

    struct sigaction act;
    act.sa_handler = sigHandler;
    sigemptyset(&act.sa_mask);
    //sigaddset(&act.sa_mask, SIGHUP);
    // act.sa_flags = SA_RESTART;
    act.sa_flags = 0x10000000;
    if (sigaction(SIGUSR1, &act, NULL) == -1) {
        perror("sigaction error");
        exit(EXIT_SUCCESS);
    }

    int i;
    printf("i = ");
    scanf("%d", &i);
    while (i) {
    }

    return 0;
}
```

gdb

```gdb
handle all stop
handle all pass
# on shell. 注意不是向 gdb 发信号。
kill -SIGUSR1 <pid>
kill -SIGINT <pid>
```

### Example: Cpp

file: app.cpp

```cpp
#include "test.h"

#define SIZE (10)

int main() {
    func(SIZE);

    Parent* parentPtr;
    parentPtr = new Child();
    parentPtr->method();

    delete parentPtr;
}


#ifndef TEST_H
#define TEST_H

extern void func();

extern void func(int i);
```

file: test.h

```cpp
class Parent {
public:
    void method();
    static void staticMethod();
    virtual void virtualMethod();
private:
    int data;
};

class Child : public Parent {
    virtual void virtualMethod();
};

#endif
```

file: test.cpp

```cpp
#include "test.h"

void func() {
}

void func(int i) {
}

void Parent::method() {
}

void Parent::staticMethod() {
}

void Parent::virtualMethod() {
}

void Child::virtualMethod() {
}
```

gdb

```gdb
['<file>':]<symbol>
<symbol>::<symbol>

info vtbl *parentPtr

# 查看当前 source file
info source
# 显示特定的 source files
info sources test

search parent
reverse-search parent
```
