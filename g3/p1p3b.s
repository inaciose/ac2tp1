        # .equ SFR_BASE_HIGH, 0xBF88
        .equ SFR_BASE_HIGH, 0xBF88
         # port B
        .equ TRISD, 0x60C0
        .equ PORTD, 0x60D0
        .equ LATD, 0x60E0       
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

        # read port D configuration
        lw $t1, TRISD($t0)
        # modify set bit=8
        ori $t1, $t1, 0x0100
        # write
        sw $t1,  TRISD($t0)

do:
        # read port B
        lw $t1, PORTD($t0)
        # negate all bits
        not $t1, $t1
        # isolate port B bit8
        andi $t2, $t1, 0x0100
        # shift 8 bits to right
        srl $t2, $t2, 8
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
