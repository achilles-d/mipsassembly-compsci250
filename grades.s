#
# PROGRAM
#
.text
.align 2 

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
	lw $t1, 0($t0)					# Store head pointer in t1
	beq $t1, $0, ins_new_hash		# go to ins_new_hash if table[hash] is EMPTY 
    
    b else_hash

# Insert record into the head of table[hash]
ins_new_hash:
    li $a0, 32
    li $v0, 9
    syscall         

    sw $v0, 0($t0)       
    move $t0, $v0                   # Allocated 16B for t0

    sw $s1, 0($t0)					# Save ID to 0 
	sw $s2, 4($t0)					# Save ex1 to 4
	sw $s3, 8($t0)					# Save ex2 to 8
    sw $s5, 12($t0)                  # Save .next field (NULL) to 12

    lb $t4, 0($s4)
	sb $t4, 16($t0)
	lb $t4, 1($s4)
	sb $t4, 17($t0)
	lb $t4, 2($s4)
	sb $t4, 18($t0)
	lb $t4, 3($s4)
	sb $t4, 19($t0)
	lb $t4, 4($s4)
	sb $t4, 20($t0)
	lb $t4, 5($s4) 
	sb $t4, 21($t0)
	lb $t4, 6($s4)
	sb $t4, 22($t0)
	lb $t4, 7($s4)
	sb $t4, 23($t0)
	lb $t4, 8($s4)
	sb $t4, 24($t0)
	lb $t4, 9($s4)
	sb $t4, 25($t0)
	lb $t4, 10($s4)
	sb $t4, 26($t0)
	lb $t4, 11($s4)
	sb $t4, 27($t0)
	lb $t4, 12($s4)
	sb $t4, 28($t0)
	lb $t4, 13($s4)
	sb $t4, 29($t0)
	lb $t4, 14($s4)
	sb $t4, 30($t0)
	lb $t4, 15($s4) 
	sb $t4, 31($t0) 

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
    beq, $t1, $0, ins_check_next    # branch to check_next if NEXT is NULL
    lw $a0, 0($t1)                  # deref. to get actual value in container
    beq $a0, $s1, ins_match_found   # branch if matching ID is found 
    move $t7, $t1                   # t7 is PREV
    lw $t1, 12($t1)                
    b else_hash 

ins_match_found:
    la $a0, INSERT
    li $v0, 4
    syscall                         # "INSERT "
    la $a0, L_PARENTHESIS
    li $v0, 4
    syscall                         # "("
    move $a0, $s1
    li $v0, 1
    syscall                         # "ID"
    la $a0, R_PARENTHESIS
    li $v0, 4
    syscall                         # ")"
    la $a0, NOT_INSERTED
    li $v0, 4
    syscall                         # " cannot be inserted because record exists"

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

ins_check_next:

    lw $t3, 0($t1)                  # store ID in t3
    beq $s1, $t3, ins_match_found   # branch to match_found if IDs match 

    li $a0, 32
    li $v0, 9
    syscall                         # Allocated 32B

    sw $v0, 12($t1)                 # Point t3 to storage space 
    move $t3, $v0                   # Allocated 32B for t3


    sw $s1, 0($t3)					# Save ID to 0 
	sw $s2, 4($t3)					# Save ex1 to 4
	sw $s3, 8($t3)					# Save ex2 to 8
    sw $s5, 12($t3)                  # Save .next field (NULL) to 16

    lb $t4, 0($s4)
	sb $t4, 16($t3)
	lb $t4, 1($s4)
	sb $t4, 17($t3)
	lb $t4, 2($s4)
	sb $t4, 18($t3)
	lb $t4, 3($s4)
	sb $t4, 19($t3)
	lb $t4, 4($s4)
	sb $t4, 20($t3)
	lb $t4, 5($s4) 
	sb $t4, 21($t3)
	lb $t4, 6($s4)
	sb $t4, 22($t3)
	lb $t4, 7($s4)
	sb $t4, 23($t3)
	lb $t4, 8($s4)
	sb $t4, 24($t3)
	lb $t4, 9($s4)
	sb $t4, 25($t3)
	lb $t4, 10($s4)
	sb $t4, 26($t3)
	lb $t4, 11($s4)
	sb $t4, 27($t3)
	lb $t4, 12($s4)
	sb $t4, 28($t3)
	lb $t4, 13($s4)
	sb $t4, 29($t3)
	lb $t4, 14($s4)
	sb $t4, 30($t3)
	lb $t4, 15($s4) 
	sb $t4, 31($t3) 

    sw $t3, 12($t7)

    la $a0, INSERT                  
    li $v0, 4
    syscall                         # "INSERT "
    la $a0, L_PARENTHESIS
    li $v0, 4
    syscall                         # "("
    lw $a0, 0($t3)                  
    li $v0, 1
    syscall                         # "ID"
    la $a0, R_PARENTHESIS
    li $v0, 4
    syscall                         # ")"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    lw $a0, 4($t3)                  
    li $v0, 1
    syscall                         # "ex1"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    lw $a0, 8($t3)                  
    li $v0, 1
    syscall                         # "ex2"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    la $a0, 16($t3)                            
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

