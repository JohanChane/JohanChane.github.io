# PLT 和 GOT 的联系

## Content

${toc}

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

## 执行 printf 之前

过程：

> printf@plt -> printf@got.plt -> printf@plt<+6> -> 0x555555555020 -> .got （指出 printf 在 0x7ffff7fdb600，而 printf 实际在 0x7ffff7e06600）

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

```
(gdb) disas /sr 0x555555555030
Dump of assembler code for function printf@plt:
   0x0000555555555030 <+0>:	ff 25 ca 2f 00 00	jmp    *0x2fca(%rip)        # 0x555555558000 <printf@got.plt>
   0x0000555555555036 <+6>:	68 00 00 00 00	push   $0x0
   0x000055555555503b <+11>:	e9 e0 ff ff ff	jmp    0x555555555020
End of assembler dump.
```

```
(gdb) disas /sr 0x555555558000
Dump of assembler code for function printf@got.plt:
   0x0000555555558000 <+0>:	36 50	ss push %rax
   0x0000555555558002 <+2>:	55	push   %rbp
   0x0000555555558003 <+3>:	55	push   %rbp
   0x0000555555558004 <+4>:	55	push   %rbp
   0x0000555555558005 <+5>:	55	push   %rbp
   0x0000555555558006 <+6>:	00 00	add    %al,(%rax)
End of assembler dump.
```

跳回 print@plt<+6>

```
(gdb) disas /sr 0x0000555555555036
Dump of assembler code for function printf@plt:
   0x0000555555555030 <+0>:	ff 25 ca 2f 00 00	jmp    *0x2fca(%rip)        # 0x555555558000 <printf@got.plt>
   0x0000555555555036 <+6>:	68 00 00 00 00	push   $0x0
   0x000055555555503b <+11>:	e9 e0 ff ff ff	jmp    0x555555555020
End of assembler dump.
```

```
(gdb) disas /sr 0x555555555020,+16
Dump of assembler code from 0x555555555020 to 0x555555555030:
   0x0000555555555020:	ff 35 ca 2f 00 00	push   0x2fca(%rip)        # 0x555555557ff0
   0x0000555555555026:	ff 25 cc 2f 00 00	jmp    *0x2fcc(%rip)        # 0x555555557ff8
   0x000055555555502c:	0f 1f 40 00	nopl   0x0(%rax)
End of assembler dump.
```

```
(gdb) disas /sr 0x555555557ff8
Dump of assembler code for function _GLOBAL_OFFSET_TABLE_:
   0x0000555555557fe8:	e0 3d	loopne 0x555555558027 <gc+3>
   0x0000555555557fea:	00 00	add    %al,(%rax)
   0x0000555555557fec:	00 00	add    %al,(%rax)
   0x0000555555557fee:	00 00	add    %al,(%rax)
   0x0000555555557ff0:	c0 e2 ff	shl    $0xff,%dl
   0x0000555555557ff3:	f7 ff	idiv   %edi
   0x0000555555557ff5:	7f 00	jg     0x555555557ff7
   0x0000555555557ff7:	00 00	add    %al,(%rax)
   0x0000555555557ff9:	b6 fd	mov    $0xfd,%dh
   0x0000555555557ffb:	f7 ff	idiv   %edi
   0x0000555555557ffd:	7f 00	jg     0x555555557fff
   0x0000555555557fff:	00 36	add    %dh,(%rsi)
End of assembler dump.
```

printf 的函数体（显然不正确，因为还没有执行 printf。）

