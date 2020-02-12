.text
.globl main

main:
li $v0, 5		# prompt input 
syscall
move $a0, $v0		# store input 

jal recurse

move $t0, $v0		# store finale in t0 
li $v0, 1		# print finale 
move $a0, $t0		
syscall

li $v0, 10
syscall

recurse:
addi $sp, $sp, -12 
sw $ra 0($sp) 
sw $s0, 4($sp)
sw $s1 8($sp)

move $s0, $a0 

li $t1, 1
beq $s0, $t1, baseOne
beq $s0, $0, baseTwo

add $a0, $s0, -1

jal recurse

move $s1, $v0
addi $s0, -2
move $a0, $s0

jal recurse

move $s2, $v0
li $s4, 4
mult $s2, $s4
mflo $s3
addi $s3, 2		# 4(n - 2) + 2

li $s5, 3
mult $s1, $s5
mflo $s6		# 3(n - 1)

add $v0, $s6, $s3	# return entire thing

j exit 

baseOne:
li $v0, 2		# f(1) = 2
j exit 

baseTwo: 
li $v0, 1		# f(0) = 1
j exit

exit:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
addi $sp, $sp, 12 	# pop stack pointer
jr $ra
