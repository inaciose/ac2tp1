        .equ PBASE, 0xBF88

        .equ TRISB, 0x6040
        .equ PORTB, 0x6050
        .equ LATB, 0x6060

        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120

        .text
        .globl main

main:
        # peripheral base address
        lui $t0, PBASE

        # configure RB0-RB3 as input
        lw $t1, TRISB($t0)
        ori $t1, $t1, 0x000F
        sw $t1, TRISB($t0)
        
        # configure RE2-RE5 as output
        lw $t1, TRISE($t0)
        andi $t1, $t1, 0xFFC3
        sw $t1, TRISE($t0)

loop:
        
        
        
        # load
        lw $t1, PORTB($t0)
        # modify: apply mask to reset required bits
        andi $t1, $t1, 0x000F
        # modify: apply mask to negate required bits
        xori $t1, $t1, 0x0009
        # modify: shift left to match output bits
        sll $t1, $t1, 2

        # load 
        lw $t2, LATE($t0)
        # modify: apply mask to reset required bits
        andi $t2, $t1, 0xFFC3

        # merge the registers
        or $t1, $t2, $t1

        sw $t1, LATE($t0)

        j loop

        li $v0, 0
        jr $ra
