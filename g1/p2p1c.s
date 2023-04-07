        .equ printStr, 8
        .equ printInt10, 7
        .equ printInt, 6
        .equ readInt10, 5

        .data
str1:   .asciiz "\nIntroduza um inteiro (sinal e módulo): "
str2:   .asciiz "\nValor em base 10 (signed): "
str3:   .asciiz "\nValor em base 2: "
str4:   .asciiz "\nValor em base 16: "
str5:   .asciiz "\nValor em base 10 (unsigned): "
str6:   .asciiz "\nValor em base 10 (unsigned), formatado: "

        .text
        .globl main
main:
do:
        # printStr("\nIntroduza um inteiro (sinal e módulo): ");
        la $a0, str1
        li $v0, printStr
        syscall

        # value = readInt10();
        li $v0, readInt10
        syscall

        move $t0, $v0

        # printStr("\nValor em base 10 (signed): ");
        la $a0, str2
        li $v0, printStr
        syscall

        # printInt10(value);
        move $a0, $t0
        li $v0, printInt10
        syscall

        # printStr("\nValor em base 2: ");
        la $a0, str3
        li $v0, printStr
        syscall

        # printInt(value, 2);
        move $a0, $t0
        li $a1, 2
        li $v0, printInt
        syscall

        # printStr("\nValor em base 16: ");
        la $a0, str4
        li $v0, printStr
        syscall

        # printInt(value, 16);
        move $a0, $t0
        li $a1, 16
        li $v0, printInt
        syscall

        # printStr("\nValor em base 10 (unsigned): ");
        la $a0, str5
        li $v0, printStr
        syscall

        # printInt(value, 10);
        move $a0, $t0
        li $a1, 10
        li $v0, printInt
        syscall

        # printStr("\nValor em base 10 (unsigned), formatado: ");
        la $a0, str6
        li $v0, printStr
        syscall

        # printInt(value, 10 | 5 << 16);
        # set value
        move $a0, $t0
        # set base
        li $a1, 10

        # set left zeros
        li $t1, 5
        sll $t1, $t1, 16
        or $a1, $a1, $t1

        # print
        li $v0, printInt
        syscall
        j do

        li $v0, 0
        jr $ra
