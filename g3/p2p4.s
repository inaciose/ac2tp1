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
        # k for delay in ms
        .equ KFMS, 20000
        .equ MILIS, 333

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

        # config TRISB 1 input
        # read TRISB
        lw $t0, TRISB($s0)
        # modify: set bit 1
        ori $t0, $t0, 0x0002
        # write
        sw $t0, TRISB($s0)

# bof extra for best start
        # select init value
        # read PORTB
        lw $t0, PORTB($s0)
        # isolate bit1
        andi $t0, $t0, 0x0002

        # select init 8/1
        beq $t0, 0, ini8

        # init counter
ini1:
        li $s1, 1
        j inid
ini8:
        li $s1, 8
inid:
# eof extra for best start
        # init counter
        # li $s1, 1
        # shift count
        li $s2, 0

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

        # read PORTB
        lw $t0, PORTB($s0)
        # isolate bit1
        andi $t0, $t0, 0x0002

        # inc shift count
        addi $s2, $s2, 1

        # select shift left/right
        beq $t0, 0, sr
sl:
        beq $s2, 4, rl
        sll $s1, $s1, 1
        j do
rl:
        li $s1, 1
        li $s2, 0
        j do
sr:
        beq $s2, 4, rr
        srl $s1, $s1, 1
        j do
rr:
        li $s1, 8
        li $s2, 0
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