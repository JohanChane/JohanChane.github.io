.global printf

.global main

.section .text
main:
    sub $8, %rsp

    # 0x10 * 2^4 = 2^8
    #   ax = al * operand
    movb $16, %bl
    movb $0x10, %al
    mulb %bl

    movw %ax, %si
    movq $formathu, %rdi
    xor %rax, %rax
    call printf

    # 0x10 * 2^4 = 2^16
    #   (dx, ax) = ax * operand
    movw $16, %bx
    movw $0x1000, %ax
    mulw %bx

    movw %dx, %si
    movw %ax, %dx
    movq $format2hu, %rdi
    xor %rax, %rax
    call printf


    # 0x1000000000000000 * 2^4 = 2^64
    movq $16, %rbx
    movq $0x1000000000000000, %rax
    mulq %rbx

    movq %rdx, %rsi
    movq %rax, %rdx
    movq $format2llu, %rdi
    xor %rax, %rax
    call printf

    add $8, %rsp

    xor %rax, %rax
    ret

.section .data
    formathu:
        .asciz "%hu\n"
    format2hu:
        .asciz "%hu, %hu\n"
    format2llu:
        .asciz "%llu, %llu\n"
.section .bss
