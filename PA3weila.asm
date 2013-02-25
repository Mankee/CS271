# Author:	Austin Dubina
# Date:		Feb 21, 2013
# Description:	Calculates the frequency of letters for a given string of text 

.data
#########################################################################
#	Global Program Variables					#
#########################################################################
intro: 			.asciiz	"Letter Frequency Analysis by, Austin Dubina \n"
prompt1: 		.asciiz	"Enter a string to analyze:\n"
colon:			.ascii	":"
text:			.space 1024
			.align 2
freq:			.space 208 

#########################################################################
#	Stack Frame Architecture					#
#########################################################################

	#################
# 36	#    padding	#	
	#################
# 32	#    $ra	#
	#################
# 28	#    $s3	#
	#################
# 24	#    $s2	#
	#################
# 20	#    $s1	#
	#################
# 16	#    $s0	#
	#################
# 12	#    arg(3)	#
	#################
# 8	#    arg(2)	#
	#################
# 4	#    arg(1)	#
	################
# 0 	#    arg(0)	#
	#################
				   				   
				   				   				   				   
		
				   				   				   				   				   				   				   				   
				   				   				   				   				   				   				   				   		   				   				   				   				   				   				   				   		   				   				   				   				   				   				   				   
.text
#########################################################################
#	main()								#
#########################################################################
main:
	jal setup
	jal analyze
	jal results
	
	li $v0, 10			# exit
	syscall





#########################################################################
#	void Setup()							#
#########################################################################
# Pseudocode:
# while (i < 26)
#	freq[i] = l + i
#	print (intro)
#	print (prompt1)
#	read string (text)
# return void

# Registers:
# $s0 = i
# $s2 = tmp1 = starting ascii char ("A") = 65
# $s3 = tmp2 = ending ascii char ("Z") = 90
# $a1 = input buffer

setup:	
# Callee(main) procedure (prologue)
	addiu	$sp, $sp, -36		# pushing the stack
	sw	$ra, 32($sp)		# save return address
	
	sw	$s0, 16($sp)		# saving temprary registers
	sw	$s1, 20($sp)
	sw	$s2, 24($sp)
	sw	$s3, 28($sp)
	

# Callee(main) procedure (body)
	li	$s0, 0			# i = 0
	li	$s2, 65			# tmp1 = "A"
	li	$s3, 90			# tmp2 = "Z"
	li	$a1, 1024		# buffer = 1024 bytes


#	initialize the freq[i] array with char values 'A'-'Z'		
#########################################################################
loop1:	sw   	$s2, freq($s0), 	# freq[i] = tmp2		
	addi	$s0, $s0, 8		# i = i + 8	
	addi	$s2, $s2, 1		# tmp1 = tmp1 + 1		
	ble	$s2, $s3, loop1		# branch if tmp1(A) <= tmp2(Z)	
#########################################################################

	li	$v0, 4			# Print (intro)
	la	$a0, intro		
	syscall	
	
	la	$a0, prompt1		# print (prompt1)
	syscall
	
	li	$v0, 8			# read string (text)
	la	$a0, text
	syscall
	
	jr	$ra			# return (main)

# Callee(main) procuedure (epilogue)
	lw 	$s0, 16($sp)		# restore temporary variables
	lw	$s1, 20($sp)
	lw	$s2, 24($sp)
	lw	$s3, 28($sp)
	
	addiu 	$sp, $sp, 36		# popping the stack

	jr	$ra			# return(void) main





##########################################################################
#	void Analyze(freq[i])						 #
##########################################################################
# Pseudocode:
# while (l < 26)
#	freq[l] = count(l)
#	l++
# return void

# Registers:
# $s0 = i (l idx)
# $s1 = j (freq idx)
# $s2 = tmp1 = starting ascii char ("A") = 65
# $s3 = tmp2 = ending ascii char ("Z") = 90

analyze:
# Callee(main)->caller(count) procedure (prologue)
	addiu	$sp, $sp, -36		# pushing the stack
	sw	$ra, 32($sp)		# save return address	
	
	sw	$s0, 16($sp)		# (callee)saving temprary registers
	sw	$s1, 20($sp)
	sw	$s2, 24($sp)
	sw	$s3, 28($sp)
	
# Callee(main)->caller(count) procedure (body)
	li	$s0, 0			# i = 0
	li	$s1, 4			# j = 4
	li	$s2, 65			# tmp1 = 'A' 
	li	$s3, 90			# tmp2 = 'Z'
		 
