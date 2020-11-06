# GDB


### Refers

- <https://sourceware.org/gdb/current/onlinedocs/gdb/#SEC_Contents>


### get help

note: help 信息有比较好的说明，这里只是记录哪部分要学的。

`help` 有 help 命令的使用。

- `help all`

    列出所有 command classes 以及它们的 commands。

- `help <Command class>`

- `help <command>`

- `apropos <word>`

    查找与 <word> 相关的命令
    `help apropos`

- `apropos -v <word>`

    与 `apropos <word>` 区别是显示每个命令的详细文档，而 `apropos <word>` 只显示命令和命令的简短说明。


### 快捷键

- `<tab>`

- `ctrl + r`

    搜索历史命令。

### gdb

    gdb -pid <pid> [program_file]
    gdb <program_file> [core_file]
    
### location

- `'<file>'::<symbol>::<symbol>`
- `'<file>':<lineNumber> 或 <file>:<lineNumber>`
- `'<obj>.<member>'`
    
`` `'` 号的作用，当文件名出名特殊字符时，如 `.` 也能自动补全。``
        
        
### info, show

- info

    查看程序的信息。比如：info variables, info args, info breakpoint

- show

    查看 debugger(GDB 程序) 的信息。比如：show history

查看有关程序的信息

    info variables <REGEXP>
    info functions <REGEXP>
    info classes <REGEXP>
    info types <REGEXP>
    info locals
    info source
    info sources
    ...
	
### 操控程序的运行(start, run, continute, next, step, until, finish, return)

- step

    单步执行，遇到函数则进入

- next

    单步执行，遇到函数则步过（即一次执行完函数）
    next 过程中for init 部分与判断部分一起执行。

- contine

    从当前位置连续执行函数，直到遇到断点

- until

    除了不能加条件，参数与 break 相同。
    help 有比较好的说明。

- finish

    直到函数运行完成
        
启动程序并设置程序的参数

    {start | run} [paraments]
    show args
    
    c 语言只能从 main 开始调试，定义全局变量过程不能调试。但是 c++ 可以。
	
### breakpoint, watchpoint, catchpoint(disable, enable, delete)

- break
        break <location> [if <condition>]
        condition 很有用，比如在一个循环中调试。
        
        for example
            break 1 if i == 10 || i == 20
        
- watch, rwatch, awatch
        {watch, rwatch, awatch} <expr> [if (<condition>)]
            expr 必须是一个 <内存单元>
        
        注意:
            它们使用的符号不是表示固定的东西，根据作用域的不同可能会表示不同的东西。比如：符号重名。解决这个问题，将符号换为地址即可。符号消失时，watchpoint 会补自动删除。
            
            watch 是内存区域的值有改变时，才打断。而不是写这个单元就打断。
            watch <数组名>: 表示监控整个数组。而在 rwatch, awatch 中仅表示是一个字符，不代表是内存单元。
            
            char buf[1024];
            watch (long)*buf; watch *(long*)buf 有关区别的。`watch (long)*buf` 因为会先执行 `*buf` 所以不一定是 sizeof(long) 个字节的单元。

- catch
        当发生某些事件时，停止程序。
        catch syscall
            当发生系统调用时会停止程序。
        catch fork
        ...
    
`condition <breakpoint_num> [<expression> | <number>]`

> 编辑 breakpoint 的条件。
    
`command <breakpoint_num>`

> Set commands to be executed when a breakpoint is hit.	
	
### call

如果不调用某函数，而我们要调试，可用该指令调用函数，从而触发断点。
		
### 查看内存的信息(print, x, disassemble)

FMT is a repeat count followed by a format letter and a size letter.

print 的 FMT 只支持 format letter.

    format letter
        o(octal), x(hex), d(decimal), u(unsigned decimal),t(binary),...
    
    size letter
         b(byte), h(halfword), w(word), g(giant, 8 bytes)

- x

    查看内存。

        x /<count><o|x|d|u><b|h|w|g> <address>
            默认为小端模式
            
            x /2xb 0x555555554000
            x /2xh 0x555555554000
            
- set

    修改内存。

        set <process_variable> = <value>
        set args <program_args>
            还能修改程序的信息
				
### 栈

    info stack(与 backtrace 相同)
        查看有哪些栈帧
    info frame <n>
        查看栈帧的内容
    frame
        选择栈帧。可用于查看当前运行的位置。
			
### 查看哪些进程/线程，和选择操作

    info inferiors
    inferior
    {show | set} follow-fork-mode {parent | child}
        fork 之后跟踪父或子进程
    {show | set} detach-on-fork {on | off}
        fork 之后是否 detach 某个进程
    
    info threads
    thread
		
### 查看进程的信息

    info proc
    info line <n>
    
    info target（与 info files 相同）
    info vtbl EXPRESSION
        EXPRESSION 是代表一个 object.

    info symbol <addr>
        列出 <symbol + offset>。可用来查看地址与哪些符号相近，用于当不知地址在程序的位置时。
			
### shell

    shell nm <app> | c++filt | grep <regexp>

### core file

    generate-core-file  -- core file will be generate in working directory
    gdb <program> -c <core file>

    如果出现 Aborted (core dumped) 则表示产生 core 文件。

    程序死掉生成的 core 文件格式:
        /proc/sys/kernel/core_pattern

### log file

    set logging file [filename]
    set logging {on | off} 		// 只有打开 logging ，才会创建logging file 且 overwrite 和 redirect 才起作用。 

    set logging overwrite {on | off}
        Set whether logging overwrites or appends to the log file.
        If set, logging overrides the log file.

    set logging redirect {on | off}
            Set the logging output mode.
            If redirect is off, output will go to both the screen and the log file.		// 默认 off
            If redirect is on, output will go only to the log file.
    
### gdb script file

    source <gdbScript>
    gdb -x <gdbScript>
        
### others

    attach <pid>
    detach
    file <file_to_be_debuged>

## Examples

### basic

```c
#include <stdio.h>

int globalVar=100;
int globalArray[] = {1, 2};

void funcForFlow(int num) {
    if (num == 0) {
        printf("num == 0\n");
    } else if (num < 0) {
        printf("num == 0\n");
    } else {
        printf("num == 0\n");
    }

    for (int i = 0; i < 100; i++) {
        printf("%d\n", i);
    }
}

int main(int argc, char* argv[]) {
    funcForFlow(10);
    globalVar = 1000;
    globalArray[1] += 1;
    return 0;
}

```

```
### set args

# gdb a.out
set args=aa bb cc
show args

# gdb --args a.out aa bb cc
show args

start 
info args

### 查看源代码

list globalVar
list funcForFlow
list 6
list 6,25
list 6,+20

### breakpoint

break funcForFlow if num == 0 || num !=0
condition 1 num == 10
run

# 在循环中打断点
break 16 if i == 50
continute

### 切换栈
bt
frame 1

# 查看变量
info locals
print globalVar
print /x globalVar
print globalArray
print /x globalArray
print globalArray[1]

# 设置变量
set variable i = 90

until 16       # 执行一次循环
print i
until 18       # 直到退出循环

# 查看执行的位置
frame

# 删除所有 breakpoint
delete

### watchpoint

watch globalVar
watch gloablArray
watch *(int*) &globalVar
watch *(int*) globalArray@2
```

