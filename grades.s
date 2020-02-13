#
# PROGRAM
#
.text

#
# Hash function.
# Argument: $a0 (int)
# Return: $v0 = hash (int)
#
hash:
    li $t0, 13
	div $a0, $t0
	mfhi $v0
	jr $ra

#
# Initialize the hash table.
#
init_hash_table:
	jr $ra							# Already stored in .data

#
# Insert the record unless a record with the same ID already exists in the hash table.
# If record does not exist, print "INSERT (<ID>) <Exam 1 Score> <Exam 2 Score> <Name>".
# If a record already exists, print "INSERT (<ID>) cannot insert because record exists".
# Arguments: $a0 (ID), $a1 (exam 1 score), $a2 (exam 2 score), $a3 (address of name buffer)
#
insert_student:
	addi $sp, $sp, -32
    sw $s1, 0($sp)					# for ID
	sw $s2, 4($sp)					# for ex1
	sw $s3, 8($sp)					# for ex2
	sw $s4, 12($sp)					# for name buffer
    sw $s5, 16($sp)                 # for .next 
    sw $s0, 20($sp)                 # for hash
    sw $ra, 24($sp)					# Allocate on stack
    sw $v0, 28($sp)                 # for return value 

	jal hash						# Generate hash
	
	move $s0, $v0					# Store hash in s0
	move $s1, $a0					# Store ID in s1
	move $s2, $a1					# Store ex1 in s2
	move $s3, $a2					# Store ex2 in s3
	move $s4, $a3					# Store name buffer in s3
    move $s5, $0                    # Make .next NULL
	
	la $t0, table					# Store table pointer in t0
	sll $s0, $s0, 2					# hash * 4
	add $t0, $s0, $t0				# Now pointing to table[hash] 
	lw $t1, 0($t0)					# Store 1st bucket value in t1
	beq $t1, $0, ins_new_hash		# go to ins_new_hash if table[hash] is EMPTY 
    
    jal else_hash
	
    lw $s1, 0($sp)					# for ID
	lw $s2, 4($sp)					# for ex1
	lw $s3, 8($sp)					# for ex2
	lw $s4, 12($sp)					# for name buffer
    lw $s5, 16($sp)                 # for .next 
    lw $s0, 20($sp)                 # for hash
    lw $ra, 24($sp)                 # for return address
    lw $v0, 28($sp)                 # for return value 
    
    addi $sp, $sp, 32               # collapse stack 

    jr $ra 

# Insert record into the head of table[hash]
ins_new_hash:
    li $a0, 32
    li $v0, 9
    syscall         

    sw $v0, 0($t0)       
    move $t0, $v0                   # Allocated 32B for t0

    sw $s1, 0($t0)					# Save ID to 0 
	sw $s2, 4($t0)					# Save ex1 to 4
	sw $s3, 8($t0)					# Save ex2 to 8
    sw $s5, 12($t0)                  # Save .next field (NULL) to 16

    lb $t4, 0($s4) #saves name
	sb $t4, 16($t0) #saves name
	lb $t4, 1($s4) #saves name
	sb $t4, 17($t0) #saves name
	lb $t4, 2($s4) #saves name
	sb $t4, 18($t0) #saves name
	lb $t4, 3($s4) #saves name
	sb $t4, 19($t0) #saves name
	lb $t4, 4($s4) #saves name
	sb $t4, 20($t0) #saves name
	lb $t4, 5($s4) #saves name
	sb $t4, 21($t0) #saves name
	lb $t4, 6($s4) #saves name
	sb $t4, 22($t0) #saves name
	lb $t4, 7($s4) #saves name
	sb $t4, 23($t0) #saves name
	lb $t4, 8($s4) #saves name
	sb $t4, 24($t0) #saves name
	lb $t4, 9($s4) #saves name
	sb $t4, 25($t0) #saves name
	lb $t4, 10($s4) #saves name
	sb $t4, 26($t0) #saves name
	lb $t4, 11($s4) #saves name
	sb $t4, 27($t0) #saves name
	lb $t4, 12($s4) #saves name
	sb $t4, 28($t0) #saves name
	lb $t4, 13($s4) #saves name
	sb $t4, 29($t0) #saves name
	lb $t4, 14($s4) #saves name
	sb $t4, 30($t0) #saves name
	lb $t4, 15($s4) #saves name
	sb $t4, 31($t0) #saves name

    la $a0, INSERT                  
    li $v0, 4
    syscall                         # "INSERT "
    la $a0, L_PARENTHESIS
    li $v0, 4
    syscall                         # "("
    lw $a0, 0($t0)                  
    li $v0, 1
    syscall                         # "ID"
    la $a0, R_PARENTHESIS
    li $v0, 4
    syscall                         # ")"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    lw $a0, 4($t0)                  
    li $v0, 1
    syscall                         # "ex1"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    lw $a0, 8($t0)                  
    li $v0, 1
    syscall                         # "ex2"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    la $a0, 16($t0)                            
    li $v0, 4
    syscall                         # "NAME" 
    la $a0, NEWLINE
    li $v0, 4
    syscall                         # " "

    lw $s1, 0($sp)					# for ID
	lw $s2, 4($sp)					# for ex1
	lw $s3, 8($sp)					# for ex2
	lw $s4, 12($sp)					# for name buffer
    lw $s5, 16($sp)                 # for .next 
    lw $s0, 20($sp)                 # for hash
    lw $ra, 24($sp)                 # for return address
    lw $v0, 28($sp)                 # for return value 

    addi $sp, $sp, 32               # collapse stack 

    jr $ra 

