.global printf

.global main

.section .text
main:
    sub $8, %rsp

    # al = ax / operand
    # ah = remainder
    #   ax 被除数，bl 除数, al 结果，ah 余数
    # -19 / 10
    movw $-19, %ax
    movb $10, %bl
    idivb %bl

    movw %ax, %bx
    xor %ah, %ah
    movw %ax, %dx

    movb %bh, %bl
    xor %bh, %bh
    movw %bx, %si

    movq $format2hhd, %rdi
    xor %rax, %rax
    call printf

    # ax = (dx, ax) / operand
    # dx = remainder

    # -19 / 10
    xor %dx, %dx
    not %dx
    movw $-19, %ax
    movw $10, %bx
    idivw %bx

    movw %dx, %si
    movw %ax, %dx
    mov $format2hd, %rdi
    xor %rax, %rax
    call printf

    add $8, %rsp

    xor %rax, %rax
    ret

.section .data
    format2hhd:
        .asciz "%hhd, %hhd\n"
    format2hd:
        .asciz "%hd, %hd\n"
.section .bss
