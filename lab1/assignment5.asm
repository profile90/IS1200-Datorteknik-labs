  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
  
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
	li $t0, 2400
	# this value depends on the clock frequency
	# For the MIPS architecture, according to https://en.wikipedia.org/wiki/Cycles_per_instruction
	# The value of a R-type and Branch instruction maps as such: (nop, add, blt) => (3 c, 3 c, 4 c)    
	# To find the Execution time we replace CPI (which is an average) with out constant nop_t


while:
	subi $s1, $s1, 1
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
	move $s6, $0		# memory-counter <- unneccassary <-- whoops sort of neccesarry
loopStart:
	srlv $a0, $s1, $s7	# a0 = (s7 >> s1);
	subi $s7, $s7, 4		# decrement shift-counter s7 -= 4;
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
	
	
	# make a shifter-counter that starts at 12 [*]
	# make memory-counter [*]
	# shift [*]
	# jump to hexasc [*]
	# save byte [*]
		# write memory [*]
		# increment memory [*]
	# subtract 4 from shift-counter [*]
	# check if counter is two [*]
		# if counter is two [*]
			# increment memory counter [*]
			# increment memory [*]
			# save a 0x3a to memory [*] 
			# return to loop [*]
		# else 
			# do nothing [*]
	# check if counter less than or 0 [*]
		# if counter is less than or zero
			# exit loop [*]
			# add EOS, null, 0x00, nada, finito [*]