```
(gdb) disas /sr 0x00007ffff7fdb600,+100
Dump of assembler code from 0x7ffff7fdb600 to 0x7ffff7fdb664:
   0x00007ffff7fdb600:	f3 0f 1e fa	endbr64
   0x00007ffff7fdb604:	53	push   %rbx
   0x00007ffff7fdb605:	48 89 e3	mov    %rsp,%rbx
   0x00007ffff7fdb608:	48 83 e4 c0	and    $0xffffffffffffffc0,%rsp
   0x00007ffff7fdb60c:	48 2b 25 5d 16 02 00	sub    0x2165d(%rip),%rsp        # 0x7ffff7ffcc70 <_rtld_global_ro+432>
   0x00007ffff7fdb613:	48 89 04 24	mov    %rax,(%rsp)
   0x00007ffff7fdb617:	48 89 4c 24 08	mov    %rcx,0x8(%rsp)
   0x00007ffff7fdb61c:	48 89 54 24 10	mov    %rdx,0x10(%rsp)
   0x00007ffff7fdb621:	48 89 74 24 18	mov    %rsi,0x18(%rsp)
   0x00007ffff7fdb626:	48 89 7c 24 20	mov    %rdi,0x20(%rsp)
   0x00007ffff7fdb62b:	4c 89 44 24 28	mov    %r8,0x28(%rsp)
   0x00007ffff7fdb630:	4c 89 4c 24 30	mov    %r9,0x30(%rsp)
   0x00007ffff7fdb635:	b8 ee 00 00 00	mov    $0xee,%eax
   0x00007ffff7fdb63a:	31 d2	xor    %edx,%edx
   0x00007ffff7fdb63c:	48 89 94 24 40 02 00 00	mov    %rdx,0x240(%rsp)
   0x00007ffff7fdb644:	48 89 94 24 48 02 00 00	mov    %rdx,0x248(%rsp)
   0x00007ffff7fdb64c:	48 89 94 24 50 02 00 00	mov    %rdx,0x250(%rsp)
   0x00007ffff7fdb654:	48 89 94 24 58 02 00 00	mov    %rdx,0x258(%rsp)
   0x00007ffff7fdb65c:	48 89 94 24 60 02 00 00	mov    %rdx,0x260(%rsp)
End of assembler dump.
```

printf 的函数体

```
(gdb) print printf
$2 = {<text variable, no debug info>} 0x7ffff7e06600 <printf>

(gdb) disassemble /sr 0x7ffff7e06600
Dump of assembler code for function printf:
   0x00007ffff7e06600 <+0>:	f3 0f 1e fa	endbr64
   0x00007ffff7e06604 <+4>:	48 81 ec d8 00 00 00	sub    $0xd8,%rsp
   0x00007ffff7e0660b <+11>:	48 89 74 24 28	mov    %rsi,0x28(%rsp)
   0x00007ffff7e06610 <+16>:	48 89 54 24 30	mov    %rdx,0x30(%rsp)
   0x00007ffff7e06615 <+21>:	48 89 4c 24 38	mov    %rcx,0x38(%rsp)
   0x00007ffff7e0661a <+26>:	4c 89 44 24 40	mov    %r8,0x40(%rsp)
   0x00007ffff7e0661f <+31>:	4c 89 4c 24 48	mov    %r9,0x48(%rsp)
   0x00007ffff7e06624 <+36>:	84 c0	test   %al,%al
   0x00007ffff7e06626 <+38>:	74 37	je     0x7ffff7e0665f <printf+95>
   0x00007ffff7e06628 <+40>:	0f 29 44 24 50	movaps %xmm0,0x50(%rsp)
   0x00007ffff7e0662d <+45>:	0f 29 4c 24 60	movaps %xmm1,0x60(%rsp)
   0x00007ffff7e06632 <+50>:	0f 29 54 24 70	movaps %xmm2,0x70(%rsp)
   0x00007ffff7e06637 <+55>:	0f 29 9c 24 80 00 00 00	movaps %xmm3,0x80(%rsp)
   0x00007ffff7e0663f <+63>:	0f 29 a4 24 90 00 00 00	movaps %xmm4,0x90(%rsp)
   0x00007ffff7e06647 <+71>:	0f 29 ac 24 a0 00 00 00	movaps %xmm5,0xa0(%rsp)
   0x00007ffff7e0664f <+79>:	0f 29 b4 24 b0 00 00 00	movaps %xmm6,0xb0(%rsp)
   0x00007ffff7e06657 <+87>:	0f 29 bc 24 c0 00 00 00	movaps %xmm7,0xc0(%rsp)
```

