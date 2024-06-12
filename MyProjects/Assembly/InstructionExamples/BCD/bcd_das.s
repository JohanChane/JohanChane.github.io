    .global bcd_das
    .section .text
bcd_das:
    push %ebp
    mov %esp, %ebp

    xor %esi, %esi
    mov 20(%ebp), %ecx
    clc
loop_das:
    mov 12(%ebp), %ebx          # operand_a
    mov (%ebx, %esi, 1), %al
    mov 16(%ebp), %ebx          # operand_a
    sbb (%ebx, %esi, 1), %al
    das

    mov 8(%ebp), %ebx           # difference
    mov %al, (%ebx, %esi, 1)

    inc %esi
    loop loop_das

    mov 8(%ebp), %ebx           # difference
    sbbb $0, (%ebx, %esi, 1)

    # ## print_byte_array
    sub $16 - 8 - 8, %esp
    mov 20(%ebp), %ebx  # size
    inc %ebx
    push %ebx
    push 8(%ebp)
    call print_byte_array
    add $16 - 8, %esp

    add $8, %esp
    leave
    ret
