    .global bcd_daa
    .section .text
bcd_daa:
    push %ebp
    mov %esp, %ebp

    xor %esi, %esi
    mov 20(%ebp), %ecx  # size
    clc
loop_daa:
    mov 12(%ebp), %ebx  # operand_a
    mov (%ebx, %esi, 1), %al
    mov 16(%ebp), %ebx  # operand_b
    adc (%ebx, %esi, 1), %al
    daa

    mov 8(%ebp), %ebx   # sum
    mov %al, (%ebx, %esi, 1)

    inc %esi
    loop loop_daa

    # 因为结果比操作数多出了一位，所以不可能溢出
    mov 8(%ebp), %ebx   # sum
    adcb $0, (%ebx, %esi, 1)

    # ## print_byte_array
    mov 20(%ebp), %ebx  # size
    inc %ebx
    push %ebx
    push 8(%ebp)
    call print_byte_array

    leave
    ret