printf 的相关位置

    # print@plt
    0x555555555000     0x555555556000     0x1000     0x1000  r-xp   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
    # printf@got.plt
    0x555555558000     0x555555559000     0x1000     0x3000  rw-p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
    # .got
    0x555555557000     0x555555558000     0x1000     0x2000  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
    # printf 的位置
    0x7ffff7dd9000     0x7ffff7f34000   0x15b000    0x22000  r-xp   /usr/lib/libc.so.6

```
(gdb) info proc mapping
Mapped address spaces:

          Start Addr           End Addr       Size     Offset  Perms  objfile
      0x555555554000     0x555555555000     0x1000        0x0  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555555000     0x555555556000     0x1000     0x1000  r-xp   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555556000     0x555555557000     0x1000     0x2000  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555557000     0x555555558000     0x1000     0x2000  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555558000     0x555555559000     0x1000     0x3000  rw-p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x7ffff7db4000     0x7ffff7db7000     0x3000        0x0  rw-p
      0x7ffff7db7000     0x7ffff7dd9000    0x22000        0x0  r--p   /usr/lib/libc.so.6
      0x7ffff7dd9000     0x7ffff7f34000   0x15b000    0x22000  r-xp   /usr/lib/libc.so.6
      0x7ffff7f34000     0x7ffff7f87000    0x53000   0x17d000  r--p   /usr/lib/libc.so.6
      0x7ffff7f87000     0x7ffff7f88000     0x1000   0x1d0000  ---p   /usr/lib/libc.so.6
      0x7ffff7f88000     0x7ffff7f8c000     0x4000   0x1d0000  r--p   /usr/lib/libc.so.6
      0x7ffff7f8c000     0x7ffff7f8e000     0x2000   0x1d4000  rw-p   /usr/lib/libc.so.6
      0x7ffff7f8e000     0x7ffff7f9b000     0xd000        0x0  rw-p
      0x7ffff7fc1000     0x7ffff7fc3000     0x2000        0x0  rw-p
      0x7ffff7fc3000     0x7ffff7fc7000     0x4000        0x0  r--p   [vvar]
      0x7ffff7fc7000     0x7ffff7fc9000     0x2000        0x0  r-xp   [vdso]
      0x7ffff7fc9000     0x7ffff7fca000     0x1000        0x0  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7fca000     0x7ffff7ff0000    0x26000     0x1000  r-xp   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ff0000     0x7ffff7ffa000     0xa000    0x27000  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ffb000     0x7ffff7ffd000     0x2000    0x31000  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ffd000     0x7ffff7fff000     0x2000    0x33000  rw-p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffffffdd000     0x7ffffffff000    0x22000        0x0  rw-p   [stack]
  0xffffffffff600000 0xffffffffff601000     0x1000        0x0  --xp   [vsyscall]
```

查看文件地址对应的内存地址：

    # base address: 0x555555554000
    # 0x555555555020 - 0x555555554000 = 0x1021
    [12]     0x555555555020->0x555555555040 at 0x00001020: .plt ALLOC LOAD READONLY CODE HAS_CONTENTS

