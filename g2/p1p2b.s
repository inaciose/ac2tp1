        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11
        .equ printInt, 6
        .equ putChar, 3
        # milisegundos
        .equ MILIS, 5000 
        # k para milisegundos
        .equ KFMS, 20000

        .data
        # vazio

        .text
        .globl main
main:
        # int counter = 0;
        li $s0, 0
do:

        # printInt(counter, 10 | 4 << 16);
        # set value
        move $a0, $s0
        # set base
        # li $a1, 10
        # set left zeros
        li $s1, 4
        sll $s1, $s1, 16
        #  set base & merge zeros to HI $a1
        ori $a1, $s1, 10
        # syscall
        li $v0, printInt
        syscall

        # putChar('\r');
        li $a0, '\r'
        li $v0, putChar
        syscall


        # resetCoreTimer();
        # while(readCoreTimer() < 200000);
        li $a0, MILIS
        addiu $sp, $sp, -4
        sw $ra, 0($sp)
        jal delay
        lw $ra, 0($sp)
        addiu $sp, $sp, 4


        # counter++
        addiu $s0, $s0, 1

        j do

        li $v0, 0
        jr $ra

delay:
        move $t0, $a0
        li $v0, resetCoreTimer
        syscall
        mul $t0, $t0, KFMS

dod:
        li $v0, readCoreTimer
        syscall
        blt $v0, $t0, dod

        jr $ra