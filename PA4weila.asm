# Author:	Austin Dubina
# Date:		3/11/2013
#########################################################################
#	Program Description			 		 	#
#########################################################################	
# Compare the time performance of two different recursive functions for	#
# computing a Fibonacci number -one that is purely recursive, and one  	#
# that uses a memoization table to quickly return previously computed 	# 
# results.								#
#########################################################################

#########################################################################
# 	void main()							#
#########################################################################
# +Print an introduction including your name, a title, and a notice of 	#
#  any extra credit you attempted.					#
# +Call the procedure getN and save the result, n.			#
# +Print a purely recursive banner, as in the example output.		#
# +Call the procedure testFib, passing a pointer to fib and the value n.#
# -Print a with memoization banner, as in the example output.		#
# -Call the procedure testFib, passing a pointer to fibM and the value n#
# -Use the exit system call to end your program				#
#########################################################################
#	int getN()							#
#########################################################################
# +Prompt the user to enter a number between 1 and 25 (inclusive); 	#
#  read in the input (n).						#
# +Check that n is within range. If not, print an error message and 	#
#  repeat until the user enters a valid number.				#
# +Return n								#
#########################################################################
#	int fib(int n)							#
#########################################################################
# -Calculate and return the nth Fibonacci number using a recursive 	#
#  algorithm.								#
#########################################################################
#	int fibM(int n)							#
#########################################################################
# -Calculate and return the nth Fibonacci number using a memoized 	#
#  recursive algorithm.							#
#########################################################################
#	void testFib(f, n)						#
#########################################################################
# +This procedure takes two arguments: The first, f, is the address of a#
#  function that takes an integer and produces an integer 		#
#  (i.e. a function pointer). The second, n, is an integer.		#
# -Get the current system time, start, using system call 30. you will 	#
#  have to look at the MARS documentation (? button) to learn the 	#
#  interface to this system call.					#
# +Call the function f with argument n and save the result.		#
# -Get the current system time, stop.					#
# -Print out the result and the time it took to compute the value, 	#
#  calculated as stop  start.						#
#########################################################################

#########################################################################
#	Program Variables						#
#########################################################################
.data

	# Program Variables
	userName:		.space	64
	
	# string prompts
	intro: 			.ascii	"Computing Fibonacci numbers, Part II \n" 
				.asciiz "	by, Austin Dubina \n"
	prompt:			.asciiz "Enter a number in range [1..25] "
	range:			.asciiz "That number was out of range, try again"
	recursive:		.asciiz "== Purely Recursive ==\n"
	memoization:		.asciiz "== With Memoization ==\n"
	ninesps:		.asciiz "         "
	spaces:			.asciiz "    "
	space:			.asciiz " "
	nl:			.asciiz "\n"

.text	
#########################################################################
#	 void main()							#
#########################################################################
# Pseudocode:
# void main(){
# 	print (intro);
#	n = getN;
#	testFib(fib, n);
#	testFib(fibM, n);
#	return 0;
# }
# Registers:
# f = $t0, n = $t1

	
main:		addiu	$sp, $sp, -24	# procedure prologue - pushing stack
		li	$t0, 0		# initialize n = 0
	
		li	$v0, 4		# Print (intro)
		la	$a0, intro		
		syscall	
	
		jal	getN  		# n = getN()
		move 	$t1, $v0	
		
		li	$v0, 4		# print(recursive)
		la	$a0, recursive
		syscall
		
		la	$t0, fib	# f = fib
		
		# start of testFib(fib, n) caller
		sw	$t0, 20($sp)	# save $t0
		sw	$t1, 24($sp)	# save $t1

		sw	$t0, 0($sp)	# arg0 = f
		sw	$t1, 4($sp)	# arg1 = n
		jal	testFib		# jmp(testFib)
		
		sw	$t0, 20($sp)	# restore $t0
		sw	$t1, 24($sp)	# restore $t1	
		# end of testFib(f, n) caller
	
		# start of testFib(fibM, n) Caller
		#la	$a0, fibM 	# testFib(fibM, n)
		#move 	$a1, $v0
		#jal	testFib	
		# end of testFib(fibM, n) Caller
		
		addiu $sp, $sp, 24	# procedure epilogue - remove stack
		li    $v0, 10		# exit
		syscall

