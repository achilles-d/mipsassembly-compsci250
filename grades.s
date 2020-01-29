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
    # TODO: Implement


#
# Initialize the hash table.
#
init_hash_table:
    # TODO: Implement


#
# Insert the record unless a record with the same ID already exists in the hash table.
# If record does not exist, print "INSERT (<ID>) <Exam 1 Score> <Exam 2 Score> <Name>".
# If a record already exists, print "INSERT (<ID>) cannot insert because record exists".
# Arguments: $a0 (ID), $a1 (exam 1 score), $a2 (exam 2 score), $a3 (address of name buffer)
#
insert_student:
    # TODO: Implement


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
