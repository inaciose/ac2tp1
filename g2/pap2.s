        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11
        .equ KFMS, 20000
        .equ MILIS, 100
        .equ putChar, 3
        .equ printInt, 6

        .text
        .globl main
main:
        # cnt1, cnt5, cnt10
        li $s0, 0
        li $s1, 0
        li $s2, 0

        # funtion call for reset
        # set argument
        li $a0, MILIS
        li $a1, 1

        # store $ra on stack
        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        # call (wait)
        jal timed

        # retrieve $ra from stack
        sw $ra, 0($sp)
        addiu $sp, $sp, 4

dom:    

        # funtion call for read
        # set argument
        li $a0, MILIS
        li $a1, 0

        # store $ra on stack
        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        # call (wait)
        jal timed

        # retrieve $ra from stack
        sw $ra, 0($sp)
        addiu $sp, $sp, 4

        # redo until greater than zero
        beq $v0, 0, dom
incv:        
        # se tiver passado o tempo (retorno != 0)
        # incrementa a variavel
        addiu $s0, $s0, 1

        # default terminador '\r'
        li $s3, '\r'

        rem $t0, $s0, 2
        bnez $t0, n5
        # inc cnt5
        addiu $s1, $s1, 1
n5:
        rem $t0, $s0, 10
        bnez $t0, n10
        # inc cnt10
        addiu $s2, $s2, 1

        # terminador '\n'
        li $s3, '\n'
n10:
        # call print line
        move $a0, $s0
        move $a1, $s1
        move $a2, $s2
        move $a3, $s3

        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        jal pline

        lw $ra, 0($sp)
        addiu $sp, $sp, 4

        # reset counter
        # funtion call for reset
        # set argument
        li $a0, MILIS
        li $a1, 1

        # store $ra on stack
        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        # call (wait)
        jal timed

        # retrieve $ra from stack
        sw $ra, 0($sp)
        addiu $sp, $sp, 4

        j dom
waitd:


        j dom

        li $v0, 0
        jr $ra

        # ###########################
timed:
        # save ms & reset args
        move $t0, $a0 
        move $t1, $a1
        
        # default return value
        li $t2, 0

        # reset or read
        bgt $t1, 0, rstt

        # not reset
        mul $t3, $t0, KFMS
        li $v0, readCoreTimer
        syscall
        bgt $v0, $t3, texp

        j timedd
texp:
        div $t2, $v0, KFMS

        j timedd
rstt:
        # reset
        li $v0, resetCoreTimer
        syscall

timedd:
        move $v0, $t2
        jr $ra


pline:
        move $t2, $a0 # s0
        move $t3, $a1 # s1
        move $t4, $a2 # s2
        move $t5, $a3 # terminator

        # set left digits
        li $t0, 5
        sll $t0, $t0, 16
        # set base 10
        ori $t0, $t0, 10

        # print cnt10 
        move $a0, $t4
        move $a1, $t0
        li $v0, printInt
        syscall

        # print sep
        li $a0, '\t'
        li $v0, putChar
        syscall

        # print cnt5
        move $a0, $t3
        move $a1, $t0
        li $v0, printInt
        syscall

        # print sep
        li $a0, '\t'
        li $v0, putChar
        syscall

        # print cnt1 
        move $a0, $t2
        move $a1, $t0
        li $v0, printInt
        syscall

        # print terminator
        move $a0, $t5
        li $v0, putChar
        syscall

        jr $ra
