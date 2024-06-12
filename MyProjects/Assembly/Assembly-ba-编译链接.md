# 编辑链接汇编程序

## 编译

```
# ## GAS
as [--32 | --64] <sourcefile> -o <objfile>
gcc [-m32 | -m64] -c <sourcefile> [-o <objfile>]

# ## NASM
nasm [-f {elf32 | elf64}] <sourcefile>
```

## 链接

gcc：

    # 注意：用 gcc 链接时，会额外链接一个 obj 文件，它包含 `_start`, 并会转到 main。其实 main 相当于 main 函数。所以 gcc 用来链接有 main 标签的汇编程序。
    gcc [-m32 | -m64 -no-pie] <objfile> -o <outfile>

ld:

    # 一般来链接有 `_start` 的汇编程序。
    # 如果用到标准库的东西则要加载动态库 `-lc`
    # ld 链接动态库时，要指定一个动态库链接器（其实也是一个动态库）。
    ld [-m elf_x86_64 --dynamic-linker=/lib64/ld-linux-x86-64.so.2 | -m elf_i386 --dynamic-linker=/lib/ld-linux.so.2] [-lc] <objfiles>
