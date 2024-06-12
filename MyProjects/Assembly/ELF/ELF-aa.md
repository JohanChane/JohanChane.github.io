# Executable and Linkable Format (ELF)

## Content

${toc}

## References

-   `man 5 elf`

## Sections 的作用

See `man 5 elf: Various sections hold program and control information`.

-   .symtab：符号表。（与动态链接符号表相关。）
-   .strtab：字符表。存放字符名称。这些字符出现在符号表的 Name 字段。一般用于调试而不是用在运行时。
-   .dynsym：动态链接符号表。存放符号表中 `Ndx = UND` 的条目。表示需要动态链接的条目。
-   .dynstr：动态字符表。存储需要动态链接的符号的名称。这些字符出现在动态符号表的 Name 字段。
-   .dynamic: 保存动态链接信息。比如：有 `.dynsym, .strtab, .plt.got sections` 的位置。
-   `.rela<section_name>`：重定位表。用于符号重定位。比如：`.rela.text` 是 `.text` 的重定位表。
-   .got: Global Offset Table. 存放符号的真实地址。比如：`.got.plt` 存放 `.plt` 需要的真实地址。
-   .plt: Procedure Linkage Table. 用于中转跳转。指令先跳转到此处，此处跳转到 .got 表。

## Section Headers

-   Nr: Section 表的下标。
-   Name
-   Type：PROGBITS, DYNSYM, STRTAB, RELA, DYNAMIC, SYMTAB, STRTAB
-   Address：该 Section 在内存的位置。
-   Offset：该 Section 在文件的位置。
-   Align：Section 地址的对齐字节。

## Program header

-   Type：LOAD, DYNAMIC
-   Offset: 段在文件位置。
-   VirtAddr：段在虚拟内存的地址。
-   PhysAddr：段在内存的物理地址。
-   FileSiz：段的文件的大小。
-   MemSiz：段在内存的大小。
-   Flags：RWX
-   Align: 段地址在内存和文件的对齐字节。

## Section to Segment mapping

-   段的下标
-   段包含的 Sections（段的 Sections 都是相邻的。）

## 符号表

-   Num: 符号表的下标。
-   Value：符号值
-   Size：符号的大小。比如：`gdb: disas /sr main` 时，gdb 知道 main 的大小，从而显示出相应的区域。
-   Type：OBJECT, FUNC, SECTION, FILE
-   Bind: LOCAL（没有 global 的字符）, GLOBAL（有 global 的字符）, WEAK
-   Vis
-   Ndx：Section 的下标。表示符号所在 Section。UND 表示还有确定有哪个下标，这些字符一般是动态链接字符。
-   Name

## 重定位表

-   Offset: storage unit 在文件的位置。
-   Info
-   Type
-   Sym. Value
-   Sym. Name + Addend：符号名称与加数。如果是相对 PC 寻址，`rip（下条指令的位置）= Offset + A`。

## Dynamic Section

-   Tag
-   Type：NEEDED, STRTAB, STRSZ, SYMTAB, SYMENT, RELA, RELASZ, PLTGOT
-   Name/Value

    不同的类型是不同的值。比如：NEEDED 则是需要的 library。STRTAB 是 .dynstr 的地址，SYMTAB 是 .dynsym 的地址。

## 实例分析

```c
#include <stdio.h>
#include <unistd.h>

#include "add.h"
#include "data.h"

int main(int argc, char* argv[]) {
    gc = add(ga, gb);
    printf("%d\n", gc);

    return 0;
}
```

编译链接：

```sh
gcc -std=c11 -g -O0 -c src/add.c -o out/add.o
gcc -std=c11 -g -O0 -c src/data.c -o out/data.o
gcc -std=c11 -g -O0 -c src/main.c -o out/main.o
gcc -std=c11 -g -O0 out/add.o out/data.o out/main.o -o out/app
```

readelf -a app:

段的 Sections 都是相邻的。

