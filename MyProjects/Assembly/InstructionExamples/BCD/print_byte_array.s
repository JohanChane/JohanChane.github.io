    .global print_byte_array
    .section .text
print_byte_array:
    push %ebp
    mov %esp, %ebp

    mov 12(%ebp), %ecx
    xor %esi, %esi
loop_print_hhx:
    push %ecx

    # ## print_hhx
    sub $16*2 -12 - 8, %esp
    mov 8(%ebp), %ebx
    push (%ebx, %esi, 1)
    push $format_hhx
    xor %al, %al
    call printf
    add $16*2 -12, %esp

    pop %ecx

    inc %esi
    loop loop_print_hhx

    sub $16 - 8 - 4, %esp
    push $format_newline
    call puts
    add $16 - 8, %esp

    add $8, %esp
    leave
    ret

    .section .rodata
format_hhx:
    .string "%hhx\t"
format_newline:
    .string ""
