# Author:	Austin Dubina
# Date:		2/09/2013
##########################################################################
#	Program Description			 			 #
##########################################################################	
#	Section 1: Introduction						 #									 #
#	+Print an introduction that includes: your name, a title, and    #
#	 (optionally) a description of the program.			 #
#	+Prompt the user to enter their name and read in the string 	 #
#	 input. (You should reserve 64 bytes in data			 #
#	 memory for this string.)					 #
#	+Print a greeting that includes the user's name.		 #
#									 #									 #
#	Section 2: Get and Validate n					 #								 #
#	+Prompt the user to enter a number between 1 and 47 (inclusive); #
#	 read in the input (we'll call this n).				 #
#	+Check that n is within the range. If not, print an error message#
#	 and prompt the user again.					 #
#	+Repeat until the user enters a valid number.			 #			
#									 #									 #
#	Section 3: Calculate and print the frst n Fibonacci numbers	 #									 #
#	-Calculate and print each of the Fibonacci numbers up to and 	 #
#	 including the nth.						 #
#	-The ?rst several numbers should be: 0, 1, 1, 2, 3, 5, 8, 13, 21,#
#	 . . . (Note that you should start at 0!)			 #
#	-Numbers should be printed exactly ?ve per line, with at least 	 #
#	 four spaces between numbers on a line.				 #
#	-Note that you do not need to store the Fibonacci numbers in 	 #
#	 memory. You may just print them as they are computed.		 #
#									 #
#	Section 4: Conclusion						 #
#	+Print a farewell message that again refers to the user's name.	 #
#	+Use the exit system call to end your program.			 #
#									 #
##########################################################################

##########################################################################
#	Program Variables						 #
##########################################################################
.data

	# Program Variables
	userName:		.space	64
	
	# string prompts
	intro: 			.asciiz	"Fibonacci Numbers by, Austin Dubina \n"
	prompt1:		.asciiz	"What is your name user?: "
	prompt2:		.asciiz "Enter a number in range [1..47], oh and... "
	prompt3:		.asciiz "You have disapointed me "
	prompt4:		.asciiz "Do not disapoint me: "
	goodBye:		.asciiz "(Tron) Goodbye user, "
	ninesps:		.asciiz "         "
	spaces:			.asciiz "    "
	space:			.asciiz " "
	nl:			.asciiz "\n"
	
##########################################################################
#	 Section 1: Introduction					 #
##########################################################################
.text
	
	li	$a1, 64		# input buffer = 64 bytes
	li	$t1, 47		# t1 = 47
	
	li	$v0, 4		# Print (intro)
	la	$a0, intro		
	syscall	
	
	la	$a0, prompt1	# print (prompt1)
	syscall
	
	li	$v0, 8		# read string (userName)
	la	$a0, userName
	syscall
	
	j	entern

##########################################################################
#	  Section 2: Get and Validate n					 #
##########################################################################
# Pseudocode:
# while(!((n > 0) && (n <= 47))){
# 	print (prompt3)
#	print (userName)
#	print (prompt2)
#	if (n > 0)
#		if (n <= 47)
#			goto (Section 4)
#	goto (loop)
# }
#
# Register mappings:
# $t0: n
# $t1: 47

loop1:	li	$v0, 4		# print (nl)
	la	$a0, nl
	syscall
	
	la	$a0, prompt3	# print (prompt 3)
	syscall
	
	la	$a0, userName	# print (userName)
	syscall
	
	la	$a0, nl		# print (nl)
	syscall

entern:	li	$v0, 4		#print (prompt2)
	la	$a0, prompt2	
	syscall

	la	$a0, userName	# print (userName)
	syscall
	
	la	$a0, prompt4	# print (prompt4)
	syscall
	
	li	$v0, 5		# read integer($t0)
	syscall
	move 	$t0, $v0

	blez	$t0, loop1	# if n < 0 goto (loop)
	bgt	$t0, $t1, loop1	# if n > 47 goto (loop)
	