```
Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .interp           PROGBITS         0000000000000318  00000318
       000000000000001c  0000000000000000   A       0     0     1
  [ 2] .note.gnu.pr[...] NOTE             0000000000000338  00000338
       0000000000000040  0000000000000000   A       0     0     8
  [ 3] .note.gnu.bu[...] NOTE             0000000000000378  00000378
       0000000000000024  0000000000000000   A       0     0     4
  [ 4] .note.ABI-tag     NOTE             000000000000039c  0000039c
       0000000000000020  0000000000000000   A       0     0     4
  [ 5] .gnu.hash         GNU_HASH         00000000000003c0  000003c0
       000000000000001c  0000000000000000   A       6     0     8
  [ 6] .dynsym           DYNSYM           00000000000003e0  000003e0
       00000000000000a8  0000000000000018   A       7     1     8
  [ 7] .dynstr           STRTAB           0000000000000488  00000488
       000000000000008f  0000000000000000   A       0     0     1
  [ 8] .gnu.version      VERSYM           0000000000000518  00000518
       000000000000000e  0000000000000002   A       6     0     2
  [ 9] .gnu.version_r    VERNEED          0000000000000528  00000528
       0000000000000030  0000000000000000   A       7     1     8
  [10] .rela.dyn         RELA             0000000000000558  00000558
       00000000000000c0  0000000000000018   A       6     0     8

       0000000000000018  0000000000000018  AI       6    23     8
  [12] .init             PROGBITS         0000000000001000  00001000
       000000000000001b  0000000000000000  AX       0     0     4
  [13] .plt              PROGBITS         0000000000001020  00001020
       0000000000000020  0000000000000010  AX       0     0     16
  [14] .text             PROGBITS         0000000000001040  00001040
       000000000000015a  0000000000000000  AX       0     0     16
  [15] .fini             PROGBITS         000000000000119c  0000119c
       000000000000000d  0000000000000000  AX       0     0     4
  [16] .rodata           PROGBITS         0000000000002000  00002000
       0000000000000008  0000000000000000   A       0     0     4
  [17] .eh_frame_hdr     PROGBITS         0000000000002008  00002008
       000000000000002c  0000000000000000   A       0     0     4
  [18] .eh_frame         PROGBITS         0000000000002038  00002038
       000000000000009c  0000000000000000   A       0     0     8
  [19] .init_array       INIT_ARRAY       0000000000003dd0  00002dd0
       0000000000000008  0000000000000008  WA       0     0     8
  [20] .fini_array       FINI_ARRAY       0000000000003dd8  00002dd8
       0000000000000008  0000000000000008  WA       0     0     8
  [21] .dynamic          DYNAMIC          0000000000003de0  00002de0
       00000000000001e0  0000000000000010  WA       7     0     8
  [22] .got              PROGBITS         0000000000003fc0  00002fc0
       0000000000000028  0000000000000008  WA       0     0     8
  [23] .got.plt          PROGBITS         0000000000003fe8  00002fe8
       0000000000000020  0000000000000008  WA       0     0     8
  [24] .data             PROGBITS         0000000000004008  00003008
       0000000000000018  0000000000000000  WA       0     0     8
  [25] .bss              NOBITS           0000000000004020  00003020
       0000000000000008  0000000000000000  WA       0     0     4
  [26] .comment          PROGBITS         0000000000000000  00003020
       000000000000001b  0000000000000001  MS       0     0     1
  [27] .debug_aranges    PROGBITS         0000000000000000  00003040
       0000000000000170  0000000000000000           0     0     16
  [28] .debug_info       PROGBITS         0000000000000000  000031b0
       000000000000075c  0000000000000000           0     0     1
  [29] .debug_abbrev     PROGBITS         0000000000000000  0000390c
       00000000000002cf  0000000000000000           0     0     1
  [30] .debug_line       PROGBITS         0000000000000000  00003bdb
       00000000000002d8  0000000000000000           0     0     1
  [31] .debug_str        PROGBITS         0000000000000000  00003eb3
       00000000000004d5  0000000000000001  MS       0     0     1
  [32] .debug_line_str   PROGBITS         0000000000000000  00004388
       00000000000001ab  0000000000000001  MS       0     0     1
  [33] .debug_rnglists   PROGBITS         0000000000000000  00004533
       0000000000000042  0000000000000000           0     0     1
  [34] .symtab           SYMTAB           0000000000000000  00004578
       0000000000000408  0000000000000018          35    21     8
  [35] .strtab           STRTAB           0000000000000000  00004980
       0000000000000200  0000000000000000           0     0     1
  [36] .shstrtab         STRTAB           0000000000000000  00004b80
       0000000000000176  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

There are no section groups in this file.

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  PHDR           0x0000000000000040 0x0000000000000040 0x0000000000000040
                 0x00000000000002d8 0x00000000000002d8  R      0x8
  INTERP         0x0000000000000318 0x0000000000000318 0x0000000000000318
                 0x000000000000001c 0x000000000000001c  R      0x1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
  LOAD           0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000630 0x0000000000000630  R      0x1000
  LOAD           0x0000000000001000 0x0000000000001000 0x0000000000001000
                 0x00000000000001a9 0x00000000000001a9  R E    0x1000
  LOAD           0x0000000000002000 0x0000000000002000 0x0000000000002000
                 0x00000000000000d4 0x00000000000000d4  R      0x1000
  LOAD           0x0000000000002dd0 0x0000000000003dd0 0x0000000000003dd0
                 0x0000000000000250 0x0000000000000258  RW     0x1000
  DYNAMIC        0x0000000000002de0 0x0000000000003de0 0x0000000000003de0
                 0x00000000000001e0 0x00000000000001e0  RW     0x8
  NOTE           0x0000000000000338 0x0000000000000338 0x0000000000000338
                 0x0000000000000040 0x0000000000000040  R      0x8
  NOTE           0x0000000000000378 0x0000000000000378 0x0000000000000378
                 0x0000000000000044 0x0000000000000044  R      0x4
  GNU_PROPERTY   0x0000000000000338 0x0000000000000338 0x0000000000000338
                 0x0000000000000040 0x0000000000000040  R      0x8
  GNU_EH_FRAME   0x0000000000002008 0x0000000000002008 0x0000000000002008
                 0x000000000000002c 0x000000000000002c  R      0x4
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW     0x10
  GNU_RELRO      0x0000000000002dd0 0x0000000000003dd0 0x0000000000003dd0
                 0x0000000000000230 0x0000000000000230  R      0x1

 Section to Segment mapping:
  Segment Sections...
   00
   01     .interp
   02     .interp .note.gnu.property .note.gnu.build-id .note.ABI-tag .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt
   03     .init .plt .text .fini
   04     .rodata .eh_frame_hdr .eh_frame
   05     .init_array .fini_array .dynamic .got .got.plt .data .bss
   06     .dynamic
   07     .note.gnu.property
   08     .note.gnu.build-id .note.ABI-tag
   09     .note.gnu.property
   10     .eh_frame_hdr
   11
   12     .init_array .fini_array .dynamic .got

```

