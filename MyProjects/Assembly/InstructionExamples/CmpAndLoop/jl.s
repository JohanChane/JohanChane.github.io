    .global main
    .section .text
main:
    sub $8, %rsp

    movq $-100, %rdi
    movq $-101, %rsi
    call compare_signed

    movq $-101, %rdi
    movq $-100, %rsi
    call compare_signed

    add $8, %rsp

    xor %eax, %eax
    ret

compare_signed:
    movq %rdi, %rax
    movq %rsi, %rbx
    cmpq %rbx, %rax         # %rax - %rbx
    jl print_less

print_not_less:
    movq $not_less_str, %rdi
    xor %al, %al
    call printf
    jmp printlnl_out

print_less:
    movq $less_str, %rdi
    xor %al, %al
    call printf

printlnl_out:
    xor %eax, %eax
    ret

.section .data
    less_str:
        .string "less\n"
    not_less_str:
        .string "not less(greater or equal)\n"