# Do if table[hash] is not empty 
else_hash:
    beq $t1, $s1, ins_match_found
    lw $t0
    
    

ins_match_found:

ins_end:



#
# Delete the record for the specified ID, if it exists in the hash table.
# If a record already exists, print "DELETE (<ID>) <Exam 1 Score> <Exam 2 Score> <Name>".
# If a record does not exist, print "DELETE (<ID>) cannot delete because record does not exist".
# Argument: $a0 (ID)
#
delete_student:
    # TODO: Implement


#
# Print all the member variables for the record with the specified ID, if it exists in the hash table.
# If a record already exists, print "LOOKUP (<ID>) <Exam 1 Score> <Exam 2 Score> <Name>".
# If a record does not exist, print "LOOKUP (<ID>) record does not exist".
# Argument: $a0 (ID)
#
lookup_student:
    # TODO: Implement


#
# Read input and call the appropriate hash table function.
#
main:
    addi    $sp, $sp, -16
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    sw      $s1, 8($sp)
    sw      $s2, 12($sp)

    jal     init_hash_table

main_loop:
    la      $a0, PROMPT_COMMAND_TYPE    # Promt user for command type
    li      $v0, 4
    syscall

    la      $a0, COMMAND_BUFFER         # Buffer to store string input
    li      $a1, 3                      # Max number of chars to read
    li      $v0, 8                      # Read string
    syscall

    la      $a0, COMMAND_BUFFER
    jal     remove_newline

    la      $a0, COMMAND_BUFFER
    la      $a1, COMMAND_T
    jal     string_equal

    li      $t0, 1
    beq		$v0, $t0, exit_main	        # If $v0 == $t0 (== 1) (command is t) then exit program

    la      $a0, PROMPT_ID              # Promt user for student ID
    li      $v0, 4
    syscall

    li      $v0, 5                      # Read integer
    syscall

    move    $s0, $v0                    # $s0 holds the student ID

    la      $a0, PROMPT_EXAM1           # Prompt user for exam 1 score
    li      $v0, 4
    syscall

    li      $v0, 5                      # Read integer
    syscall

    move    $s1, $v0                    # $s1 holds the exam 1 score

    la      $a0, PROMPT_EXAM2           # Prompt user for exam 2 score
    li      $v0, 4
    syscall

    li      $v0, 5                      # Read integer
    syscall

    move    $s2, $v0                    # $s2 holds the exam 2 score

    la      $a0, PROMPT_NAME            # Prompt user for student name
    li      $v0, 4
    syscall

    la      $a0, NAME_BUFFER            # Buffer to store string input
    li      $a1, 16                     # Max number of chars to read
    li      $v0, 8                      # Read string
    syscall

    la      $a0, NAME_BUFFER
    jal     remove_newline

    la      $a0, COMMAND_BUFFER         # Check if command is insert
    la      $a1, COMMAND_I
    jal     string_equal
    li      $t0, 1
    beq		$v0, $t0, goto_insert

    la      $a0, COMMAND_BUFFER         # Check if command is delete
    la      $a1, COMMAND_D
    jal     string_equal
    li      $t0, 1
    beq		$v0, $t0, goto_delete

    la      $a0, COMMAND_BUFFER         # Check if command is lookup
    la      $a1, COMMAND_L
    jal     string_equal
    li      $t0, 1
    beq		$v0, $t0, goto_lookup

