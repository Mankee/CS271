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
	
	# memoization table -- enough space for 25 results
	memo:			.word 	0	# fact(0) = 0
				.word	1	# fact(1) = 1
				.space	96	# space 
	
	# string prompts
	intro: 			.ascii	"Computing Fibonacci numbers, Part II \n" 
				.asciiz "	by, Austin Dubina \n"
	prompt:			.asciiz "Enter a number in range [1..25] "
	range:			.asciiz "That number was out of range, try again"
	recursive:		.asciiz "\n\n== Purely Recursive ==\n"
	memoization:		.asciiz "\n\n== With Memoization ==\n"
	nl:			.asciiz "\n"
	time:			.asciiz "Time: "
	result:			.asciiz "Result: "
	goodbye:		.asciiz "\n\nProgram exited sucessfully, goodbye!"
	
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
		
		li	$v0, 4		# print(recursive) banner
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
	
		li	$v0, 4		# print(memoization) banner
		la	$a0, memoization
		syscall
		
		la	$t0, fibM	# f = fib
		
		# start of testFib(fibM, n) Caller
		sw	$t0, 20($sp)	# save $t0
		sw	$t1, 24($sp)	# save $t1

		sw	$t0, 0($sp)	# arg0 = f
		sw	$t1, 4($sp)	# arg1 = n
		jal	testFib		# jmp(testFib)
		
		sw	$t0, 20($sp)	# restore $t0
		sw	$t1, 24($sp)	# restore $t1	
		# end of testFib(fibM, n) Caller
		
		li	$v0, 4		# print(goodbye)
		la	$a0, goodbye
		syscall
		
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
		
		# start timer
		li	$v0, 30
		syscall 
		move	$s0, $a0
		
		# start of int fib(n) Caller
		sw	$t0, 24($sp)	# save arg0(f)
		sw 	$t1, 28($sp)	# save arg1(n)
		
		sw	$t1, 0($sp)	# arg0 = n
		jalr	$t0		# jmp(f)
		
		lw	$t0, 24($sp)	# restore arg0(f)
		lw	$t1, 28($sp)	# restore arg1(n)
		move 	$t2, $v0	# tmp = fib(n)
		# end of int fib() Caller

		# stop timer
		li	$v0, 30
		syscall 
		move	$s1, $a0

		li	$v0, 4		# print(result)
		la	$a0, result
		syscall
		
		li	$v0, 1		# print(x)
		la	$a0, ($t2)
		syscall
		
		li	$v0, 4		# print(nl)
		la	$a0, nl
		syscall
		
		li	$v0, 4		# print(time)
		la	$a0, time
		syscall
		
		sub	$a0, $s1, $s0	# time delta
		
		li	$v0, 1		# print(y)
		syscall		
		
		lw	$ra, 16($sp)
		addiu 	$sp, $sp, 32	# procedure epilogue - remove stack
		jr	$ra

#########################################################################
#	  int fib(int n)					 	#
#########################################################################
# Pseudocode:
# int fib(int n) {
# 	if (n <= 2){
#		return 1;
# 	}   
# 	x = fib(n - 1)
# 	y = fib(n - 2)
# 	x = x + y
# 	return x
# }
# Registers:
# n = $t0, x = $v0, $t1 = y = (n-1), $t2 = z = (n-2)
fib:		lw	$t0, 0($sp)	# retrive variables from previous stack
		addiu	$sp, $sp, -24	# procedure prologue - pushing stack
		sw    	$ra, 16($sp)
		
		li	$v0, 1		# return 1
		ble   	$t0, 2, end	# if (n < 2) goto end
	
		sw    	$t0, 24($sp)	# (startup) save n
		sw	$t1, 28($sp)	# save y
		sw	$t2, 32($sp)	# save z
		subi  	$t0, $t0, 2	# arg0 = n - 1
		sw 	$t0, 0($sp)	# fib(n-1)
		jal   	fib	
		lw    	$t0, 24($sp)	# (cleanup) restore n
		lw    	$t1, 28($sp)	# (cleanup) restore y
		lw    	$t2, 32($sp)	# (cleanup) restore z
		move	$t1, $v0	# y = n - 1
		
		sw    	$t0, 24($sp)	# (startup) save n
		sw	$t1, 28($sp)	# save y
		sw	$t2, 32($sp)	# save z
		subi  	$t0, $t0, 1	# arg0 = n - 2
		sw 	$t0, 0($sp)	# fib(n - 2)
		jal   	fib	
		lw    	$t0, 24($sp)	# (cleanup) restore n
		lw    	$t1, 28($sp)	# (cleanup) restore y
		lw    	$t2, 32($sp)	# (cleanup) restore z
		move	$t2, $v0	# z = n - 2
		
		add	$v0, $t1, $t2	# x = y + z
		
end:		lw	$ra, 16($sp)	# procedure epilogue - pop stack
		addiu 	$sp, $sp, 24	
		jr	$ra

#########################################################################
#	  int fibM(int n)					 	#
#########################################################################
# Pseudocode:
# int fibM(int n) {
# 	r = memo[n]
#     	if (r == 0) {
#       	x = fibM(n-1)
#       	y = fibM(n-2)
#       	r = x+y
#       	memo[n] = r
#     	}
#	return r
# }
#
# Registers:
# n = $t0, i = $t1, x = $v0, $t2 = [i - 1], $t3 = [i - 2]

fibM:		lw	$t0, 0($sp)	# retrive variables from previous stack
		addiu	$sp, $sp, -32	# procedure prologue - pushing stack
		sw    	$ra, 16($sp)
		
		mul   	$t1, $t0, 4	# i = n * 4
		lw    	$v0, memo($t1)	# x = memo[i]
		bnez  	$v0, end2	# branch if (x == 0)
	
		sw    	$t0, 24($sp)	# (startup) save n
		sw	$t1, 28($sp)	# save i
		subi  	$t0, $t0, 1	# arg0 = n - 1
		sw 	$t0, 0($sp)	# fib(n-1)
		jal   	fibM		
		lw    	$t0, 24($sp)	# (cleanup) restore n
		lw	$t1, 28($sp)	# restore i
		
		subi	$t0, $t0, 1	# [n - 1] = n - 1
		mul	$t1, $t0, 4	# i = n * 4
		lw	$t2, memo($t1)	
		
		subi	$t0, $t0, 1	# [n - 2] = n - 1
		mul	$t1, $t0, 4	# i = n * 4
		lw	$t3, memo($t1)	 
		
		add	$v0, $t2, $t3	# f(n) = [n - 2] + [n - 1]		
		addi	$t0, $t0, 2	# n = n + 2
		mul	$t1, $t0, 4	
		sw	$v0, memo($t1) # 
		
end2:		lw	$ra, 16($sp)	# procedure epilogue - pop stack
		addiu 	$sp, $sp, 32	
		jr	$ra
