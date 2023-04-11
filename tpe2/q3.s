        .equ SFR_BASE_HIGH, 0xBF88
        .equ TICKS, 5714285

        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120

        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11

        .equ printInt, 6
        .equ putChar, 3


        .text
        .globl main
main:
        lui $s0, SFR_BASE_HIGH
        # cfg RE4-RE1 output
        lw $t0, TRISE($s0)
        andi $t0, $t0, 0xFFE1
        sw $t0, TRISE($s0)

        li $s1, 9;
while:
        # send to leds
        lw $t0, LATE($s0)
        andi $t0, $t0, 0xFFE1
        sll $t1, $s1, 1 
        or $t0, $t0, $t1
        sw $t0, LATE($s0)

        move $a0, $s1
        li $t0, 4
        sll $t0, $t0, 16
        ori $a1, $t0, 2

        li $v0, printInt
        syscall

        li $a0, '\n'
        li $v0, putChar
        syscall

        # call delay
        li $a0, TICKS
        addiu $sp, $sp, -4
        sw $ra, 0($sp)
        jal fdelay
        lw $ra, 0($sp)
        addiu $sp, $sp, 4

        xori $s1, $s1, 0xF

        j while

        li $v0, 0
        jr $ra

fdelay:
        move $t0, $a0
        li $v0, resetCoreTimer
        syscall

fdo:
        li $v0, readCoreTimer
        syscall
        blt $v0, $t0, fdo

        jr $ra





