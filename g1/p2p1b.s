        .equ    inKey, 1
        .equ    putChar, 3

        .data
        # vazio
        
        .text
        .globl main

main:

do:     li $v0, inKey
        syscall
        move $t0, $v0
        beq $t0, $0, pdot
pchar:
        move $a0, $t0
        li $v0, putChar
        syscall

        j chk

pdot:
        li $a0, '.'
        li $v0, putChar
        syscall

chk:        
        beq $t0, '\n', done
        j do
done:


        li $v0, 0
        jr $ra
