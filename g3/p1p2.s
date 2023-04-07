        # .equ SFR_BASE_HIGH, 0xBF88
        .equ SFR_BASE_HIGH, 0xBF88
         # port B
        .equ TRISB, 0x6040
        .equ PORTB, 0x6050
        .equ LATB, 0x6060       
        # port E
        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120

        .data
        # vazio

        .text
        .globl main
main:
        # io ports base address
        lui $t0, SFR_BASE_HIGH

        # read port E configuration
        lw $t1, TRISE($t0)
        # modify set bit0=0
        andi $t1, $t1, 0xFFFE
        # write
        sw $t1,  TRISE($t0)

        # read port B configuration
        lw $t1, TRISB($t0)
        # modify set bit=1
        ori $t1, $t1, 0x0001
        # write
        sw $t1,  TRISB($t0)

do:
        # read port B
        lw $t1, PORTB($t0)
        # negate all bits
        not $t1, $t1
        # isolate port B bit0 
        andi $t2, $t1, 0x0001
        # read lat E
        lw $t1, LATE($t0)
        # reset lat E bit0
        andi $t1, $t1, 0xFFFE
        # store previosly isolated bit0
        or $t1, $t1, $t2
        # write
        sw $t1, LATE($t0)

        j do

        li $v0, 0
        jr $ra