goto_insert:
    move    $a0, $s0
    move    $a1, $s1
    move    $a2, $s2
    la      $a3, NAME_BUFFER
    jal     insert_student
    j       main_loop

goto_delete:
    move    $a0, $s0
    jal     delete_student
    j       main_loop

goto_lookup:
    move    $a0, $s0
    jal     lookup_student
    j       main_loop

exit_main:
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    addi    $sp, $sp, 16
    jr      $ra


#
# String equal function.
# Arguments: $a0 and $a1 (addresses of strings to compare)
# Return: $v0 = 0 (not equal) or 1 (equal)
#
string_equal:
    addi    $sp, $sp, -12
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    sw      $s1, 8($sp)

    move    $s0, $a0
    move    $s1, $a1

    lb      $t0, 0($s0)
    lb      $t1, 0($s1)

string_equal_loop:
    beq     $t0, $t1, continue_string_equal_loop
    j       char_not_equal
continue_string_equal_loop:
    beq     $t0, $0, char_equal
    addi    $s0, $s0, 1
    addi    $s1, $s1, 1
    lb      $t0, 0($s0)
    lb      $t1, 0($s1)
    j       string_equal_loop

char_equal:
    li      $v0, 1
    j       exit_string_equal

char_not_equal:
    li      $v0, 0

exit_string_equal:
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    addi    $sp, $sp, 12
    jr      $ra


#
# Remove newline from string.
# Argument: $a0 (address of string to remove newline from)
#
remove_newline:
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)

    lb      $t0, 0($a0)
    li      $t1, 10                     # ASCII value for newline char

remove_newline_loop:
    beq     $t0, $t1, char_is_newline
    addi    $a0, $a0, 1
    lb      $t0, 0($a0)
    j       remove_newline_loop

char_is_newline:
    sb      $0, 0($a0)

    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra



# 
# DATA
#
.data 
table: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
PROMPT_COMMAND_TYPE:    .asciiz     "PROMPT (COMMAND TYPE): "
PROMPT_ID:              .asciiz     "PROMPT (ID): "
PROMPT_EXAM1:           .asciiz     "PROMPT (EXAM 1 SCORE): "
PROMPT_EXAM2:           .asciiz     "PROMPT (EXAM 2 SCORE): "
PROMPT_NAME:            .asciiz     "PROMPT (NAME): "
COMMAND_BUFFER:         .space      3                           # 3B buffer
NAME_BUFFER:            .space      16                          # 16B buffer
COMMAND_I:              .asciiz     "i"                         # Insert
COMMAND_D:              .asciiz     "d"                         # Delete
COMMAND_L:              .asciiz     "l"                         # Lookup
COMMAND_T:              .asciiz     "t"                         # Terminate
SPACE:                  .asciiz     " "                         # Space 
NEWLINE:                .asciiz     "\n"                        # Newline
L_PARENTHESIS:          .asciiz     "("                         # Left parenthesis
R_PARENTHESIS:          .asciiz     ")"                         # Right parenthesis  
INSERT:                 .asciiz     "INSERT "                   # Student inserted
NOT_INSERTED:           .asciiz     " cannot insert because record exists\n"  
