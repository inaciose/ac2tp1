        # .equ SFR_BASE_HIGH, 0xBF88
        .equ SFR_BASE_HIGH, 0xBF88

        # port E
        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120
        # k for delay in ms
        .equ KFMS, 20000
        .equ MILIS, 667

        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11

        .data
        # vazio

        .text
        .globl main

main:
        # set io port base address
        lui $s0, SFR_BASE_HIGH
        # config TRISD 1-4 output
        # read TRISD
        lw $t0, TRISE($s0)
        # modify: reset bits 1-4
        andi $t0, $t0, 0xFFE1
        # write
        sw $t0, TRISE($s0) 

        # init counter
        li $s1, 0

do:
        sll $t0, $s1, 1

        # read LATE
        lw $t1, LATE($s0)
        # modify reset bits 4 - 1
        andi $t1, $t1, 0xFFE1
        # modify merge with counter
        or $t1, $t1, $t0
        # write
        sw $t1, LATE($s0)

        # function arg
        li $a0, MILIS
        # save ra in stack
        addiu $sp, $sp, -4
        sw $ra, 0($sp)
        # call 
        jal delay
        # retrieve ra from stack
        lw $ra, 0($sp) 
        addiu $sp, $sp, 4

        # johnson right
        move $t0, $s1
        # negate bits
        not $t1, $t0
        # isolate bit 3
        andi $t1, $t1, 0x0001
        # shift left 3 bits
        sll $t1, $t1, 3
        # shift right 1 bit
        srl $t0, $t0, 1
        # reset bit 3
        andi $t0, $t0, 0xFFF7
        # merge rotated bit
        or $s1, $t0, $t1

        j do

        li $v0, 0
        jr $ra

delay:
        # preserve argument
        move $t0, $a0
        # reset
        li $v0, resetCoreTimer
        syscall
        # ticks for ms
        mul $t0, $t0, KFMS
dod:
        li $v0, readCoreTimer
        syscall
        blt $v0, $t0, dod

        jr $ra