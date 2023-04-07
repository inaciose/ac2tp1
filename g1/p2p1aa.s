        .equ    getChar, 2
        .equ    putChar, 3

        .data
        # vazio
        
        .text
        .globl main

main:

do:
        li $v0, getChar
        syscall
        move $t0, $v0
        addiu $t0, $t0, 1
        move $a0, $t0
        li $v0, putChar
        syscall

        beq $t0, '\n', done
        j do

done:   

        li $v0, 0
        jr $ra