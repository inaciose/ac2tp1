# int main(void)
# {
#  int counter = 0;
#  while(1)
#  {
#   resetCoreTimer();
#   while(readCoreTimer() < 200000);
#    printInt(counter++, 10 | 4 << 16);
#    // Ver nota 1
#    putChar('\r');
#    // cursor regressa ao inicio da linha
#   }
#   return 0;
# }

        .equ resetCoreTimer, 12
        .equ readCoreTimer, 11
        .equ printInt, 6
        .equ putChar, 3
        # 100hz
        .equ TICKS, 200000 

        .data
        # vazio

        .text
        .globl main
main:
        # int counter = 0;
        li $t0, 0
do:

        # resetCoreTimer();
        li $v0, resetCoreTimer
        syscall

        # while(readCoreTimer() < 200000);
while:
        li $v0, readCoreTimer
        syscall
        blt $v0, TICKS, while

        # printInt(counter++, 10 | 4 << 16);
        # counter++
        addiu $t0, $t0, 1
        # set value
        move $a0, $t0
        # set base
        li $a1, 10
        # set left zeros
        li $t1, 4
        sll $t1, $t1, 16
        # merge to HI $a1
        or $a1, $a1, $t1
        # syscall
        li $v0, printInt
        syscall

        # putChar('\r');
        li $a0, '\r'
        li $v0, putChar
        syscall

        j do

        li $v0, 0
        jr $ra
