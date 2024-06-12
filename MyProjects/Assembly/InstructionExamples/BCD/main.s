    .global operand_a
    .global operand_b

    .global main
    .section .text
main:
    push %ebp
    mov %esp, %ebp

    # ## bcd_aaa
    sub $16*2 - 8 - 16, %esp
    push $unpacked_operand_size
    push $unpacked_operand_b
    push $unpacked_operand_a
    push $sum_for_unppacked_operand
    call bcd_aaa
    add $16*2 - 8, %esp

    # ## bcd_aas
    sub $16*2 - 8 - 16, %esp
    push $unpacked_operand_size
    push $unpacked_operand_b
    push $unpacked_operand_a
    push $diff_for_unpacked_operand
    call bcd_aas
    add $16*2 - 8, %esp

    # ## bcd_daa
    sub $16*2 - 8 - 16, %esp
    push $packed_operand_size
    push $packed_operand_b
    push $packed_operand_a
    push $sum_for_packed_operand
    call bcd_daa
    add $16*2 - 8, %esp

    # ## bcd_das
    sub $16*2 - 8 - 16, %esp
    push $packed_operand_size
    push $packed_operand_b
    push $packed_operand_a
    push $diff_for_packed_operand
    call bcd_das
    add $16*2 - 8, %esp

    # ## bcd_aam
    sub $16 - 8, %esp
    call bcd_aam
    add $16 - 8, %esp

    # ## bcd_daa
    sub $16 - 8, %esp
    call bcd_aad
    add $16 - 8, %esp

    add $8, %esp
    xor %eax, %eax
    leave
    ret

    .section .data
unpacked_operand_a:
    .byte 0x04,  0x05, 0x05, 0x05, 0x05
    unpacked_operand_size = . - unpacked_operand_a

unpacked_operand_b:
    .byte 0x06, 0x05, 0x05, 0x05, 0x05

packed_operand_a:
    .byte 0x54, 0x55, 0x55
    packed_operand_size = . - packed_operand_a

packed_operand_b:
    .byte 0x56, 0x55, 0x55

    .section .bss
    .lcomm sum_for_unppacked_operand, unpacked_operand_size + 1
    .lcomm diff_for_unpacked_operand, unpacked_operand_size + 1

    .section .bss
    .lcomm sum_for_packed_operand, packed_operand_size + 1
    .lcomm diff_for_packed_operand, packed_operand_size + 1
