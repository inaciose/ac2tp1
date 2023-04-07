        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11
        .equ KFMS, 20000
        .equ MILIS, 100
        .equ putChar, 3
        .equ printInt, 6

        .text
        .globl main
main:
        # cnt1, cnt5, cnt10
        li $s0, 0
        li $s1, 0
        li $s2, 0

dom:    
        # set left digits
        li $t0, 5
        sll $t0, $t0, 16
        # set base 10
        ori $t0, $t0, 10

        # print cnt10 
        move $a0, $s2
        move $a1, $t0
        li $v0, printInt
        syscall

        # print sep
        li $a0, '\t'
        li $v0, putChar
        syscall

        # print cnt5
        move $a0, $s1
        move $a1, $t0
        li $v0, printInt
        syscall

        # print sep
        li $a0, '\t'
        li $v0, putChar
        syscall

        # print cnt1 
        move $a0, $s0
        move $a1, $t0
        li $v0, printInt
        syscall

        # print sep
        li $a0, '\r'
        li $v0, putChar
        syscall

        # funtion call
        # set argument
        li $a0, MILIS

        # store $ra on stack
        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        # call (wait)
        jal delay

        # retrieve $ra from stack
        sw $ra, 0($sp)
        addiu $sp, $sp, 4

        addiu $s0, $s0, 1

        rem $t0, $s0, 2
        bnez $t0, n5
        # inc cnt5
        addiu $s1, $s1, 1
n5:
        rem $t0, $s0, 10
        bnez $t0, n10
        # inc cnt10
        addiu $s2, $s2, 1
n10:

        j dom

        li $v0, 0
        jr $ra

        # ###########################
delay:
        # store argument
        move $t0, $a0
        # reset timer
        li $v0, resetCoreTimer
        syscall
        # set target ticks
        mul $t0, $t0, KFMS

dod:    
        # read timer
        li $v0, readCoreTimer
        syscall
        # wait or go
        blt $v0, $t0, dod
        jr $ra