```
(gdb) maintenance info sections
Exec file: `/d/mf/MyWorkspace/src/SourceProjects/C/out_/app', file type elf64-x86-64.
 [0]      0x555555554318->0x555555554334 at 0x00000318: .interp ALLOC LOAD READONLY DATA HAS_CONTENTS
 [1]      0x555555554338->0x555555554378 at 0x00000338: .note.gnu.property ALLOC LOAD READONLY DATA HAS_CONTENTS
 [2]      0x555555554378->0x55555555439c at 0x00000378: .note.gnu.build-id ALLOC LOAD READONLY DATA HAS_CONTENTS
 [3]      0x55555555439c->0x5555555543bc at 0x0000039c: .note.ABI-tag ALLOC LOAD READONLY DATA HAS_CONTENTS
 [4]      0x5555555543c0->0x5555555543dc at 0x000003c0: .gnu.hash ALLOC LOAD READONLY DATA HAS_CONTENTS
 [5]      0x5555555543e0->0x555555554488 at 0x000003e0: .dynsym ALLOC LOAD READONLY DATA HAS_CONTENTS
 [6]      0x555555554488->0x555555554517 at 0x00000488: .dynstr ALLOC LOAD READONLY DATA HAS_CONTENTS
 [7]      0x555555554518->0x555555554526 at 0x00000518: .gnu.version ALLOC LOAD READONLY DATA HAS_CONTENTS
 [8]      0x555555554528->0x555555554558 at 0x00000528: .gnu.version_r ALLOC LOAD READONLY DATA HAS_CONTENTS
 [9]      0x555555554558->0x555555554618 at 0x00000558: .rela.dyn ALLOC LOAD READONLY DATA HAS_CONTENTS
 [10]     0x555555554618->0x555555554630 at 0x00000618: .rela.plt ALLOC LOAD READONLY DATA HAS_CONTENTS
 [11]     0x555555555000->0x55555555501b at 0x00001000: .init ALLOC LOAD READONLY CODE HAS_CONTENTS
 [12]     0x555555555020->0x555555555040 at 0x00001020: .plt ALLOC LOAD READONLY CODE HAS_CONTENTS
 [13]     0x555555555040->0x55555555519a at 0x00001040: .text ALLOC LOAD READONLY CODE HAS_CONTENTS
 [14]     0x55555555519c->0x5555555551a9 at 0x0000119c: .fini ALLOC LOAD READONLY CODE HAS_CONTENTS
 [15]     0x555555556000->0x555555556008 at 0x00002000: .rodata ALLOC LOAD READONLY DATA HAS_CONTENTS
 [16]     0x555555556008->0x555555556034 at 0x00002008: .eh_frame_hdr ALLOC LOAD READONLY DATA HAS_CONTENTS
 [17]     0x555555556038->0x5555555560d4 at 0x00002038: .eh_frame ALLOC LOAD READONLY DATA HAS_CONTENTS
 [18]     0x555555557dd0->0x555555557dd8 at 0x00002dd0: .init_array ALLOC LOAD DATA HAS_CONTENTS
 [19]     0x555555557dd8->0x555555557de0 at 0x00002dd8: .fini_array ALLOC LOAD DATA HAS_CONTENTS
 [20]     0x555555557de0->0x555555557fc0 at 0x00002de0: .dynamic ALLOC LOAD DATA HAS_CONTENTS
 [21]     0x555555557fc0->0x555555557fe8 at 0x00002fc0: .got ALLOC LOAD DATA HAS_CONTENTS
 [22]     0x555555557fe8->0x555555558008 at 0x00002fe8: .got.plt ALLOC LOAD DATA HAS_CONTENTS
 [23]     0x555555558008->0x555555558020 at 0x00003008: .data ALLOC LOAD DATA HAS_CONTENTS
 [24]     0x555555558020->0x555555558028 at 0x00003020: .bss ALLOC
 [25]     0x00000000->0x0000001b at 0x00003020: .comment READONLY HAS_CONTENTS
 [26]     0x00000000->0x00000170 at 0x00003040: .debug_aranges READONLY HAS_CONTENTS
 [27]     0x00000000->0x0000075c at 0x000031b0: .debug_info READONLY HAS_CONTENTS
 [28]     0x00000000->0x000002cf at 0x0000390c: .debug_abbrev READONLY HAS_CONTENTS
 [29]     0x00000000->0x000002d8 at 0x00003bdb: .debug_line READONLY HAS_CONTENTS