#
# Delete the record for the specified ID, if it exists in the hash table.
# If a record already exists, print "DELETE (<ID>) <Exam 1 Score> <Exam 2 Score> <Name>".
# If a record does not exist, print "DELETE (<ID>) cannot delete because record does not exist".
# Argument: $a0 (ID)
#
delete_student:
    addi $sp, $sp, -32              # collapse stack 

    sw $s1, 0($sp)					# for ID
	sw $s2, 4($sp)					# for ex1
	sw $s3, 8($sp)					# for ex2
	sw $s4, 12($sp)					# for name buffer
    sw $s5, 16($sp)                 # for .next 
    sw $s0, 20($sp)                 # for hash
    sw $ra, 24($sp)					# Allocate on stack
    sw $v0, 28($sp)                 # for return value 

    jal hash

    move $s0, $v0					# Store hash in s0
	move $s1, $a0					# Store ID in s1

    la $t0, table					# Store table pointer in t0
	sll $s0, $s0, 2					# hash * 4
	add $t0, $s0, $t0				# Now pointing to table[hash] 

	lw $t1, 0($t0)					# Store head pointer in t1
    move $t7, $0                    # set prev to NULL 

	beq $t1, $0, del_not_found		# go to ins_new_hash if table[hash] is EMPTY 
    
    b del_loop

del_not_found:
    la $a0, DELETE
    li $v0, 4
    syscall                         # "DELETE "
    la $a0, L_PARENTHESIS
    li $v0, 4
    syscall                         # "("
    move $a0, $s1
    li $v0, 1
    syscall                         # "ID"
    la $a0, R_PARENTHESIS
    li $v0, 4
    syscall                         # ")"
    la $a0, NOT_DELETE
    li $v0, 4
    syscall                         # " cannot delete because record does not exist"

    lw $s1, 0($sp)					# for ID
	lw $s2, 4($sp)					# for ex1
	lw $s3, 8($sp)					# for ex2
	lw $s4, 12($sp)					# for name buffer
    lw $s5, 16($sp)                 # for .next 
    lw $s0, 20($sp)                 # for hash
    lw $ra, 24($sp)					# Allocate on stack
    lw $v0, 28($sp)                 # for return value  

    addi $sp, $sp, 32              # pop

    jr $ra


del_loop:
    beq, $t1, $0, del_not_found     # branch if at the end 
    lw $a0, 0($t1)                  # deref. to get actual value in container
    lw $t3, 12($t1)                 # t3 points to NEXT - temporary var.
    beq $a0, $s1, del_match_found   # branch if matching ID is found
    move $t7, $t1                   # store t1 in prev, t7
    move $t1, $t3                   # t1 becomes NEXT 
    b del_loop

