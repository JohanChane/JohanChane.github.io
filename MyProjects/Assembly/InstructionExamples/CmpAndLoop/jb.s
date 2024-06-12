    .global main
.section .text
main:
    sub $8, %rsp

    movq $100, %rdi
    movq $101, %rsi
    call compare_unsigned

    movq $101, %rdi
    movq $100, %rsi
    call compare_unsigned

    add $8, %rsp

    xor %eax, %eax
    ret

compare_unsigned:
    movq %rdi, %rax
    movq %rsi, %rbx
    cmpq %rbx, %rax         # %rax - %rbx
    jb print_below

print_not_below:
    movq $not_below_str, %rdi
    xor %al, %al
    call printf
    jmp printbnb_out

print_below:
    movq $below_str, %rdi
    xor %al, %al
    call printf

printbnb_out:
    xor %eax, %eax
    ret

.section .data
    below_str:
        .string "below\n"
    not_below_str:
        .string "not below(above or equal)\n"
