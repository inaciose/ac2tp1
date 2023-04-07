        # .equ SFR_BASE_HIGH, 0xBF88
        .equ SFR_BASE_HIGH, 0xBF88

        # port E
        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120
        # k for delay in ms
        .equ KFMS, 20000
        .equ MILIS, 1000

        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11


        .data
        # vazio

        .text
        .globl main

main:
        # config TRISD 1-4 output
        lui $s0, SFR_BASE_HIGH
        # read TRISD
        lw $t0, TRISE($s0)
        # modify: reset bits 1-4
        andi $t0, $t0, 0xFFE1
        # write
        sw $t0, TRISE($s0) 

        # init counter
        li $s1, 0
while:

        # shift left to 4-1
        sll $t0, $s1, 1

        # read LATE
        lw $t1, LATE($s0)
        # modify: reset bits 1-4
        andi $t1, $t1, 0xFFE1
        # modify: counter bits
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

        # inc counter
        addiu $s1, $s1, 1
        beq $s1, 16, resetc

        j while
resetc:
        li $s1, 0
        j while

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