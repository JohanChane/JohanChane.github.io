.global printf

.global main

.section .text
main:
    sub $8, %rsp

    # -0x10 * 2^4 = 2^8
    #   ax = al * operand
    movb $16, %bl
    movb $-0x10, %al
    imulb %bl

    movw %ax, %si
    movq $formathd, %rdi
    xor %rax, %rax
    call printf


    # -0x10 * 2^4 = 2^16
    movw $16, %bx
    movw $-0x1000, %ax
    imulw %bx

    movw %dx, %si
    movw %ax, %dx
    movq $format2hd, %rdi
    xor %rax, %rax
    call printf


    # -0x1000000000000000 * 2^4 = 2^64
    movq $16, %rbx
    movq $-0x1000000000000000, %rax
    imulq %rbx

    movq %rdx, %rsi
    movq %rax, %rdx
    movq $format2lld, %rdi
    xor %rax, %rax
    call printf

    add $8, %rsp

    xor %rax, %rax
    ret

.section .data
    formathd:
        .asciz "%hd\n"
    format2hd:
        .asciz "%hd, %hd\n"
    format2lld:
        .asciz "%lld, %lld\n"
.section .bss
