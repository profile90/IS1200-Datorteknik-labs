  # Original statement:
  # analyze.asm
  # This file written 2015 by F Lundevall
  # Copyright abandoned - this file is in the public domain.

  # Corrected by Samuel Green Cheadle for IS1200 at KTH

	.text
main:
	li	$s0,0x30
loop:
	move	$a0,$s0		# copy from s0 to a0
	
	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window

	#addi	$s0,$s0,1	# what happens if the constant is changed?

	addi 	$s0, $s0, 3	# This constant represents the step size. 
				# The step size through the ascii table is one. If changed it
				# will simply change how fast the program steps through the table. Thus,
				# to display one third of the characters, set the step-size rate (1 / n), n = 1 to (1 / 3), n = 3.
					
	#li	$t0,0x5b
	li	$t0,0x5d
	bne	$s0,$t0,loop	# This is the loops stop-condition. It depends on the $t0 register.
				# The $t0 register in the original program is (int)Z + 1 the offest matches the step size, 
				# thus set the offest to the step-size and the stop condition is met in every case.
	nop			# delay slot filler (just in case)

stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)

