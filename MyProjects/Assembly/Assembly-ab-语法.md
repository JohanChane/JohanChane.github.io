# Assembly 语法

## Content

${toc}

## 说明

x64 GAS 语法。

## References

-   [Using as](https://sourceware.org/binutils/docs/as/index.html#SEC_Contents)

## Hello World

### `_start entry`

```gas
    .global _start

.section .text
_start:
    # ## sys_write(1, 1, message, msg_length)
    movq $msg_length, %rdx
    movq $message, %rsi
    movq $1, %rdi
    movq $1, %rax
    syscall

    # sys_exit(0)
    xor %rdi, %rdi
    mov $60, %rax
    syscall

.section .data
    message:
        .ascii "Hello, world!\n"
    msg_length = . - message
```

编译链接：

```sh
# 编译
as --64 main.s -o main.o
# 链接
ld -m elf_x86_64 --dynamic-linker=/lib64/ld-linux-x86-64.so.2 -lc main.o -o app
```

### main

```gas
    .global main

.section .text
main:
    # ## sys_write(1, message, msg_length)  // STDOUT_FILENO = 1
    movq $msg_length, %rdx
    movq $message, %rsi
    movq $1, %rdi
    movq $1, %rax
    syscall

    # ## return 0
    xor %rax, %rax
    ret

.section .data
    message:
        .ascii "Hello, world!\n"
    msg_length = . - message
```

```sh
gcc -m64 -c main.s -o main.o
gcc -m64 -no-pie main.o -o app
```

`_start, main` 的区别：

> `_start` 是程序入口。<br>
> 用 gcc 链接时，会额外链接一个 obj 文件，它包含 `_start`, 并会转到 main。其实 main 相当于 main 函数。<br>
> cpu 从 `_start` 开始运行，做完一系列准备工作（比如 main 的参数）后，才开始进入 main。

## 常量

See [Constants](https://sourceware.org/binutils/docs/as/Constants.html)


指令中 `$<label>` 表示 label 的地址，而 `<label>` 表示 label 处内存的内容。<br>
指令中 `$<num>` 表示常量，而 num 表示 num 作为地址的内存的内容。

```gas
"string"
[$]'c'         # char

[$]10
[$]0b1        # 二进制
[$]010
[$]0x10
[$]-0x10

10.1
101e-1
```

## 数据的定义

See [Assembler Directives](https://sourceware.org/binutils/docs/as/Pseudo-Ops.html)

```gas
    .section .rodata
format_hhd:
    .asciz "%hhd\n"
format_hd:
    .asciz "%hd\n"
format_d:
    .asciz "%d\n"
format_ld:
    .asciz "%ld\n"
format_lld:
    .asciz "%lld\n"

format_f:
    .asciz "%f\n"

    .section .data
byte:
    .byte 0x10, 0x20
word:
    .word 0x10, 0x20
long:
    .long 0x10, 0x20
quad:
    .quad 0x10, 0x20

str_asciz:
    .asciz "ABC"

str_ascii:
    .ascii "ABC"
    #str_ascii_len = . - str_ascii
    .byte 97, 0
str_string:
    .string "ABC"

double:
    .double 10.1, 20.2
float:
    .float 10.1, 20.2

    .section .text
print_hhd:
    push %rbp
    mov %rsp, %rbp
    sub $16*1, %rsp

    mov %dil, -1(%rbp)
    mov $format_hhd, %rdi
    mov -1(%rbp), %sil
    mov $0, %eax
    call printf

    leave
    ret

print_hd:
    push %rbp
    mov %rsp, %rbp
    sub $16*1, %rsp

    mov %di, -2(%rbp)
    mov $format_hd, %rdi
    mov -2(%rbp), %si
    mov $0, %eax
    call printf

    leave
    ret

print_d:
    push %rbp
    mov %rsp, %rbp
    sub $16*1, %rsp

    mov %edi, -4(%rbp)
    mov $format_d, %rdi
    mov -4(%rbp), %esi
    mov $0, %eax
    call printf

    leave
    ret

print_ld:
print_lld:
    push %rbp
    mov %rsp, %rbp
    sub $16*1, %rsp

    mov %rdi, -8(%rbp)
    mov $format_ld, %rdi
    mov -8(%rbp), %rsi
    mov $0, %eax
    call printf

    leave
    ret

print_f:
    sub $8, %rsp

    mov $format_f, %rdi
    mov $1, %eax
    call printf

    add $8, %rsp
    ret

    .globl main
    .section .text
main:
    sub $8, %rsp

    mov byte + 1, %dil
    call print_hhd

    mov word + 2, %di
    call print_hd

    mov long + 4, %edi
    call print_d

    mov quad + 8, %rdi
    call print_ld

    mov quad + 8, %rdi
    call print_lld

    mov $str_ascii, %rdi
    call puts
    mov $str_asciz, %rdi
    call puts
    mov $str_string, %rdi
    call puts

    movsd double + 8, %xmm0
    call print_f

    movss float + 4, %xmm0
    pxor %xmm1, %xmm1
	cvtss2sd %xmm0, %xmm1
	movq %xmm1, %xmm0
    call print_f

    xor %rax, %rax
    add $8, %rsp
    ret
```

```gas
1: byte
2: 2type, word, hword, short,
4: 4type, long, int
8: 8byte, quad
# octa-word: 8 个 word 为 16 byte
16: octa-word

4: float, single
8: double

ascii: 末尾不添加 '\0'.
asciz: 末尾添加 '\0'.
string, string8, string16, string32, string64: 末尾添加 '\0'.
```

### `.fill, .comm, .rep, <dot>`

```gas
# 大小和值是可选的。如果第二个逗号和value不存在，则value假定为零。
# 如果第一个逗号和后面的标记不存在，则假定大小为 1。
.fill <repeat>, <size>, <value>

# lcomm: Symbol is not declared global (see .global). comm is global?.
# 定义 <length> Bytes。
.lcomm | .comm <symbol>, <length>
```

for example

```gas
    .section .data
ldata_start:

    lbuffera:
        .fill 12, 4, 0

    lbuffer_r:
        .rept 3
            .byte 0x10, 'A'
        .endr

    .equ ldata_len, . - ldata_start
    # OR
    #ldata_len = . - ldata_start

    .section .bss
    .lcomm llocal_uninit_data, 24
    .comm luninit_data, 24

    .global main
    .section .text
main:
    .rept 3
        nop
    .endr

    xor %eax, %eax
    ret
```

## Memery Addressing

### Syntax

See [Memory References](https://sourceware.org/binutils/docs/as/i386_002dMemory.html)

An Intel syntax indirect memory reference of the form

    section:[base + index*scale + disp]

is translated into the AT&T syntax

    section:disp(base, index, scale)

其中base和index是**可选的 32 位基址和索引寄存器**，disp是可选的位移，而scale取值 **1、2、4 和 8**，乘以index以计算操作数的地址。如果未指定scale，则scale为 1。如果未指定 index，index 为 0。

    # scale 为单元大小，index 为单元的下标, `label[ + n] 和 base` 决定单元组的起始位置。
    label[ +n](base, index, scale)

基址寄存器：

-   rbp

    相对 rbp 寻址。

-   rip

    相对 rip 寻址。lable(%rip): 表示 lable 的有效地址。所以 $lable 不是一个固定值。

-   ...

for example：基址寄存器

```gas
    .section .data
long:
    .long 10, 20

    .section .rodata
format_d:
    .string "%d, %d\n"

    .global main
    .section .text
main:
    push %rbp
    mov %rsp, %rbp
    sub $16*1, %rsp

    mov $100, -4(%rbp)

    #mov $format_d, %rdi    # ok
    lea format_d(%rip), %rdi
    mov long + 4(%rip), %esi
    mov -4(%rbp), %edx
    xor %al, %al
    #call printf        # ok
    call printf

    xor %eax, %eax
    leave
    ret
```

for example：Memory Addressing

```gas
    .section .data
lbuffer:
    .long 10, 11, 12, 13

    .section .rodata
format_b:
    .string "%d\n"

    .global main
    .section .text
main:
    sub $8, %rsp

    mov $format_b, %rdi

    #mov lbuffer, %esi
    #mov lbuffer + 4, %esi

    #mov $12, %eax
    # Error: invalid operands (.data and *GAS `reg' section* sections) for `+'
    #mov lbuffer + %eax, %esi

    #mov (lbuffer), %esi             # lbuffer(0, 0, 1)

    #mov $12, %eax
    #mov lbuffer(, %eax, 4), %esi    # (0, base, scale).
    #mov lbuffer(%eax), %esi         # (base, 0, 1). 可以用上寄存器了。
    #mov lbuffer(, 4), %esi          # (0, 0, scale). scale 没有意义。
    #mov lbuffer(%eax, 4), %esi      # (base, 0, scale). scale 没有意义。

    # ## lbuffer

    mov $0, %eax
    call printf


    xor %eax, %eax
    add $8, %rsp
    ret
```

## PLT 和 GOT

See [ELF 的 plt 与 got](./ELF/ELF-ac-PLT和GOT的联系.md)

PLT: Procedure Linkage Table.

GOT: Global Offset Table

for example

```gas
    .section .data
long:
    .long 10

    .section .rodata
format_d:
    .string "%d\n"

    .global main
    .section .text
main:
    sub $8, %rsp

    mov $format_d, %edi
    mov long, %esi
    xor %al, %al
    #call printf     # ok
    call printf@plt

    xor %eax, %eax
    add $8, %rsp
    ret
```
