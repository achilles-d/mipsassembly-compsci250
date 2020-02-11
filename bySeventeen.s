.text
.globl main

main:
li $v0, 5		# accept input for N 
syscall
move $t1, $v0		# t1 contains N

li $t0, 1		# t0 contains COUNTER 
li $t2, 17		# t2 contains 17 

loop:

li $v0, 1
mult $t0, $t2
mflo $a0
syscall

li $a0, $0, 10
li $v0, 11
syscall

addi $t0, 1
beq $t0, $t1, exit 
j loop 


exit:
jr $ra 