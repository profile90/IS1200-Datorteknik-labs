  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
  # Please keep the two macros PUSH and POP unchanged
  #
.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
  #
  # Please add your own code below this line
  #

.global hexasc
.global delay
.global time2string 

hexasc:
	andi $t0, $a0, 0xf	# Mask off all bits past 0xf, so there is some period to the input (17 becomes 2), etc
	blt  $t0, 10, decimal	# Check if less than 10, thus still decimal
	nop
	addi $t0, $t0, 0x27	# Add ((int)'a' - 10) so that the input matches the ascii-table for 'a' (48 + (49 - 10) = 48 + 39 = 97)
decimal:
	addi $t0, $t0, 0x30 	# Add (int)'0' so that the input matches the ascii-table for '0'
	move $v0, $t0 		# Move $t0 to the return register $v0
	jr $ra
	nop
delay:
	PUSH $s0
	PUSH $s1
	blez $a0, inputZero	# branch to end if ms is less than or equal to 0 
	nop
 	move $s0, $0		# Create iterator
 	move $s1, $a0 		# Save ms 
	li $t0, 26666660
	# this value depends on the clock frequency
	# For the MIPS architecture, according to https://en.wikipedia.org/wiki/Cycles_per_instruction
	# The value of a R-type and Branch instruction maps as such: (nop, add, blt) => (3 c, 3 c, 4 c)    
	# To find the Execution time we replace CPI (which is an average) with out constant nop_t


while:
	sub $s1, $s1, 1
NOPloop:
	nop
	addi $s0, $s0, 1
	blt $s0, $t0, NOPloop
	nop
	bgt $s1, $0, while
	nop
	
	POP $s1
	POP $s0		
inputZero:	
	jr $ra
	nop
 
 
 
time2string: 
	PUSH $ra
	PUSH $s0
	PUSH $s1
        PUSH $s6
	PUSH $s7
	
	move $s0, $a0 		# Save address 
	move $s1, $a1		# Save value
	li $s7, 12 		# shift-counter
	move $s6, $0		# memory-counter <- unnecessary <-- whoops sort of neccesary
loopStart:	
	srlv $a0, $s1, $s7	# a0 = (s7 >> s1);
	sub $s7, $s7, 4		# decrement shift-counter s7 -= 4;
	jal hexasc		# hexasc(a0) --> returns v0
	nop
	sb $v0, 0($s0)		# write to memory at s0 with v0		
	addi $s0, $s0, 1 	# address + memory-counter (1 byte steps)
	addi $s6, $s6, 1	# increment memory-counter by 1 byte
	beq  $s6, 2, colon	# jump and insert a (int)':' into the next memory position
	nop
returnColon: 
	bgez $s7, loopStart	# if(shiftCounter >= 0) goto loopStart
	nop
	sb $0, 0($s0)		# Save null byte for EOS ('\0')

	POP $s7
        POP $s6
	POP $s1
	POP $s0
	POP $ra
	jr $ra
	nop


colon: 				# is run once, when the memory-counter is 2 (xx->:<-xx)
	addi $t1, $0, 0x3a		# load (int)':' into t0
	sb $t1, 0($s0)		# write 0x3a to memory at s0 with t0
					
	addi $s0, $s0, 1 	# address + memory-counter (1 byte steps)
	addi $s6, $s6, 1	# increment memory-counter by 1 byte
	j returnColon		# return to the loop
	nop
	