--Type <RET> for more, q to quit, c to continue without paging--
 [30]     0x00000000->0x000004d5 at 0x00003eb3: .debug_str READONLY HAS_CONTENTS
 [31]     0x00000000->0x000001ab at 0x00004388: .debug_line_str READONLY HAS_CONTENTS
 [32]     0x00000000->0x00000042 at 0x00004533: .debug_rnglists READONLY HAS_CONTENTS
```

```
(gdb) maintenance info sections .plt
Exec file: `/d/mf/MyWorkspace/src/SourceProjects/C/out_/app', file type elf64-x86-64.
 [12]     0x555555555020->0x555555555040 at 0x00001020: .plt ALLOC LOAD READONLY CODE HAS_CONTENTS
```

```
Disassembly of section .plt:

0000000000001020 <printf@plt-0x10>:
    1020:	ff 35 ca 2f 00 00    	push   0x2fca(%rip)        # 3ff0 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 cc 2f 00 00    	jmp    *0x2fcc(%rip)        # 3ff8 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001030 <printf@plt>:
    1030:	ff 25 ca 2f 00 00    	jmp    *0x2fca(%rip)        # 4000 <printf@GLIBC_2.2.5>
    1036:	68 00 00 00 00       	push   $0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <_init+0x20>

```

查看已经加载的动态库：

```
(gdb) info sharedlibrary
From                To                  Syms Read   Shared Object Library
0x00007ffff7fca000  0x00007ffff7fefe85  Yes (*)     /lib64/ld-linux-x86-64.so.2
0x00007ffff7dd9440  0x00007ffff7f3205d  Yes (*)     /usr/lib/libc.so.6
(*): Shared library is missing debugging information.
```

## 执行 printf 之后

过程：

> printf@plt -> printf@got.plt（指出 printf 实际的位置）

发现 printf@plt 的内容不变，但是 printf@got.plt 的内容改变了。不再指向 printf@plt<+6> 而是指向 print 真正的地址。

```
(gdb) disas /sr 0x555555558000
Dump of assembler code for function printf@got.plt:
   0x0000555555558000 <+0>:	00 66 e0	add    %ah,-0x20(%rsi)
   0x0000555555558003 <+3>:	f7 ff	idiv   %edi
   0x0000555555558005 <+5>:	7f 00	jg     0x555555558007 <printf@got.plt+7>
   0x0000555555558007 <+7>:	00 00	add    %al,(%rax)
End of assembler dump.
```

```
(gdb) disas /sr 0x0000007ffff7e06600
Dump of assembler code for function printf:
   0x00007ffff7e06600 <+0>:	f3 0f 1e fa	endbr64
   0x00007ffff7e06604 <+4>:	48 81 ec d8 00 00 00	sub    $0xd8,%rsp
   0x00007ffff7e0660b <+11>:	48 89 74 24 28	mov    %rsi,0x28(%rsp)
   0x00007ffff7e06610 <+16>:	48 89 54 24 30	mov    %rdx,0x30(%rsp)
   0x00007ffff7e06615 <+21>:	48 89 4c 24 38	mov    %rcx,0x38(%rsp)
   0x00007ffff7e0661a <+26>:	4c 89 44 24 40	mov    %r8,0x40(%rsp)
   0x00007ffff7e0661f <+31>:	4c 89 4c 24 48	mov    %r9,0x48(%rsp)
   0x00007ffff7e06624 <+36>:	84 c0	test   %al,%al
   0x00007ffff7e06626 <+38>:	74 37	je     0x7ffff7e0665f <printf+95>
   0x00007ffff7e06628 <+40>:	0f 29 44 24 50	movaps %xmm0,0x50(%rsp)
   0x00007ffff7e0662d <+45>:	0f 29 4c 24 60	movaps %xmm1,0x60(%rsp)
   0x00007ffff7e06632 <+50>:	0f 29 54 24 70	movaps %xmm2,0x70(%rsp)
   0x00007ffff7e06637 <+55>:	0f 29 9c 24 80 00 00 00	movaps %xmm3,0x80(%rsp)
   0x00007ffff7e0663f <+63>:	0f 29 a4 24 90 00 00 00	movaps %xmm4,0x90(%rsp)
   0x00007ffff7e06647 <+71>:	0f 29 ac 24 a0 00 00 00	movaps %xmm5,0xa0(%rsp)
   0x00007ffff7e0664f <+79>:	0f 29 b4 24 b0 00 00 00	movaps %xmm6,0xb0(%rsp)
   0x00007ffff7e06657 <+87>:	0f 29 bc 24 c0 00 00 00	movaps %xmm7,0xc0(%rsp)
```

