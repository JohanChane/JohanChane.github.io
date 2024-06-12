# Assembly

## Content

${toc}

## 说明

以 x86-64 GAS 为主。

## References

-   [GNU Assembler Examples](https://cs.lmu.edu/~ray/notes/gasexamples/)

## X86_64 的寄存器

See [x86寄存器](https://zh.wikipedia.org/wiki/X86#%E6%9A%AB%E5%AD%98%E5%99%A8%E7%B5%90%E6%A7%8B)

*不列出所有寄存器。*

通用寄存器（A, B, C and D）:

rax: eax, ax(ah, al)

指针寄存器（S and B）:

rsp: exp, sp, spl

索引寄存器（S and D）:

rdi: edi, di, dil

指令指针寄存器（I）:

rip: eip, ip

区段寄存器（C, D, S, E, F and G）:

cs, ds, ss, es, fs, gs

在64位模式新增的通用寄存器（R8, R9, R10, R11, R12, R13, R14, R15）:

r8: r8d, r8w, r8b

for example: `gdb: info registers` or `gdb: info all-registers`

```
rax            0x555555555139      93824992235833
rbx            0x7fffffffd4d8      140737488344280
rcx            0x555555557dd8      93824992247256
rdx            0x7fffffffd4e8      140737488344296
rsi            0x7fffffffd4d8      140737488344280
rdi            0x1                 1
rbp            0x7fffffffd3c0      0x7fffffffd3c0
rsp            0x7fffffffd3a0      0x7fffffffd3a0
r8             0x0                 0
r9             0x7ffff7fcd890      140737353930896
r10            0x7fffffffd0f0      140737488343280
r11            0x202               514
r12            0x0                 0
r13            0x7fffffffd4e8      140737488344296
r14            0x555555557dd8      93824992247256
r15            0x7ffff7ffd000      140737354125312
rip            0x55555555514c      0x55555555514c <main+19>
eflags         0x206               [ PF IF ]
cs             0x33                51
ss             0x2b                43
ds             0x0                 0
es             0x0                 0
fs             0x0                 0
gs             0x0                 0
```

### 寄存器的作用

```
dx, ax:
    cbw, cwd, mul, div, out, in
cx:
    loop, rep
bx:
    xlatb
si, di:
    movsb
bp:
    函数调用栈访问局部变量
sp:
    push, pop
```

xlatb: Locates a byte entry in a table in memory, using the contents of the AL register as a table index, then copies the contents of the table entry back into the AL register.

```
IF AddressSize = 16
    THEN
        AL ← (DS:BX + ZeroExtend(AL));
    ELSE IF (AddressSize = 32)
        AL ← (DS:EBX + ZeroExtend(AL)); FI;
    ELSE (AddressSize = 64)
        AL ← (RBX + ZeroExtend(AL));
FI;
```

## Flags

See [FLAGS register](https://en.wikipedia.org/wiki/FLAGS_register#FLAGS), [标志寄存器](https://baike.baidu.com/item/%E6%A0%87%E5%BF%97%E5%AF%84%E5%AD%98%E5%99%A8/5757541)

条件标志：

-   CF: 进位标志

    用于反映运算是否产生进位或借位。移位指令也会将操作数的最高位或最低位移入CF。

-   ZF: 零标志

    记录相关指令执行后，结果是否为 0。

-   SF: 符号标志

    用于反映运算结果的符号，运算结果为负，SF置1，否则置0。

-   OF: 溢出标志

    反映有符号数加减运算是否溢出。

-   PF: 奇偶标志

    用于反映运算结果低8位中“1”的个数。“1”的个数为偶数，则PF置1，否则置0。

    [What is the purpose of the Parity Flag on a CPU?](https://stackoverflow.com/a/25707223/10498412)

-   AF: 辅助进位标志

    算数操作结果的第三位（从0开始计数）如果产生了进位或者借位则将其置为1，否则置为0，常在BCD(binary-codedecimal)算术运算中被使用。

    ```
    # 第二位不超过 10，第三位超过。
    0b100  = 8
    0b1000 = 16
    ```

    [BCD 码的应用场景](https://zh.wikipedia.org/wiki/%E4%BA%8C%E9%80%B2%E7%A2%BC%E5%8D%81%E9%80%B2%E6%95%B8)

    > 这种编码技术，最常用于会计系统的设计里，因为会计制度经常需要对很长的数字做准确的计算。相对于一般的浮点式记数法，采用BCD码，既可保存数值的精确度，又可使电脑免除作浮点运算所耗费的时间。此外，对于其他需要高精确度的计算，BCD编码亦很常用。

控制标志：

-   TF: 跟踪标志

    当TF被设置为1时，CPU进入单步模式，所谓单步模式就是CPU在每执行一步指令后都产生一个单步中断。主要用于程序的调试。

-   IF: 中断标志

    决定CPU是否响应外部可屏蔽中断请求。IF为1时，CPU允许响应外部的可屏蔽中断请求。

-   DF: 方向标志

    决定串操作指令执行时有关指针寄存器调整方向。当DF为1时，串操作指令按递减方式改变有关存储器指针值，每次操作后使SI、DI递减。

### cmp 比较有符号数与无符号数

```
cmp a, b    # a - b

# ## unsigned
a = b   <=>     zf = 1
a > b   <=>     zf = 0 && cf = 0
a < b   <=>     cf = 1
a >= b  <=>     zf = 1 || cf = 0
a <= b  <=>     zf = 1 || cf = 1

# ## signed
a = b   <=>  zf = 1
a > b   <=>  sf = of (of = 0, sf = 0; of = 1, sf = 1)
a < b   <=>  sf != of (of = 0, sf = 1; of = 1, sf = 0)
a >= b  <=>  zf = 1 || sf = of
a <= b  <=>  zf = 1 || sf != of
```

#### 证明当 of = 1，逻辑结果与实际结果相反

以一个字节的有符号数举例。

logic:   -128, ...,  -1, 0, 1, ..., 127
real:     128, ..., 255, 0, 1, ..., 127

两个有符号数相减时溢出的情况：

logic:   -255, ..., -129, -128, ...,  -1, 0, 1, ..., 127, 128, ..., 255
real:       1, ...,  127,  128, ..., 255, 0, 1, ..., 127, 128, ..., 255

可以发现：logic[-255, -129] 的 real 的符号位是 1，而 logic[128, 255] 的 real 的符号位是 0。

### DF

```gas
    .global main
    .section .text
main:
    sub $8, %rsp

    #cld
    #movq $srcdata_len, %rcx
    #movq $srcdata, %rsi
    #movq $dstdata, %rdi
    #rep movsb

    std
    movq $srcdata_len, %rcx
    mov $srcdata + srcdata_len - 1, %rsi
    mov $dstdata + srcdata_len - 1, %rdi
    rep movsb
    cld

    movq $dstdata, %rdi
    call puts

    xor %eax, %eax
    add $8, %rsp
    ret

    .section .data
srcdata:
    .ascii "Foo Bar Baz Qux"
.set srcdata_len, . - srcdata

dstdata:
.rept srcdata_len
    .byte 'A'
.endr
    .byte 0x0
```

## Sections

-   .data section: 显式初始化的全局变量与静态变量。
-   .bss section: 非显式初始化的全局变量与静态变量。
-   .rodata section: 文字常量区
-   .text section: 代码

.data 与 .bss 的区别

> .bss section 的会初始化为 0, elf 文件也不用记录在 .bss section 数据的初值。当程序加载入内存时，在内存中申请一块内存，然后初始化为 0 即可。
>
> .data section 初始化是值是用户显示给的，存放在 elf 文件中。当程序加载入内存时，直接用 elf 文件的 .data section 来初始化即可。所以就是程序启动时，就已经初始化了。

[segment 与 section 区别:](https://stackoverflow.com/questions/14361248/whats-the-difference-of-section-and-segment-in-elf-file-format)

> segments 包含运行时的信息，而 sections 包含链接时的信息。从 `Section to Segment mapping（00, 01, 02, ... 一一对应 Program Headers 的 segments）` 可以看出它们的关系。

## ABI

See [application binary interface](https://zh.wikipedia.org/wiki/%E5%BA%94%E7%94%A8%E4%BA%8C%E8%BF%9B%E5%88%B6%E6%8E%A5%E5%8F%A3)

-   Call Conventions
-   System Call
-   数据类型的大小、布局和对齐。
-   以及在一个完整的操作系统ABI中，目标文件的二进制格式、程序库等等。

## Calling Conventions

Calling Conventions 用于用户函数传参。

如果函数的传参数与返回不统一则开发或使用都会混乱，所以有了 Calling Conventions 。

*当用高级语言调用函数时，根据编译器的不同，其调用规则也是不一样的。*

### x86-64

-   整数传参

    rdi, rsi, rdx, rcx, r8, r9, stack, stack, ...

-   浮点数传参

    xmm0-7, stack, stack, ...

-   传参给变长参数的函数时，要用 `al` 指针浮点数的数量。

-   在 `call` 之前, rsp 必须要对齐 16 个字节。

    刚进入函数时，因为要存储返回地址（rip），rsp 已经减 8 来存储返回地址了，所以 rsp 再减 8 即可对齐 16 个字节。

    *栈帧的开始是 rip。*

-   返回值

    rax/rdx:rax

    xmm0/xmm1:xmm0

### x86

-   用栈传参。参数从右到左依次进栈。
-   返回值在 eax
-   call 前，esp 要求对齐 16 个字节。

### call, ret

-   call：rip 进栈
-   ret: rip 出栈

8086:

-   call: ip 进栈，然后修改 ip。
-   callf: cs 进栈，ip 进栈，然后修改 cs, ip。
-   ret: ip 弹出到 ip。
-   retf: cs, ip 弹出到 cs, ip。

### leave

```gas
# leave
mov %rbp, %rsp
pop %rbp
```

for example

```gas
func:
    push %rbp       # 刚好 8 个字节，使得 rsp 对齐 16 个字节。
    mov %rsp, %rbp
    sub $16*1, %rsp,

    # do some jobs here
    mov (%rbp), %rax
    mov 8(%rbp), %bax
    ...

    # if need to return value
    modify <ax register>
    leave
    ret
```

### 与 C 结合

编译链接

```sh
gcc -c main.c add.s
gcc -o app -g -m64 -no-pie main.o add.o
```

main.c

```c
#include <stdio.h>
#include "add.h"

int main() {
    int a = 10;
    int b = 20;
    printf("%d\n", add(a, b));
    return 0;
}
```

add.h

```c
#pragma once
extern int add(int a, int b);
```

add.s

```gas
    .global add
    .section .text
add:
    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp

    movl %edi, -4(%rbp)
    movl %esi, -8(%rbp)
    movl -4(%rbp), %edx
    movl -8(%rbp), %eax
    addl %edx, %eax

    leave
    ret
```

## 系统调用和中断

*系统调用与函数调用不同，系统调用用 rax/eax 传 syscall_number。传参数用的规则也不一样。*

*x86, x86-64 syscall_number 不一样。*

### x86-64

-   传参

    rdi, rsi, rdx, r10, r8, r9, stack, stack, ...

-   返回值

    rax

-   保护的寄存器

    except %rax, %rcx, %r11, All other registers (including EFLAGS) are preserved

-   使用 `syscall` 进行系统调用

### x86

-   传参

    %ebx, %ecx, %edx, %esi, %edi, %ebp, stack, stack, ...

-   返回值

    eax

-   保护的寄存器

    except %rax, All other registers (including EFLAGS) are preserved

-   使用 `int 0x80` 进行系统调用

### 中断

8086

-   int

    1.  取中断类型码 n;
    2.  标志寄存器入栈，IF=O, TF=O;
    3.  RIP 入栈；
    4.  (IP)=(n*4), (CS)=(n*4+2) 。

-   iret

    1.  标志寄存器出栈，IF=O, TF=O;
    2.  cs 出栈，ip 出栈。

x86-64 是 rip（8 Bytes） 进栈。

## 指令格式

See [x86指令格式](https://zh.wikipedia.org/wiki/X86#x86%E6%8C%87%E4%BB%A4%E6%A0%BC%E5%BC%8F)

## 寻址方式

See [关于寻址方式一篇就够了](https://zhuanlan.zhihu.com/p/370204019)

-   隐含寻址

    指令不含有该操作数，但是默认操作数在某一个位置（比如：ACC）。

-   立即寻址

    指令含有该操作数。

-   直接寻址

    指令含有该操作数的内存地址

-   间接寻址

    指令含有一个内存地址，它的内容指向该操作数的内存地址。

-   寄存器寻址

    指令含有一个存放操作数的寄存器。

-   寄存器间接寻址

    指令含有一个存放操作数的内存地址的寄存器。

-   相对寻址

    ```
    base = pc
    num[ + n](%rbp)
    ```

-   基址寻址

    ```
    lable[ + n](%rip)
    offset(%rbp)
    ...
    ```

-   变址寻址

    ```
    # scale 为单元大小，index 为单元的下标, `label[ + n] 和 base` 决定单元组的起始位置。
    label[ +n](base, index, scale)
    ```

-   堆栈寻址

    offset(%rbp)
