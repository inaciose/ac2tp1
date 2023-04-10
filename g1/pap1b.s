        .equ inKey, 1
        .equ printInt, 6
        .equ putChar, 3

        .equ UP,    1
        .equ DOWN,  0

        .equ KFW, 515000

        .text
        .globl main

main:
        li $s0, 0   # state
        li $s1, 0   # cnt

do:       
        # stop & run
        li $v0, inKey
        syscall

        beq $v0, 's', susp
        beq $v0, 'r', rst
        j siga
rst:
        li $s1, 0
        j siga
susp:
        j susp
siga:

        # print carriage return
        li $a0, '\r'
        li $v0, putChar
        syscall

        # printInt arg value
        move $a0, $s2
        # arg format
        li $t0, 1        # left digits      
        sll $t0, $t0, 16 # to high half word
        ori $a1, $t0, 10 # merge it with base
        
        li $v0, printInt
        syscall

        # print sep
        li $a0, '\t'
        li $v0, putChar
        syscall

        # printInt arg value
        move $a0, $s1
        # arg format
        li $t0, 3        # left digits      
        sll $t0, $t0, 16 # to high half word
        ori $a1, $t0, 10 # merge it with base
        
        li $v0, printInt
        syscall

        # print sep
        li $a0, '\t'
        li $v0, putChar
        syscall

        # printInt arg value
        move $a0, $s1
        # arg format
        li $t0, 8
        sll $t0, $t0, 16
        ori $a1, $t0, 2

        li $v0, printInt
        syscall

        # call wait
        li $a0, 5

        addiu $sp, $sp, -4
        sw $ra, 0($sp)

        jal waitf

        lw $ra, 0($sp)
        addiu $sp, $sp, 4

        li $v0, inKey
        syscall

        # store key pressed
        move $t0, $v0

        beq $t0, '+', kplus
        beq $t0, '-', kminus
        j skd

kplus:
        li $s0, 1
        j skd
kminus:
        li $s0, 0
skd:
        beq $s0, 1, incc
        addiu $s1, $s1, -1
        j maskm
incc:
        addiu $s1, $s1, 1

maskm:
        # mask module 256
        andi $s1, $s1, 0xFF

        # exit prog if 'q'
        beq $t0, 'q', done

        j do
done:
        li $v0, 0
        jr $ra

# ###########################
waitf:
        move $t1, $a0
        mul $t1, $t1, KFW
        li $t0, 0
 d1:
        addiu $t0, $t0, 1
        blt $t0, $t1, d1

        jr $ra
