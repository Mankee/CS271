#Author:	Austin Dubina
#Date:		1/25/2013
#Description:	Write and test a MIPS assembly program that performs the following tasks, in order:
#		1. Print an introduction that includes: your name, a title, and a brief description 
#		of the program.
#
#		2. Prompt the user for two numbers and save these in two registers.
#
#		3. Perform several calculations using these two numbers, and save each result in 
#		data memory. Results to compute: sum, difference, product, (integer) quotient, and 
#		remainder of the two numbers.
#
#		4. Print each of the computed results in a nice way.
#
#		5. Print a concluding message and exit.

.data

intro: 	.ascii  "Math in MIPS! by, Austin Dubina \n\n"
	.ascii 	"Enter two numbers and i'll show you the sum, "
	.asciiz	"difference, product, quotient, and remainder.\n\n"

#result labels
resul1:	.word	0
resul2:	.word	0
resul3:	.word	0
divhi:	.word	0
divlo:	.word	0

#string prompts
promp1:	.asciiz	"First number: "
promp2:	.asciiz	"Second number: "
adding:	.asciiz " + "
subtrk:	.asciiz " - "
multi:	.asciiz " x "
divide:	.asciiz " / "
equals:	.asciiz " = "
remain: .asciiz " R "
bye:	.asciiz "Thanks for using this program, goodbye!"
spaces:	.asciiz "\n"

#beginning of program
.text

	li	$v0, 4		#print sys call
	la	$a0, intro	#load text argument
	syscall
	
	li	$a1, 256	#total bytes to read from buffer	

	la	$a0, promp1	#print first prompt
	syscall
	
	#store readline inteter into num1
	li	$v0, 5		
	syscall
	move	$t1, $v0
	
	#print second prompt
	li	$v0, 4		
	la	$a0, promp2	
	syscall
	
	#store readline integer into num2
	li	$v0, 5
	syscall
	move	$t2, $v0
	
	#printing spaces
	li	$v0, 4		
	la	$a0, spaces	
	syscall
	
	#addition portion of program
	add 	$t0, $t1, $t2	#performs addition
	sw	$t0, resul1
	
	li	$v0, 1		#prints the first num
	la	$a0, ($t1)
	syscall	
	
	li	$v0, 4		#prints "plus" sign
	la	$a0, adding	
	syscall
	
	li	$v0, 1		#prints second number
	la	$a0, ($t2)
	syscall	
	
	li	$v0, 4		#prints "equals" sign
	la	$a0, equals	
	syscall
	
	li	$v0, 1		#prints result number
	lw	$a0, resul1
	syscall	
	
	#printing spaces
	li	$v0, 4		
	la	$a0, spaces	
	syscall
	
	#subtraction portion of program
	sub 	$t0, $t1, $t2	#performs subtraction
	sw	$t0, resul2
	
	li	$v0, 1		#prints the first num
	la	$a0, ($t1)
	syscall	
	
	li	$v0, 4		#prints "minus" sign
	la	$a0, subtrk	
	syscall
	
	li	$v0, 1		#prints second number
	la	$a0, ($t2)
	syscall	
	
	li	$v0, 4		#prints "equals" sign
	la	$a0, equals	
	syscall
	
	li	$v0, 1		#prints result number
	lw	$a0, resul2
	syscall	
	
	#printing spaces
	li	$v0, 4		
	la	$a0, spaces	
	syscall
	
	#multiplication portion of program
	mult 	$t1, $t2	#performs multiplication
	mflo	$t0
	sw	$t0, resul3
	
	li	$v0, 1		#prints the first num
	la	$a0, ($t1)
	syscall	
	
	li	$v0, 4		#prints "multiplication" sign
	la	$a0, multi	
	syscall
	
	li	$v0, 1		#prints second number
	la	$a0, ($t2)
	syscall	
	
	li	$v0, 4		#prints "equals" sign
	la	$a0, equals	
	syscall
	
	li	$v0, 1		#prints result number
	lw	$a0, resul3
	syscall	
	
	#printing spaces
	li	$v0, 4		
	la	$a0, spaces	
	syscall
	
	#division portion of program
	div 	$t1, $t2	#performs division
	mflo	$t0
	mfhi	$t3
	sw	$t0, divlo
	sw	$t3, divhi
	
	li	$v0, 1		#prints the first num
	la	$a0, ($t1)
	syscall	
	
	li	$v0, 4		#prints "division" sign
	la	$a0, divide	
	syscall
	
	li	$v0, 1		#prints second number
	la	$a0, ($t2)
	syscall	
	
	li	$v0, 4		#prints "equals" sign
	la	$a0, equals	
	syscall
	
	li	$v0, 1		#prints quotient result number
	lw	$a0, divlo
	syscall	
	
	li	$v0, 4		#prints "remainder" sign
	la	$a0, remain	
	syscall
	
	li	$v0, 1		#prints remainder result number
	lw	$a0, divhi
	syscall
	
	#printing spaces
	li	$v0, 4		
	la	$a0, spaces	
	syscall
	la	$a0, spaces	
	syscall
	
	#program exit
	li	$v0, 4		#prints "goodbye message" sign
	la	$a0, bye
	syscall

	li 	$v0, 10		#program exit syscall
	syscall