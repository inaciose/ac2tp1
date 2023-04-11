        .equ SFR_BASE_HIGH, 0xBF88
        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120 

        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11

        .equ printInt, 6
        .equ putChar, 3

        .equ KMS, 20000
        .equ MILIS, 286

        .text
        .globl main

main:
        lui $s0, SFR_BASE_HIGH

        # configure ports for output
        lw $t0, TRISE($s0)
        andi $t0, $t0, 0xFF83
        sw $t0, TRISE($s0)

        # init counter
        li $s1, 0

do:
        # show on leds
        lw $t0, LATE($s0)
        andi $t0, $t0, 0xFF83
        andi $t1, $s1, 0x001F
        sll $t1, $t1, 2
        or $t0, $t0, $t1
        sw $t0, LATE($s0)

        # print
        move $a0, $s1
        li $t0, 5
        sll $t0, $t0, 16
        ori $a1, $t0, 2

        li $v0, printInt
        syscall

        li $a0, '\n'
        li $v0, putChar
        syscall

        # delay
        li $a0, MILIS
        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        jal delay

        lw $ra, 0($sp)
        addiu $sp, $sp, 4

        addi $s1, $s1, -1

        beq $s1, -1, rst
        j do

rst:
        li $s1, 24

        j do

        li $v0, 0
        jr $ra


delay:
        move $t0, $a0
        
        li $v0, resetCoreTimer
        syscall

        mul $t0, $t0, KMS
dd:
        li $v0, readCoreTimer
        syscall

        blt $v0, $t0, dd

        jr $ra
        


