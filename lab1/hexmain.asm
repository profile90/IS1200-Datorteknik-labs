  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,0xf		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #


hexasc:
	andi $t0, $a0, 0xf	# Mask off all bits past 0xf, so there is some period to the input (17 becomes 2), etc
	blt  $t0, 10, decimal	# Check if less than 10, thus still decimal
	addi $t0, $t0, 0x27	# Add ((int)'a' - 10) so that the input matches the ascii-table for 'a' (48 + (49 - 10) = 48 + 39 = 97)
decimal:
	addi $t0, $t0, 0x30 	# Add (int)'0' so that the input matches the ascii-table for '0'
	move $v0, $t0 		# Move $t0 to the return register $v0
	jr $ra
# All values between -INT_MAX and 10 will branch to the taken branch notChar