#########################################################################
#	  int getN()						 	#
#########################################################################
# Pseudocode:
# while(!((n > 0) && (n <= 25))){
# 	print (prompt);
#	readline(n);
#	if (n > 0){
#		if (n <= 25){
#			return n;
#		{
#	}
#	print (range);
# }
# Register mappings:
# max => $t0, n => $v0, 

getN:		addiu	$sp, $sp, -16	# procedure prologue - pushing stack
		li	$t0, 25		# max = 25
		li	$t1, 0		# n = 0
	
getNLoop:	li	$v0, 4		# print (nl)
		la	$a0, nl
		syscall
	
		la	$a0, prompt	# print (prompt)
		syscall
	
		li	$v0, 5		# read integer(n)
		syscall
		#move 	$t1, $v0	

		blez	$v0, wrong	# if n < 0 goto (wrong)
		bgt	$v0, $t0, wrong	# if n > 25 goto (wrong)
	
		addiu 	$sp, $sp, 16	# procedure epilogue - remove stack
		jr	$ra

wrong:		li	$v0, 4		# print (range)
		la	$a0, range
		syscall
	
		j getNLoop

#########################################################################
#	  void testFib(f, n)					 	#
#########################################################################
# Pseudocode:
# start (timer)
# 
# stop (timer)
#
# registers:
# f => $t0, n => $t1, x = $v0, tmp = $t2

testFib:	lw	$t0, 0($sp)	# retrieve variables from previous stack
		lw	$t1, 4($sp)
		addiu	$sp, $sp, -32	# procedure prologue - pushing stack
		sw	$ra, 16($sp)
		
		# start of int fib(n) Caller
		sw	$t0, 24($sp)	# save arg0(f)
		sw 	$t1, 28($sp)	# save arg1(n)
		
		sw	$t1, 0($sp)	# arg0 = n
		jalr	$t0		# jmp(f)
		
		lw	$t0, 24($sp)	# restore arg0(f)
		lw	$t1, 28($sp)	# restore arg1(n)
		move 	$t2, $v0	# tmp = fib(n)
		# end of int fib() Caller
		
		li	$v0, 1
		la	$a0, ($t2)
		syscall
		
		lw	$ra, 16($sp)
		addiu 	$sp, $sp, 32	# procedure epilogue - remove stack
		jr	$ra

#########################################################################
#	  int fib(int n)					 	#
#########################################################################
# Pseudocode:
# int fib(int n) {
# 	if (n < 2){
#     		return 1;
# 	}else{
# 		return fibonacci(n-2) + fibonacci(n-1);
#	}
# }
# Registers:
# n = $t0, x = $v0, n-1 = $t1, n-2 = $t2
fib:		lw	$t0, 0($sp)	# retrive variables from previous stack
		addiu	$sp, $sp, -24	# procedure prologue - pushing stack
		sw    	$ra, 16($sp)
		
		blt   	$t0, 2, end	# if (n < 2) goto end
	
		sw    	$t0, 24($sp)	# (startup) save n
		subi  	$t0, $t0, 1	# arg0 = n - 1
		sw 	$t0, 0($sp)	# fib(n-1)
		jal   	fib		
		lw    	$t0, 24($sp)	# (cleanup) restore n

end:		bne	$t0, 1, skip	# intialize seed values
		li	$t1, 1		# n - 1 = 1
		li	$t2, 0		# n - 2 = 0
		
skip:		add	$v0, $t1, $t2	# f(n) = (n - 1) + (n - 2)
		move	$t2, $t1
		move 	$t1, $v0
		
		lw	$ra, 16($sp)
		addiu 	$sp, $sp, 24	# procedure epilogue - pop stack
		jr	$ra

#########################################################################
#	  int fibM(int n)					 	#
#########################################################################
# Pseudocode:
#
# Registers:
#
fibM:
