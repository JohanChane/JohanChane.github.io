# Assembly Instructions

## Content

${toc}

## 说明

x86 的指令

## References

-   [x86 Assembly Language ReferenceManual](https://docs.oracle.com/cd/E53394_01/pdf/E54851.pdf)
-   [IA-32 Assembly Language Reference Manual](https://docs.oracle.com/cd/E19455-01/806-3773/index.html)
-   [x86 and amd64 instruction reference（比较详细）](https://www.felixcloutier.com/x86/)

## 数据转移

```
MOV

LDS: Load memory double word into word register and DS
LES: Load memory double word into word register and ES

LODSB: Load byte at DS:[SI] into AL
LODSW
STOSB: Store byte in AL into ES:[DI]
STOSW

XCHG: Exchange

OUT [port] {AX | AL}
IN
```

## 符号扩展与零扩展

```gas
movsb{w|l|q}, movsw{l|q}: move and sign extend
movzb{w|l|q}, movzw{l|q}: move and zero extend
```

for example

```gas
movsbq %al, %rbx
```

#### 寄存器的有符号扩展

```gas
cbtw: sign-extend AL -> AX。
cwtl: sign-extend AX -> EAX
cwtd: sign-extend AX -> DX:AX
cltd: sign-extend EAX -> EDX:EAX
```

### 扩展浮点数

```gas
mov <format>, %rdi
movss <float>, %xmm0
pxor %xmm1, %xmm1       # 宽字节 xor
# convert scalar single-precision floating-point values to scalar double-precision floating-point values
cvtss2sd %xmm0, %xmm1
movq %xmm1, %xmm0
call printf
```

## 移位

### 逻辑移动与算术移位

逻辑移动时，空位补 0。

算术左移时，尾部补0，最高的符号位保持不变。<br>
算术右移时，尾部丢失，符号位右移后，原位置上复制一个符号位。

逻辑移动，用于无符号数。算术移动，用于有符号数。

for example

```gas
# shift logical left/right
shl, shr
# shift arithmetic left/right
sal, sar
```

for example

```gas
    .global main
    .section .text
main:
    sub $8, %rsp

    # ## 逻辑移动
    mov $10, %eax
    shl $1, %eax
    mov %eax, %edi
    call print_d

    mov $10, %eax
    shr $1, %eax
    mov %eax, %edi
    call print_d

    # ## 算术移动
    mov $-10, %eax
    sal $1, %eax
    mov %eax, %edi
    call print_d

    mov $-10, %eax
    sar $1, %eax
    mov %eax, %edi
    call print_d

    xor %eax, %eax
    add $8, %rsp
    ret

print_d:
    sub $8, %rsp

    mov %edi, %esi
    mov $format_d, %rdi
    xor %al, %al
    call printf

    add $8, %rsp
    ret

    .section .rodata
format_d:
    .string "%d\n"
```

### 循环移位和 CF 移位

```
ROL: rotate left
    # 循环移位
    CF = 移除位
    新增位 = 移除位
ROR:
    # 循环移位
    CF = 移除位
    新增位 = 移除位

RCL: rotate, cf, left
    新增位 = CF
    CF = 移除位
RCR:
    新增位 = CF
    CF = 移除位
```

## 字符串指令

```gas
movs{q}:        move string
movsb:          move byte string. movsb is not movsb{wlq}.
movsw, smovw:   move word string
movsl, smovl:   move doubleword string

cmps{q}:        compare string
cmpsb:          compare byte string
cmpsl:          compare doubleword string
cmpsw:          compare word string
```

## Jump, Cmp, Loop, Rep

### Cmp

```
# The CF, OF, SF, ZF, AF, and PF flags are set according to the result.
cmp
# 相当于 and 指令，但是不存储结果。
test

scasb: Compare bytes: AL from ES:[DI].
scasw:
cmpsb: Compare bytes: ES:[DI] from DS:[SI]
cmpsw:
```

### Jump

```gas
# ## 根据大小比较跳转
# signed/Unsigned: equal
# Unsigned: above, below
# signed: greater, less than
#j[n]e
#j[n]{a | b}[e]
#j[n]{g | l}[e]

# unsigned
jb, ja
# signed
jl, jg
# signed/unsigned
je/jz

# ## 根据标志位跳转
# ### zero
JZ
JNZ

# ### signed
JS
JNS

# ## carry
JC
JNC

# ## overflow
JO
JNO

# ### parity: even(1)/odd(0:奇)
JP/JPE      # PF = 1
JNP/JPO     # PF = 0

# ## 根据 cx 跳转
jcxz    # cx
jecxz   # ecx
```

### Loop

```
loop        # ecx != 0, jmp。
loop{e|z}   # ecx != 0 && ZF = 1, jmp。
loopn{e|z}  # ecx != 0 && ZF = 0, jmp。
```

### Rep

```
rep: Repeat following MOVSB, MOVSW, LODSB, LODSW, STOSB, STOSW instructions CX times.
rep{e|z}
repn{e|z}
```

## Flag Control (EFLAG) Instructions

```gas
# carry, direction, interrupt
cl{c|d|i}
st{c|d|i}

pushf{w|l|q}
popf{w|l|q}
lahf    # load flags into %ah
sahf    # restore %ah into flags
```

for example

```gas
    .global main
    .section .text
main:
    #sub $8, %rsp

    pushfq

    #stc
    #std
    #sti
    lahf
    mov %ah, %bl
    mov %bl, %dil
    call print_hhx
    sahf

    popfq

    xor %eax, %eax
    #add $8, %rsp
    ret

print_hhx:
    sub $8, %rsp

    mov %dil, %sil
    mov $format_hhx, %rdi
    xor %al, %al
    call printf

    add $8, %rsp
    ret

    .section .rodata
format_hhx:
    .string "%hhb\n"
```

## 逻辑运算

	AND, OR, NOT, XOR

## 算术运算

```
add
sub
mul
div

sbb: substract, borrow
adc: Add with Carry.

dec: decrement
inc: increment

idiv: Signed divide
imul: Signed Multiplication

neg: 算术取负
```

mul/imul

```
when operand is a byte:
    AX = AL * operand.
when operand is a word:
    (DX AX) = AX * operand
```

div/idiv

```
when operand is a byte:
    AL = AX / operand
    AH = remainder (modulus)
when operand is a word:
    AX = (DX AX) / operand
    DX = remainder (modulus)
```

## BCD

-   AAA：ASCII Adjust after Addition.

    Unpacked BCD addition

    操作数是一位数字用一个字节存储。用 AAA 调整两个操作数的和后，将和的十位放在 ah, 个位放在 al, 有进位则 CF = 1, AF = 1。

    ```
    if low nibble of AL > 9 or AF = 1 then:
        AL = AL + 6
        AH = AH + 1
        AF = 1
        CF = 1
    else
        AF = 0
        CF = 0
    ```

-   AAS: ASCII Adjust after Subtraction.

    Unpacked BCD subtraction

    与 AAA 类似。

-   DAA: Decimal adjust After Addition.

    packed BCD Addition

    操作数是一位数字用半字节存储（高 4 位放十位，低 4 位放个位），所以一个字节表示一个两位数字的操作数。用 DAA 调整两个操作数的和后，将和放在 al（高 4 位放十位，低 4 位放个位），有十位有进位则 CF = 1，个位有进位则 AF = 1。

    ```
    if low nibble of AL > 9 or AF = 1 then:
        AL = AL + 6
        AF = 1
    if AL > 9Fh or CF = 1 then:
        AL = AL + 60h
        CF = 1
    ```

-   DAS: Decimal adjust After Subtraction.

    packed BCD Decimal

    与 DAA 类似。

-   AAM: ASCII Adjust after Multiplication.

    操作数是一位数字用一个字节存储。用 AAA 调整两个操作数的积后，将积的十位放在 ah, 个位放在 al。

    ```
    AH = AL / 10
    AL = remainder
    ```

-   AAD: ASCII Adjust before Division. BCD values

    操作数是一位数字用一个字节存储。用 AAD 合并一个操作数的十位和个位后，将结果的十位放在 al。

    ```
    AL = (AH * 10) + AL
    AH = 0
    ```

## jmp

See [jmp](https://www.felixcloutier.com/x86/jmp)

```gas
    .section .data
str:
    .string "Foo"

print_addr:
    .quad 0x0, 0x0

    .global main
    .section .text
main:
    sub $8, %rsp

    lea print, %rax
    mov %rax, print_addr + 4

    # ## 直接寻址
    #jmp print

    # ## 间接寻址
    # Error: unsupported syntax for `jmp'
    #jmp $print_addr + 4
    #jmp *print_addr + 4     # ok
    jmp *(print_addr + 4)

exit:
    xor %eax, %eax
    add $8, %rsp
    ret

print:
    sub $8, %rsp

    mov $str, %rdi
    call puts

    add $8, %rsp
    jmp exit
```

## lea

取址

for example

```gas
func:
    ...
func_addr:
    .quad 0x0

lea long, %rax
mov %rax, func_addr
jmp *func_addr
```

