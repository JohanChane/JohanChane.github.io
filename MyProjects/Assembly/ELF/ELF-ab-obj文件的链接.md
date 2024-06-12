# obj 文件的链接

## Content

${toc}

## References

-   [System V Application Binary Interface AMD64 Architecture Processor Supplement](https://www.intel.com/content/dam/develop/external/us/en/documents/mpx-linux64-abi.pdf)

    搜索 `R_X86_64_PC32` 即可定位 `Table 4.9: Relocation Types`

## Relocation Types

    storage unit: 指令中存入跳转地址的部分。比如：jmp。

    A: Addend（pc 相对寻址时，与 storage unit 的大小的绝对值相同。）
    S: 符号值，即符号的位置。
    L: 在 .plt section 的符号的位置。有些跳转是先跳转到 .plt 再跳转到实际位置。比如：.plt 和 .got。
    P：storage unit 的位置。
    B: shared object 加载到内存的基址。一般是程序加载到内存的位置（info proc mapping）。
    X：storage unit 的值（个人定义）

不同类型的 storage unit 的值的计算：

-   R_X86_64_PC32

    X = S + A - P

-   R_X86_64_PLT32

    X = L + A - P

-   R_X86_64_RELATIVE

    X = B + A

-   R_X86_64_GLOB_DAT

    X = S

## 例子程序

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

## 链接前

objdump -DS main.o：

都使用 pc 相对寻址。

因为还没有链接，所以 storage unit 都为空。

```
int main(int argc, char* argv[]) {
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	89 7d fc             	mov    %edi,-0x4(%rbp)
   b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    gc = add(ga, gb);
   f:	8b 15 00 00 00 00    	mov    0x0(%rip),%edx        # 15 <main+0x15>
  15:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 1b <main+0x1b>
  1b:	89 d6                	mov    %edx,%esi
  1d:	89 c7                	mov    %eax,%edi
  1f:	e8 00 00 00 00       	call   24 <main+0x24>
  24:	89 05 00 00 00 00    	mov    %eax,0x0(%rip)        # 2a <main+0x2a>
    printf("%d\n", gc);
  2a:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 30 <main+0x30>
  30:	89 c6                	mov    %eax,%esi
  32:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 39 <main+0x39>
  39:	48 89 c7             	mov    %rax,%rdi
  3c:	b8 00 00 00 00       	mov    $0x0,%eax
  41:	e8 00 00 00 00       	call   46 <main+0x46>

    return 0;
  46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  4b:	c9                   	leave
  4c:	c3                   	ret

```

readelf -a main.o：

```
Relocation section '.rela.text' at offset 0x5a8 contains 7 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000000011  000a00000002 R_X86_64_PC32     0000000000000000 gb - 4
000000000017  000b00000002 R_X86_64_PC32     0000000000000000 ga - 4
000000000020  000c00000004 R_X86_64_PLT32    0000000000000000 add - 4
000000000026  000d00000002 R_X86_64_PC32     0000000000000000 gc - 4
00000000002c  000d00000002 R_X86_64_PC32     0000000000000000 gc - 4
000000000035  000300000002 R_X86_64_PC32     0000000000000000 .rodata - 4
000000000042  000e00000004 R_X86_64_PLT32    0000000000000000 printf - 4
```

因为还没有链接，所以符号的值都为空。

```
Symbol table '.symtab' contains 15 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS main.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    5 .rodata
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    6 .debug_info
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    8 .debug_abbrev
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT   11 .debug_line
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT   13 .debug_str
     8: 0000000000000000     0 SECTION LOCAL  DEFAULT   14 .debug_line_str
     9: 0000000000000000    77 FUNC    GLOBAL DEFAULT    1 main
    10: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND gb
    11: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND ga
    12: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND add
    13: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND gc
    14: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND printf
```

由上可知：

ga:

    X = S + A - P

    P = 0x17            // storage unit 的位置
    A = -4
    rip = P - A = 0x1B  // rip 表示执行此命令后，rip 的位置，即下一条指令的位置。
    # X 为 storage unit 的值。S 为符号的值，即符号的位置。
    因为要满足 (P - A) + X = rip + X = S，所以确定符号的值 S 就可以确定 X 的值。其实当链接完所有 sections 时，符号的值就确定了。

add:

    X = L + A - P

    P = 0x20
    A = -4
    rip = P - A = 0x1B
    要满足 rip + X = L

## 链接后

readelf -a app:

链接后，符号的值可以确定了。

```
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

objdump -DS app:

符号值确定后，storage unit 的值也可以确定了。

ga:

    # P 的值的相对 section 的，所以合并后 P 的值有改变。实际不需要 P 的值，知道 P - A 即可。
    # objdump 是小端模式。
    S = P - A + X = rip + X = 0x1168 + 0x00002eb0（补码） = 0x4018（补码）= 0x4018

add:

    # add 的实际跳转不是先跳到了 .plt 了，可能是编译器优化或者是 add 已经链接了的原因。
    L = P - A + X = rip + X = 0x1171 + 0xffffffc8（补码） = 0x00001139（补码）= 0x1139

```
int main(int argc, char* argv[]) {
    114d:	55                   	push   %rbp
    114e:	48 89 e5             	mov    %rsp,%rbp
    1151:	48 83 ec 10          	sub    $0x10,%rsp
    1155:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1158:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    gc = add(ga, gb);
    115c:	8b 15 ba 2e 00 00    	mov    0x2eba(%rip),%edx        # 401c <gb>
    1162:	8b 05 b0 2e 00 00    	mov    0x2eb0(%rip),%eax        # 4018 <ga>
    1168:	89 d6                	mov    %edx,%esi
    116a:	89 c7                	mov    %eax,%edi
    116c:	e8 c8 ff ff ff       	call   1139 <add>
    1171:	89 05 ad 2e 00 00    	mov    %eax,0x2ead(%rip)        # 4024 <gc>
    printf("%d\n", gc);
    1177:	8b 05 a7 2e 00 00    	mov    0x2ea7(%rip),%eax        # 4024 <gc>
    117d:	89 c6                	mov    %eax,%esi
    117f:	48 8d 05 7e 0e 00 00 	lea    0xe7e(%rip),%rax        # 2004 <_IO_stdin_used+0x4>
    1186:	48 89 c7             	mov    %rax,%rdi
    1189:	b8 00 00 00 00       	mov    $0x0,%eax
    118e:	e8 9d fe ff ff       	call   1030 <printf@plt>

    return 0;
    1193:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1198:	c9                   	leave
    1199:	c3                   	ret
```

readelf -a app:

```
Relocation section '.rela.plt' at offset 0x618 contains 1 entry:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000004000  000300000007 R_X86_64_JUMP_SLO 0000000000000000 printf@GLIBC_2.2.5 + 0
No processor specific unwind information to decode

```

objdump -DS app:

printf@GLIBC_2.2.5 的 offset 定位到 .got.plt。

```
Disassembly of section .got.plt:

0000000000003fe8 <_GLOBAL_OFFSET_TABLE_>:
    3fe8:	e0 3d                	loopne 4027 <gc+0x3>
	...
    3ffe:	00 00                	add    %al,(%rax)
    4000:	36 10 00             	ss adc %al,(%rax)
    4003:	00 00                	add    %al,(%rax)
    4005:	00 00                	add    %al,(%rax)
	...
```

由以上可知：

因为 storage unit 的值确定了，所以 `ga, gb, gc, add` 的重定位信息可以删除了。

只要 printf 的 .plt sections 相对于此命令的位置不变，则加载到内存时，storage unit 不变。

    118e:	e8 9d fe ff ff       	call   1030 <printf@plt>

因为 printf@GLIBC_2.2.5 的 offset 定位到 .got.plt，所以 .got.plt section 相对于 .plt section 的位置不变时，.plt 的内容不变，只修改 .got.plt 即可。

## 加载到内存

(gdb) disas /sr main

storage unit 都与末加载入内存时一样，未曾改变。

```
(gdb) disas /sr main
Dump of assembler code for function main:
src/main.c:
7	int main(int argc, char* argv[]) {
   0x000055555555514d <+0>:	55	push   %rbp
   0x000055555555514e <+1>:	48 89 e5	mov    %rsp,%rbp
   0x0000555555555151 <+4>:	48 83 ec 10	sub    $0x10,%rsp
   0x0000555555555155 <+8>:	89 7d fc	mov    %edi,-0x4(%rbp)
   0x0000555555555158 <+11>:	48 89 75 f0	mov    %rsi,-0x10(%rbp)

8	    gc = add(ga, gb);
=> 0x000055555555515c <+15>:	8b 15 ba 2e 00 00	mov    0x2eba(%rip),%edx        # 0x55555555801c <gb>
   0x0000555555555162 <+21>:	8b 05 b0 2e 00 00	mov    0x2eb0(%rip),%eax        # 0x555555558018 <ga>
   0x0000555555555168 <+27>:	89 d6	mov    %edx,%esi
   0x000055555555516a <+29>:	89 c7	mov    %eax,%edi
   0x000055555555516c <+31>:	e8 c8 ff ff ff	call   0x555555555139 <add>
   0x0000555555555171 <+36>:	89 05 ad 2e 00 00	mov    %eax,0x2ead(%rip)        # 0x555555558024 <gc>

9	    printf("%d\n", gc);
   0x0000555555555177 <+42>:	8b 05 a7 2e 00 00	mov    0x2ea7(%rip),%eax        # 0x555555558024 <gc>
   0x000055555555517d <+48>:	89 c6	mov    %eax,%esi
   0x000055555555517f <+50>:	48 8d 05 7e 0e 00 00	lea    0xe7e(%rip),%rax        # 0x555555556004
   0x0000555555555186 <+57>:	48 89 c7	mov    %rax,%rdi
   0x0000555555555189 <+60>:	b8 00 00 00 00	mov    $0x0,%eax
   0x000055555555518e <+65>:	e8 9d fe ff ff	call   0x555555555030 <printf@plt>

10
11	    return 0;
   0x0000555555555193 <+70>:	b8 00 00 00 00	mov    $0x0,%eax

12	}
   0x0000555555555198 <+75>:	c9	leave
   0x0000555555555199 <+76>:	c3	ret
End of assembler dump.
```

## R_X86_64_RELATIVE, R_X86_64_GLOB_DAT

readelf -a app:

    # 相差 0x8，则好一个 64 位的地址。000000003fc0 是 .got 的地址。
    000000003fc0
    000000003fc8
    000000003fd0
    000000003fd8
    000000003fe0

```
Relocation section '.rela.dyn' at offset 0x558 contains 8 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000003dd0  000000000008 R_X86_64_RELATIVE                    1130
000000003dd8  000000000008 R_X86_64_RELATIVE                    10e0
000000004010  000000000008 R_X86_64_RELATIVE                    4010
000000003fc0  000100000006 R_X86_64_GLOB_DAT 0000000000000000 __libc_start_main@GLIBC_2.34 + 0
000000003fc8  000200000006 R_X86_64_GLOB_DAT 0000000000000000 _ITM_deregisterTM[...] + 0
000000003fd0  000400000006 R_X86_64_GLOB_DAT 0000000000000000 __gmon_start__ + 0
000000003fd8  000500000006 R_X86_64_GLOB_DAT 0000000000000000 _ITM_registerTMCl[...] + 0
000000003fe0  000600000006 R_X86_64_GLOB_DAT 0000000000000000 __cxa_finalize@GLIBC_2.2.5 + 0
```

objdump -DS app:

    # __frame_dummy_init_array_entry
    000000003dd0: 1130

    __frame_dummy_init_array_entry -> frame_dummy

```
Disassembly of section .init_array:

0000000000003dd0 <__frame_dummy_init_array_entry>:
    3dd0:	30 11                	xor    %dl,(%rcx)
    3dd2:	00 00                	add    %al,(%rax)
    3dd4:	00 00                	add    %al,(%rax)
	...

0000000000001130 <frame_dummy>:
    1130:	f3 0f 1e fa          	endbr64
    1134:	e9 67 ff ff ff       	jmp    10a0 <register_tm_clones>

Disassembly of section .got:

0000000000003fc0 <.got>:
	...

Disassembly of section .got.plt:

0000000000003fe8 <_GLOBAL_OFFSET_TABLE_>:
    3fe8:	e0 3d                	loopne 4027 <gc+0x3>
	...
    3ffe:	00 00                	add    %al,(%rax)
    4000:	36 10 00             	ss adc %al,(%rax)
    4003:	00 00                	add    %al,(%rax)
    4005:	00 00                	add    %al,(%rax)
	...
```

gdb ./app:

    # __frame_dummy_init_array_entry
    # base address = 0x0000555555554000
    0x0000555555554000 + 0x1130 = 0x0000555555555130

```
(gdb) info proc mappings
process 2012124
Mapped address spaces:

          Start Addr           End Addr       Size     Offset  Perms  objfile
      0x555555554000     0x555555555000     0x1000        0x0  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555555000     0x555555556000     0x1000     0x1000  r-xp   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555556000     0x555555557000     0x1000     0x2000  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555557000     0x555555558000     0x1000     0x2000  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555558000     0x555555559000     0x1000     0x3000  rw-p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
```

```
(gdb) maintenance info sections .init_array
Exec file: `/d/mf/MyWorkspace/src/SourceProjects/C/out_/app', file type elf64-x86-64.
 [18]     0x555555557dd0->0x555555557dd8 at 0x00002dd0: .init_array ALLOC LOAD DATA HAS_CONTENTS
```

```
(gdb) disas /sr 0x555555557dd0
Dump of assembler code for function __frame_dummy_init_array_entry:
   0x0000555555557dd0:	30 51 55	xor    %dl,0x55(%rcx)
   0x0000555555557dd3:	55	push   %rbp
   0x0000555555557dd4:	55	push   %rbp
   0x0000555555557dd5:	55	push   %rbp
   0x0000555555557dd6:	00 00	add    %al,(%rax)
End of assembler dump.
```

```
(gdb) disas /sr 0x0000555555555130
Dump of assembler code for function frame_dummy:
   0x0000555555555130 <+0>:	f3 0f 1e fa	endbr64
   0x0000555555555134 <+4>:	e9 67 ff ff ff	jmp    0x5555555550a0 <register_tm_clones>
End of assembler dump.
```

xxd -g 2 -e app:

程序中的 .got 是 ascii 的。

```
00003fc0: 4545 504d 5f54 4942 0054 6f73 6b63 6461  EEMPT_BIT.sockad
00003fd0: 7264 6e5f 0073 6f6c 676e 6c20 6e6f 2067  dr_ns.long long
00003fe0: 6e69 0074 6f6c 676e 6c20 6e6f 2067 6e75  int.long long un
00003ff0: 6973 6e67 6465 6920 746e 5f00 755f 5f36  signed int.__u6_
00004000: 6461 7264 3631 5f00 755f 6e69 3874 745f  addr16.__uint8_t
00004010: 5200 4553 5f51 5343 465f 414c 5f47 4f4e  .RSEQ_CS_FLAG_NO
```

gdb ./app:

```
(gdb) maintenance info sections .got
Exec file: `/d/mf/MyWorkspace/src/SourceProjects/C/out_/app', file type elf64-x86-64.
 [21]     0x555555557fc0->0x555555557fe8 at 0x00002fc0: .got ALLOC LOAD DATA HAS_CONTENTS
```

程序中的 .got 与程序中的 .got 不同。至于中间的地址全是 0，不清楚原因。

```
(gdb) disas /sr 0x555555557fc0,0x555555557fe8
Dump of assembler code from 0x555555557fc0 to 0x555555557fe8:
   0x0000555555557fc0:	00 a3 dd f7 ff 7f	add    %ah,0x7ffff7dd(%rbx)
   0x0000555555557fc6:	00 00	add    %al,(%rax)
   0x0000555555557fc8:	00 00	add    %al,(%rax)
   0x0000555555557fca:	00 00	add    %al,(%rax)
   0x0000555555557fcc:	00 00	add    %al,(%rax)
   0x0000555555557fce:	00 00	add    %al,(%rax)
   0x0000555555557fd0:	00 00	add    %al,(%rax)
   0x0000555555557fd2:	00 00	add    %al,(%rax)
   0x0000555555557fd4:	00 00	add    %al,(%rax)
   0x0000555555557fd6:	00 00	add    %al,(%rax)
   0x0000555555557fd8:	00 00	add    %al,(%rax)
   0x0000555555557fda:	00 00	add    %al,(%rax)
   0x0000555555557fdc:	00 00	add    %al,(%rax)
   0x0000555555557fde:	00 00	add    %al,(%rax)
   0x0000555555557fe0:	60	(bad)
   0x0000555555557fe1:	18 df	sbb    %bl,%bh
   0x0000555555557fe3:	f7 ff	idiv   %edi
   0x0000555555557fe5:	7f 00	jg     0x555555557fe7
   0x0000555555557fe7:	00 e0	add    %ah,%al
End of assembler dump.
```

```
(gdb) disas /sr 0x007ffff7dda300
Dump of assembler code for function __libc_start_main:
   0x00007ffff7dda300 <+0>:	f3 0f 1e fa	endbr64
   0x00007ffff7dda304 <+4>:	41 57	push   %r15
   0x00007ffff7dda306 <+6>:	49 89 cf	mov    %rcx,%r15
   0x00007ffff7dda309 <+9>:	41 56	push   %r14
   0x00007ffff7dda30b <+11>:	41 55	push   %r13
   0x00007ffff7dda30d <+13>:	41 54	push   %r12
   0x00007ffff7dda30f <+15>:	55	push   %rbp
```

```
(gdb) disas /sr 0x007ffff7df1860
Dump of assembler code for function __cxa_finalize:
   0x00007ffff7df1860 <+0>:	f3 0f 1e fa	endbr64
   0x00007ffff7df1864 <+4>:	41 57	push   %r15
   0x00007ffff7df1866 <+6>:	31 c0	xor    %eax,%eax
   0x00007ffff7df1868 <+8>:	b9 01 00 00 00	mov    $0x1,%ecx
   0x00007ffff7df186d <+13>:	41 56	push   %r14
   0x00007ffff7df186f <+15>:	41 55	push   %r13
   0x00007ffff7df1871 <+17>:	41 54	push   %r12
   0x00007ffff7df1873 <+19>:	55	push   %rbp
```
