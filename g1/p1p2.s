        .data
        .equ    print_string, 8
str:    .asciiz "AC2 - Aulas práticas\n"

        .text
        .globl main
main:

        la $a0, str
        li $v0, print_string
        syscall

        li $v0, 0
        jr $ra
