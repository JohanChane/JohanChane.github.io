    .global main
    .section .text
main:
    stc
    jc prints

prints:
    movq $100, %rsi
    movq $formati, %rdi
    xor %al, %al
    call printf
    jmp print_out

print_out:
    xor %eax, %eax
    ret

.section .data
    formati:
        .string "%d\n"
    formats:
        .string "%s\n"
