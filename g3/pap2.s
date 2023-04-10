        
        .equ SFR_BASE_HIGH, 0xBF88

        .equ TRISE, 0x6100
        .equ PORTE, 0x6110
        .equ LATE, 0x6120
      
        .equ resetCoreTimer, 12
        .equ readCoreTimer,  11
        .equ KFMS,           20000
        .equ MILIS,          500

        .text
        .globl main
main:
        # load SFR base address to high half word
        lui $s1, SFR_BASE_HIGH
        # configure RE0 as output
        lw $t1, TRISE($s1)
        andi $t1, $t1, 0xFFFE
        sw $t1, TRISE($s1)

        # set variable to 0
        li $s2, 0

loop:
        # output desire value to port RE0
        lw $t1, LATE($s1)
        # reset bit0
        andi $t1, $t1, 0xFFFE
        # merge $t1 with $t2
        or $t1, $t1, $s2
        sw $t1, LATE($s1)

        # prepare fuction argument
        li $a0, MILIS
        # store return address
        addiu $sp, $sp, -4
        sw $ra, 0($sp)
        # call function
        jal delay
        # recall return address
        lw $ra, 0($sp)
        addiu $sp, $sp, 4

        # negate $s2 bit0 
        xori $s2, $s2, 0x0001

        j loop

        li $v0, 0
        jr $ra

delay:
        move $t0, $a0
        li $v0, resetCoreTimer
        syscall

        mul $t0, $t0, KFMS

dod:        
        li $v0, readCoreTimer
        syscall
        blt $v0, $t0, dod

        jr $ra