loop2:	lw   	$a2, freq($s0)		# arg2 = freq[i]
	
	sw  	$a0, 0($sp)		# (caller) saving args $a0-$a3
	sw	$a1, 4($sp)	
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)
	jal	count			# call procedure (count)	
	sw	$v0, freq($s1)		# freq[j] = return(count)
	lw   	$a0, 0($sp)		# (caller) restoring args $a0-$a3
	lw	$a1, 4($sp)	
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)
	
	addi	$s0, $s0, 8		# i = i + 8
	addi	$s1, $s0, 4		# j = i + 4
	ble	$a2, $s3, loop2		# branch if arg2 <= 90 ('Z')

# Callee(main)->caller(count) procuedure (epilogue)
	lw 	$s0, 16($sp)		# (callee)restore temporary variables
	lw	$s1, 20($sp)
	lw	$s2, 24($sp)
	lw	$s3, 28($sp)
	
	addiu 	$sp, $sp, 36		# popping the stack

	jr	$ra			# return(void) main





##########################################################################
#	int Count(l)							 #
##########################################################################	
# Pseudocode:
# while (text[k] != NULL)
# 	if text[k] == arg2
#		n = n + 1
#	K++
# return n
#
# Registers:
# $s0 = k (text idx)
# $s1 = NULL Char
# $s2 = tmp1= text[k]
# $s3 = tmp2 = arg2 + 32

# Callee(analyze) procedure (prologue)
	lw	$t0, 24($sp)		# arg(0) = tmp1 from caller
	addiu	$sp, $sp, -36		# pushing the stack
	sw	$ra, 32($sp)		# save return address
	
	sw	$s0, 16($sp)		# saving temprary registers
	sw	$s1, 20($sp)
	sw	$s2, 24($sp)
	sw	$s3, 28($sp)

# Callee(analyze) procedure (body)
count:	li	$v0, 0			# n = 0
	li	$s0, 0 			# k = 0
	
loop3:	lw 	$s2, text($s0)		# tmp3 = text[k]
	beq	$s2, $s1, exit	 	# branch if text[k] = NULL
	bne	$s2, $a2, cont1		# if tmp1 != arg2, else (cont1)
	addi	$v0, $v0, 1		# n++
	
cont1:	addi	$s3, $a2, 32 		# tmp2 = arg2 + 32  
	bne	$s3, $a2, cont2		# if tmp2 != arg2, else (cont2)
	addi	$v0, $v0, 1		# n++

cont2:	addi	$s0, $s0, 1		# k++
	j	loop3			# jump loop3

exit:	jr	$ra			# return(n) analyze
	
# Callee(analyze) procedure (epilogue)
	lw 	$s0, 16($sp)		# restore temporary variables
	lw	$s1, 20($sp)
	lw	$s2, 24($sp)
	lw	$s3, 28($sp)
	
	addiu 	$sp, $sp, 36		# popping the stack

	jr	$ra			# return(void) main





##########################################################################
#	Results								 #
##########################################################################
# Pseudocode:
# while (freq[i] <= 90('Z'))
#	print i
#	print j
# return void
#
# Registers:
# $s0 = i
# $s1 = j
# $s2 = tmp1
# $s3 = tmp2

# Callee(main) procedure (prologue)
	addiu	$sp, $sp, -36		# pushing the stack
	sw	$ra, 32($sp)		# save return address
	
	sw	$s0, 16($sp)		# saving temprary registers
	sw	$s1, 20($sp)
	sw	$s2, 24($sp)
	sw	$s3, 28($sp)
	
# Callee(main) procedure (body)
results:li	$s0, 0			# i = 0
	li	$s1, 4			# j = 4
	li	$s2, 90			# tmp1 = 90

loop4:	li	$v0, 11			# Print (freq[i])
	la	$a0, freq($s0)		
	syscall

	la	$a0, colon		# print (':')		
	syscall	
	
	li	$v0, 1			# print (freq[j])
	la	$a0, freq($s1)
	
	addi	$s0, $s0, 8		# i = i + 8
	addi	$s1, $s0, 4		# j = i + 4
	
	lb	$s3, freq($s0)		# tmp2 = freq[i]
	ble	$s3, $s2, loop4		# branch if tmp2 <= tmp1
	
	jr	$ra			# return(void) main

# Callee(main) procedure (epilogue)
	lw 	$s0, 16($sp)		# restore temporary variables
	lw	$s1, 20($sp)
	lw	$s2, 24($sp)
	lw	$s3, 28($sp)
	
	addiu 	$sp, $sp, 36		# popping the stack

	jr	$ra			# return(void) main
