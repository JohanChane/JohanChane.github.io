# ELF 的相关工具

## Content

${toc}

## objdump, readelf

readelf 的 elf 信息比 objdump 全面，但是不能查看和反汇编源代码。而 objdump 可查看 elf 信息与查看和反汇编源代码。

```sh
objdump -DS
readelf -a

objdump -drs
objdump -x      # header 没有 readelf 全面。
```

## 查看文件

    # -e: 以小端模式显示。
    xxd -g <bytes> [-e]:
    od {--endian=big|litter} [-t x<bytes>]

## gdb

```
# 比 pmap 信息全面
info proc mappings
maintenance info sections [pattern]
info symbol <address | symbol>

# ## 查看内存
x /<n>xb <addr>

# ## disassembly
disassembly /sr <symbol | address>

# ## 查找符号（无法 print/disas 符号时）
info variables [pattern]
info functions [pattern]
# info symbol &_GLOBAL_OFFSET_TABLE_
info symbol &<symbol>
# disassembly section
info symbol <section>       # show section address.
disassembly /sr <start section addr> <end section addr>

# ## 查找字符串或数值
#x /s <addr>     # 显示地址的字符
find /b 0x555555554000,0x55555555484c,"Foo"
# 内存一般是用小端的。
find /w 0x000055555555514d, 0x0000555555555199, 0x0000000000

# ## 计算补码
# real -> 补
print /x (short)-1
# 补 -> real。
print /d (short)0xffff
```

## c++filt, nm

c++filt:

> c++ 或 java 的解码器。

```sh
nm <elf> | c++filt
objdump -S <elf> | c++filt
```
