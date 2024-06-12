.global printf

.global main

.section .text
main:
    sub $8, %rsp

    # al = ax / operand
    # ah = remainder
    #   ax 被除数，bl 除数, al 结果，ah 余数
    # 19 / 10
    movw $19, %ax
    movb $10, %bl
    divb %bl

    movw %ax, %bx
    xor %ah, %ah
    movw %ax, %dx

    movb %bh, %bl
    xor %bh, %bh
    movw %bx, %si

    movq $format2hhu, %rdi
    xor %rax, %rax
    call printf

    # ax = (dx, ax) / operand
    # dx = remainder

    # 19 / 10
    xor %dx, %dx
    movw $19, %ax
    movw $10, %bx
    divw %bx

    movw %dx, %si
    movw %ax, %dx
    mov $format2hu, %rdi
    xor %rax, %rax
    call printf

    add $8, %rsp

    xor %rax, %rax
    ret

.section .data
    format2hhu:
        .asciz "%hhu, %hhu\n"
    format2hu:
        .asciz "%hu, %hu\n"
.section .bss
