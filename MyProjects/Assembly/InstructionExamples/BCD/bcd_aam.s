    .global bcd_aam
    .section .text
bcd_aam:
    push %ebp
    mov %esp, %ebp

    xor %esi, %esi

    mov operand_a(, %esi, 1), %al
    mulb operand_b(, %esi, 1)
    aam

    mov %al, product(, %esi, 1)
    inc %esi
    mov %ah, product(, %esi, 1)

    # ## print_byte_array
    push $operand_size + 1
    push $product
    call print_byte_array
    add $8, %esp

    leave
    ret

    .section .data
operand_a:
    .byte 0x08
    operand_size = . - operand_a

operand_b:
    .byte 0x09

    .section .bss
    .lcomm product, operand_size + 1
