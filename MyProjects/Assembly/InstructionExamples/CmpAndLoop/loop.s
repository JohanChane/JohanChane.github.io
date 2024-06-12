    .global main
    .section .text
main:
    movq $3, %rcx
l1:
    push %rcx

    leaq array, %rbx
    movl -4(%rbx, %rcx, 4), %esi
    movq $formatd, %rdi
    xor %al, %al
    call printf

    pop %rcx
    loop l1

    xor %eax, %eax
    ret

.section .data
    formatd:
        .string "%d\n"

    array:
        .long 1, 2, 3
