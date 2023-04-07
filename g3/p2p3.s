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
        .equ MILIS, 500

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

        # config TRISB 3 input
        # read TRISB
        lw $t0, TRISB($s0)
        # modify: set bit 3
        ori $t0, $t0, 0x0008
        # write
        sw $t0, TRISB($s0) 


        # init counter
        li $s1, 0

        # mode dec/inc : 0/1
        # li $s2, 0
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

        # read PORTB
        lw $t0, PORTB($s0)
        # isolate bit3
        # reset all except bit3
        andi $t0, $t0, 0x0008
        # shift right
        # srl $t0, $t0, 3
        # move $t0 (bit0) to var $s2
        # move $s2, $t0

        # select if inc or dec
        beq $t0, 8, incc

        # dec counter
        addi $s1, $s1, -1
        beq $s1, -1, resetcd
        j while
incc:
        # inc counter
        addi $s1, $s1, 1
        beq $s1, 16, resetci
        j while
resetcd:
        li $s1, 15
        j while

resetci:
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