不变

```
(gdb) info sharedlibrary
From                To                  Syms Read   Shared Object Library
0x00007ffff7fca000  0x00007ffff7fefe85  Yes (*)     /lib64/ld-linux-x86-64.so.2
0x00007ffff7dd9440  0x00007ffff7f3205d  Yes (*)     /usr/lib/libc.so.6
(*): Shared library is missing debugging information.
```

不变

```
(gdb) info proc mappings
process 813704
Mapped address spaces:

          Start Addr           End Addr       Size     Offset  Perms  objfile
      0x555555554000     0x555555555000     0x1000        0x0  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555555000     0x555555556000     0x1000     0x1000  r-xp   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555556000     0x555555557000     0x1000     0x2000  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555557000     0x555555558000     0x1000     0x2000  r--p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555558000     0x555555559000     0x1000     0x3000  rw-p   /d/mf/MyWorkspace/src/SourceProjects/C/out_/app
      0x555555559000     0x55555557a000    0x21000        0x0  rw-p   [heap]
      0x7ffff7db4000     0x7ffff7db7000     0x3000        0x0  rw-p
      0x7ffff7db7000     0x7ffff7dd9000    0x22000        0x0  r--p   /usr/lib/libc.so.6
      0x7ffff7dd9000     0x7ffff7f34000   0x15b000    0x22000  r-xp   /usr/lib/libc.so.6
      0x7ffff7f34000     0x7ffff7f87000    0x53000   0x17d000  r--p   /usr/lib/libc.so.6
      0x7ffff7f87000     0x7ffff7f88000     0x1000   0x1d0000  ---p   /usr/lib/libc.so.6
      0x7ffff7f88000     0x7ffff7f8c000     0x4000   0x1d0000  r--p   /usr/lib/libc.so.6
      0x7ffff7f8c000     0x7ffff7f8e000     0x2000   0x1d4000  rw-p   /usr/lib/libc.so.6
      0x7ffff7f8e000     0x7ffff7f9b000     0xd000        0x0  rw-p
      0x7ffff7fc1000     0x7ffff7fc3000     0x2000        0x0  rw-p
      0x7ffff7fc3000     0x7ffff7fc7000     0x4000        0x0  r--p   [vvar]
      0x7ffff7fc7000     0x7ffff7fc9000     0x2000        0x0  r-xp   [vdso]
      0x7ffff7fc9000     0x7ffff7fca000     0x1000        0x0  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7fca000     0x7ffff7ff0000    0x26000     0x1000  r-xp   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ff0000     0x7ffff7ffa000     0xa000    0x27000  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ffb000     0x7ffff7ffd000     0x2000    0x31000  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ffd000     0x7ffff7fff000     0x2000    0x33000  rw-p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffffffdd000     0x7ffffffff000    0x22000        0x0  rw-p   [stack]
  0xffffffffff600000 0xffffffffff601000     0x1000        0x0  --xp   [vsyscall]
```
