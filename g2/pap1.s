        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11
        .equ KFMS, 20000
        .equ DMILIS, 500

        .equ readInt10, 5
        .equ printInt, 6
        .equ printStr, 8
        .equ putchar, 3
        
        .data
str:    .asciiz "entre ms a esperar: "
        
        .text
        .globl main

main:

        la $a0, str
        li $v0, printStr
        syscall

        move $s1, $v0

        li $v0, readInt10
        syscall

        move $s0, $v0

        # call function to reset

        move $a0, $s0
        li $a1, 1

        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        jal timed

        lw $ra, 0($sp)
        addiu $sp, $sp, 4

do:
        # call function to read

        move $a0, $s0
        li $a1, 0

        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        jal timed

        lw $ra, 0($sp)
        addiu $sp, $sp, 4

        # set number tp print
        move $a0, $v0

        # configure left zeros to print
        li $t0, 9
        sll $t0, $t0, 16
        # configure base to print
        li $a1, 10
        # merge both
        or $a1, $a1, $t0

        # print
        li $v0, printInt
        syscall

        li $a0, '\n'
        li $v0, putchar
        syscall

        j do


        li $v0, 0
        jr $ra



timed:
        # save ms & reset args
        move $t0, $a0 
        move $t1, $a1
        
        # default return value
        li $t2, 0

        # reset or read
        bgt $t1, 0, rstt

        # not reset
        mul $t3, $t0, KFMS
        li $v0, readCoreTimer
        syscall
        bgt $v0, $t3, texp

        j timedd
texp:
        div $t2, $v0, KFMS

        j timedd
rstt:
        # reset
        li $v0, resetCoreTimer
        syscall

timedd:
        move $v0, $t2
        jr $ra