.dynsym 的地址（SYMTAB）在 0x3e0，大小（SYMENT）是 24 字节。

```
Dynamic section at offset 0x2de0 contains 26 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000000c (INIT)               0x1000
 0x000000000000000d (FINI)               0x119c
 0x0000000000000019 (INIT_ARRAY)         0x3dd0
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x3dd8
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x3c0
 0x0000000000000005 (STRTAB)             0x488
 0x0000000000000006 (SYMTAB)             0x3e0
 0x000000000000000a (STRSZ)              143 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x3fe8
 0x0000000000000002 (PLTRELSZ)           24 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x618
 0x0000000000000007 (RELA)               0x558
 0x0000000000000008 (RELASZ)             192 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffb (FLAGS_1)            Flags: PIE
 0x000000006ffffffe (VERNEED)            0x528
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x518
 0x000000006ffffff9 (RELACOUNT)          3
 0x0000000000000000 (NULL)               0x0
```

.symtab 的 `Ndx = UND` 的条目都在 .dynsym。

```
Symbol table '.dynsym' contains 7 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND _[...]@GLIBC_2.34 (2)
     2: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterT[...]
     3: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND [...]@GLIBC_2.2.5 (3)
     4: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND __gmon_start__
     5: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_registerTMC[...]
     6: 0000000000000000     0 FUNC    WEAK   DEFAULT  UND [...]@GLIBC_2.2.5 (3)

Symbol table '.symtab' contains 43 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS abi-note.c
     2: 000000000000039c    32 OBJECT  LOCAL  DEFAULT    4 __abi_tag
     3: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS init.c
     4: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS crtstuff.c
     5: 0000000000001070     0 FUNC    LOCAL  DEFAULT   14 deregister_tm_clones
     6: 00000000000010a0     0 FUNC    LOCAL  DEFAULT   14 register_tm_clones
     7: 00000000000010e0     0 FUNC    LOCAL  DEFAULT   14 __do_global_dtors_aux
     8: 0000000000004020     1 OBJECT  LOCAL  DEFAULT   25 completed.0
     9: 0000000000003dd8     0 OBJECT  LOCAL  DEFAULT   20 __do_global_dtor[...]
    10: 0000000000001130     0 FUNC    LOCAL  DEFAULT   14 frame_dummy
    11: 0000000000003dd0     0 OBJECT  LOCAL  DEFAULT   19 __frame_dummy_in[...]
    12: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS add.c
    13: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS data.c
    14: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS main.c
    15: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS crtstuff.c
    16: 00000000000020d0     0 OBJECT  LOCAL  DEFAULT   18 __FRAME_END__
    17: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS
    18: 0000000000003de0     0 OBJECT  LOCAL  DEFAULT   21 _DYNAMIC
    19: 0000000000002008     0 NOTYPE  LOCAL  DEFAULT   17 __GNU_EH_FRAME_HDR
    20: 0000000000003fe8     0 OBJECT  LOCAL  DEFAULT   23 _GLOBAL_OFFSET_TABLE_
    21: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND __libc_start_mai[...]
    22: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterT[...]
    23: 0000000000004008     0 NOTYPE  WEAK   DEFAULT   24 data_start
    24: 0000000000001139    20 FUNC    GLOBAL DEFAULT   14 add
    25: 0000000000004020     0 NOTYPE  GLOBAL DEFAULT   24 _edata
    26: 0000000000004018     4 OBJECT  GLOBAL DEFAULT   24 ga
    27: 000000000000119c     0 FUNC    GLOBAL HIDDEN    15 _fini
    28: 0000000000004024     4 OBJECT  GLOBAL DEFAULT   25 gc
    29: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND printf@GLIBC_2.2.5
    30: 0000000000004008     0 NOTYPE  GLOBAL DEFAULT   24 __data_start
    31: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND __gmon_start__
    32: 0000000000004010     0 OBJECT  GLOBAL HIDDEN    24 __dso_handle
    33: 0000000000002000     4 OBJECT  GLOBAL DEFAULT   16 _IO_stdin_used
    34: 0000000000004028     0 NOTYPE  GLOBAL DEFAULT   25 _end
    35: 0000000000001040    38 FUNC    GLOBAL DEFAULT   14 _start
    36: 0000000000004020     0 NOTYPE  GLOBAL DEFAULT   25 __bss_start
    37: 000000000000114d    77 FUNC    GLOBAL DEFAULT   14 main
    38: 000000000000401c     4 OBJECT  GLOBAL DEFAULT   24 gb
    39: 0000000000004020     0 OBJECT  GLOBAL HIDDEN    24 __TMC_END__
    40: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_registerTMC[...]
    41: 0000000000000000     0 FUNC    WEAK   DEFAULT  UND __cxa_finalize@G[...]
    42: 0000000000001000     0 FUNC    GLOBAL HIDDEN    12 _init
```