del_match_found:

    lw $s1, 0($t1)					# Load ID
	lw $s2, 4($t1)					# Load ex2
	lw $s3, 8($t1)					# Load ex3
    lw $s5, 16($t1)                 # load string buffer
    
    la $a0, DELETE                  
    li $v0, 4
    syscall                         # "INSERT "
    la $a0, L_PARENTHESIS
    li $v0, 4
    syscall                         # "("
    lw $a0, 0($t1)                  
    li $v0, 1
    syscall                         # "ID"
    la $a0, R_PARENTHESIS
    li $v0, 4
    syscall                         # ")"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    lw $a0, 4($t1)                  
    li $v0, 1
    syscall                         # "ex1"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    lw $a0, 8($t1)                  
    li $v0, 1
    syscall                         # "ex2"
    la $a0, SPACE
    li $v0, 4
    syscall                         # " "
    la $a0, 16($t1)                           
    li $v0, 4
    syscall                         # "NAME" 
    la $a0, NEWLINE
    li $v0, 4
    syscall                         # " "

    lw $t6, 12($t1)                 # store t1.next in t6 
    beq $t7, $0, del_prev_null      # branch if prev is null 
    
    sw $t6, 12($t7)                 # store curr.next .... in prev.next



    # sw $0, 0($t1)					# Erase ID
	# sw $0, 4($t1)					# Erase ex1
	# sw $0, 8($t1)					# Erase ex2
    # sw $0, 16($t1)                  # Erase string buffer

    lw $s1, 0($sp)					# for ID
	lw $s2, 4($sp)					# for ex1
	lw $s3, 8($sp)					# for ex2
	lw $s4, 12($sp)					# for name buffer
    lw $s5, 16($sp)                 # for .next 
    lw $s0, 20($sp)                 # for hash
    lw $ra, 24($sp)					# Allocate on stack
    lw $v0, 28($sp)                 # for return value 

    addi $sp, $sp, 32               # collapse stack 

    jr $ra

del_prev_null:
    sw $t6, 0($t0)                  # store null in head pointer

    lw $s1, 0($sp)					# for ID
	lw $s2, 4($sp)					# for ex1
	lw $s3, 8($sp)					# for ex2
	lw $s4, 12($sp)					# for name buffer
    lw $s5, 16($sp)                 # for .next 
    lw $s0, 20($sp)                 # for hash
    lw $ra, 24($sp)					# Allocate on stack
    lw $v0, 28($sp)                 # for return value 

    addi $sp, $sp, 32               # collapse stack 

    jr $ra

#
# Print all the member variables for the record with the specified ID, if it exists in the hash table.
# If a record already exists, print "LOOKUP (<ID>) <Exam 1 Score> <Exam 2 Score> <Name>".
# If a record does not exist, print "LOOKUP (<ID>) record does not exist".
# Argument: $a0 (ID)
#
lookup_student:
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
	
	la $t0, table					# Store table pointer in t0
	sll $s0, $s0, 2					# hash * 4
	add $t0, $s0, $t0				# Now pointing to table[hash] 
	lw $t1, 0($t0)					# Store head pointer in t1
	beq $t1, $0, lookup_no_hash		# go to lookup_no_hash if table[hash] is EMPTY

    b lookup_in_hash                # go to in_hash if something is there

lookup_no_hash:

    la $a0, LOOKUP
    li $v0, 4
    syscall                         # "LOOKUP "
    la $a0, L_PARENTHESIS
    li $v0, 4
    syscall                         # "("
    move $a0, $s1
    li $v0, 1
    syscall                         # "ID"
    la $a0, R_PARENTHESIS
   Buffer to store string input
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
.align 2
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
LOOKUP:                 .asciiz     "LOOKUP "                   # Lookup student 
NOT_LOOKUP:             .asciiz     " record does not exist\n"
NOT_INSERTED:           .asciiz     " cannot insert because record exists\n" 
DELETE:                 .asciiz     "DELETE "                   # Delete
NOT_DELETE:             .asciiz     " cannot delete because record does not exist\n" 
$sp)
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
.align 2
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
LOOKUP:                 .asciiz     "LOOKUP "                   # Lookup student 
NOT_LOOKUP:             .asciiz     " record does not exist\n"
NOT_INSERTED:           .asciiz     " cannot insert because record exists\n" 
DELETE:                 .asciiz     "DELETE "                   # Delete
NOT_DELETE:             .asciiz     " cannot delete because record does not exist\n" 
