    .global bcd_aad
    .section .text
bcd_aad:
    push %ebp
    mov %esp, %ebp

    xor %esi, %esi
    mov operand_a(, %esi, 1), %al
    inc %esi
    mov operand_a(, %esi, 1), %ah
    aad

    divb operand_b
    aam

    xor %edi, %edi
    mov %al, quotient(, %edi, 1)
    inc %edi
    mov %ah, quotient(, %edi, 1)

    # ## print_byte_array
    push $operand_size + 1
    push $quotient
    call print_byte_array
    add $8, %esp

    add $8, %esp
    leave
    ret

    .section .data
operand_a:
    .byte 0x02, 0x07
    operand_size = . - operand_a

operand_b:
    .byte 0x09

    .section .bss
    .lcomm quotient, operand_size + 1
