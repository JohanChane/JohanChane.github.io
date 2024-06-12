    .global main
    .section .text
main:
    movq $3, %rcx
l1:
    leaq array, %rbx
    movl -4(%rbx, %rcx, 4), %esi
    cmp $2, %esi
    loopne l1

    movq $formatd, %rdi
    xor %al, %al
    call printf

    xor %eax, %eax
    ret

.section .data
    formatd:
        .string "%d\n"

    array:
        .long 3, 2, 1