##########################################################################
#	Section 3: Calculate and print the frst n Fibonacci numbers	 #
##########################################################################
# Psedocode:
# print (0)
# print (1)
# n-1 = 1
# n-2 = 0
# while (i < n){
# 	F(n) = F(n-1) + F(n-2)
#	
#	if(i/5){
#		print(nl)
#	}
#
#	$t8 = 10
#	while (F(n) > $t8){
#		j++
#		$t8 = $t8 x 10
#	}
#	
#	while (j > 0 ){
#		print(space)
#		j--
#	}
#	print (F(n))
#	i++
#	F(n-2) = F(n-1)
#	F(n-1) = F(n)
#	goto (loop2)
# }
#	
# Register mappings:
# $t0: n
# $t1: tmp variable used for i++, j++, F(1), F(2), and divisor
# $t2: i (initialized to 3)
# $t4: n-2 (initialized to 0)
# $t3: n-1 (initialized to 1)
# $t5: F(n) (initialized to 1)
# $t6: mflo for div result
# $t7: mfhi for div result
# $t8: multiples of 10 to check agaisnt n
# $t9: j (counter for the number of spaces to print before F(n))
	
	li	$t2, 3		# t2 = 3
	li	$t3, 1		# t3 = 1
	li	$t4, 0		# t4 = 0
	li	$t5, 1		# t5 = 1	

	li	$v0, 4		# print(ninesps)
	la	$a0, ninesps	
	syscall

	li	$v0, 1		# print F(1)
	la	$a0, ($t4)
	syscall
	
	li	$v0, 4		# print (spaces)
	la	$a0, spaces
	syscall
	
	beq	$t0, $t3, exit 	# if F(1), exit
	
	li	$v0, 4		# print(ninesps)
	la	$a0, ninesps	
	syscall

	li	$v0, 1		# print (F(2))
	la	$a0, ($t3)		
	syscall
	
	li	$v0, 4		# print(spaces)
	la	$a0, spaces
	syscall
	
	li	$t1, 2		# tmp=2
	
	beq	$t0, $t1, exit	# if F(2) = tmp, exit
	
loop2:	bgt	$t2, $t0, exit	# if i >= n, exit
	
	add	$t5, $t4, $t3	# F(n) = (n-2) + (n-1) 
	#########################################
	# 	space printing logic		#
	#########################################
	li	$t8, 1000000000		
	li	$t9, 0		# j = 0
	
calprn: bge	$t5, $t8, prtn	# branch if F(n) > $t8, prtn
	
	li	$t1, 10		# tmp = 10
	
	div	$t8, $t1	# $t8 = $t8 / 10 (quotient)
	mflo	$t8				
	
	li	$t1, 1		# tmp = 1
	add	$t9, $t9, $t1	# j = j + tmp
	
	j	calprn
	
prtn:	blez	$t9, cont	# branch if j <= 0
	
	li	$v0, 4		# print (space)
	la	$a0, space
	syscall
	
	sub	$t9, $t9, $t1	# j = j - tmp
	
	j	prtn

cont:	li	$v0, 1
	la	$a0, ($t5)	# print (F(n))
	syscall
	
	li	$v0, 4		# print (spaces)
	la	$a0, spaces	# print
	syscall

	li	$t1, 5		# tmp = 5
	
	div	$t2, $t1	# i / tmp
	
	mflo	$t6		# t6 = low register (quotient)
	mfhi	$t7		# t7 = hi register (remainder)
		
	bnez	$t7, resume	# branch if remainder is != 0, resume
	
	li	$v0, 4		# print (nl)
	la	$a0, nl
	syscall

resume:	li	$t1, 1		#i++
	add	$t2, $t2, $t1
	
	move	$t4, $t3	# (n-2) = (n-1)
	
	move	$t3, $t5	# (n-1) = F(n)
	
	j	loop2		# loop

##########################################################################
#	  Section 4: Conclusion						 #
##########################################################################
exit:	li	$v0, 4		# print (nl)
	la	$a0, nl	
	syscall
	
	la	$a0, nl	
	syscall
	
	la	$a0, goodBye	# print (goodBye)
	syscall
	
	la	$a0, userName	# print (userName)
	syscall

	li 	$v0, 10		# exit
	syscall
