# Mix C and Assembly

## Content

${toc}

## 数组名与指针的区别

for example

```c
#include <stdio.h>
#include <stdlib.h>

// 两者访问方式的区别：前者直接访问内存。后者是间接寻址，先访问内存找到地址，再访问地址对应的内存。
int iarray[2] = {10, 20};
int* iarrayPtr = iarray;

int main(int argc, char* argv[]) {
    // movl	$100, iarray(%rip)
    iarray[0] = 100;
	// movq	iarrayPtr(%rip), %rax
	// movl	$100, (%rax)
    iarrayPtr[0] = 100;

    return 0;
}
```

## C 和 Assembly 相互访问（x64）

for example

```c
#include <stdio.h>
#include <stdlib.h>

extern int assembly_long_array[2];
//extern int* assembly_long_array;        // error. 前者直接访问内存，后者是间接寻址。
extern void func(int* i);

int main(int argc, char* argv[]) {
    // ## 修改汇编数组
    for (int i = 0; i < 2; i++) {
        assembly_long_array[i] *= 2;
    }
    for (int i = 0; i < 2; i++) {
        printf("%d\n", assembly_long_array[i]);
    }

    // ## 汇编修改 C 的数组
    int c_int_array[2];
    func(c_int_array);
    for (int i = 0; i < 2; i++) {
        printf("%d\n", c_int_array[i]);
    }

    return 0;
}
```

```gas
    .global assembly_long_array

    .global func
    .section .text
func:
    push %rbp
    mov %rsp, %rbp

    mov $10, (%rdi)
    mov $20, 4(%rdi)

    leave
    ret

    .section .data
assembly_long_array:
    .long 10, 20

    .section .bss
```

## C 和 Assembly 相互访问（x86）

for example

```c
#include <stdio.h>
#include <stdlib.h>

extern int assembly_long_array[2];
extern void func(int* i);

int main(int argc, char* argv[]) {
    // ## 修改汇编数组
    for (int i = 0; i < 2; i++) {
        assembly_long_array[i] *= 2;
    }
    for (int i = 0; i < 2; i++) {
        printf("%d\n", assembly_long_array[i]);
    }

    // ## 汇编修改 C 的数组
    int c_int_array[2];
    // 修改成功但是不能访问，不知原因。
    func(c_int_array);
    for (int i = 0; i < 2; i++) {
        printf("%d\n", c_int_array[i]);
    }

    return 0;
}
```

```gas
    .global assembly_long_array

    .global func
    .section .text
func:
    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %ebx
    movl $10, (%ebx)
    movl $20, 4(%ebx)

    leave
    ret

    .section .data
assembly_long_array:
    .long 10, 20
```
