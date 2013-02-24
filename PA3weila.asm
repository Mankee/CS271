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
freq:			.space 130 # array of structs that store the ascii dec value and it's
				   # number of occurances ('A' - 'Z')

.text
#########################################################################
#	Main Program							#
#########################################################################
main:
	jal setup
	jal analyze
	jal results
	
	li $v0, 10		# exit
	syscall

#########################################################################
#	Setup 								#
#########################################################################
# Pseudocode:
# while (i < 26)
#	freq[i] = l + i
#	print (intro)
#	print (prompt1)
#	read string (text)
# return void

# Registers:
# $t0 = i
# $t2 = tmp1 = starting ascii char ("A") = 65
# $t3 = tmp2 = ending ascii char ("Z") = 90
# $a1 = input buffer

setup:	li	$t0, 0			# i = 0
	li	$t2, 65			# tmp1 = "A"
	li	$t3, 90			# tmp2 = "Z"
	li	$a1, 1024		# buffer = 1024 bytes

#########################################################################
#	initialize the freq[i] array with char values 'A'-'Z'		#		
#########################################################################
loop1:	sb	$t2, freq($t0), 	# freq[i] = tmp2		#
	addi	$t2, $t2, 1		# tmp1 = tmp1 + 1		#
	addi	$t0, $t0, 5		# i = i + 5			#
	ble	$t2, $t3, loop1		# branch if tmp1(A) <= tmp2(Z)	#
#########################################################################

	li	$v0, 4		# Print (intro)
	la	$a0, intro		
	syscall	
	
	la	$a0, prompt1	# print (prompt1)
	syscall
	
	li	$v0, 8		# read string (text)
	la	$a0, text
	syscall
	
	jr	$ra		# return (main)

##########################################################################
#	Analyze								 #
##########################################################################
# Pseudocode:
# while (l < 26)
#	freq[l] = count(l)
#	l++
# return void

# Registers:
# $t0 = i (alpha idx)
# $t1 = j (freq idx)
# $t2 = tmp1 = starting ascii char ("A") = 65
# $t3 = tmp2 = ending ascii char ("Z") = 90
# $a1 = input buffer

analyze:li	$t0, 0			# i = 0
	li	$t1, 1			# j = 1
	li	$t2, 65			# tmp1 = 'A' 
	li	$t3, 90			# tmp2 = 'Z'
		 
loop2:	lb 	$a2, freq($t0)		# arg2 = freq[i]
	jal	count			# call procedure (count)	
	sw	$v0, freq($t1)		# freq[j] = return
	addi	$t0, $t0, 5		# i = i + 5
	addi	$t1, $t0, 1		# j = i + 1
	ble	$a2, $t3, loop2		# branch if arg2 <= 90 ('Z')

	jr	$ra			# return (main)

##########################################################################
#	Count								 #
##########################################################################	
# Pseudocode:
# while (text[k] != NULL)
# 	if text[k] == arg2
#		n = n + 1
#	K++
# return n
#
# Registers:
# $v0 = n
# $t4 = k (text idx)
# $t5 = NULL Char
# $t6 = tmp3
# $t7 = tmp4

count:	li	$v0, 0			# n = 0
	li	$t4, 0 			# k = 0
	
loop3:	lb	$t6, text($t4)		# tmp3 = text[k]
	bne	$t6, $a2, cont1		# if tmp3 != arg2, else (cont1)
	addi	$v0, $v0, 1		# n++
	
cont1:	addi	$t7, $a2, 32 		# tmp4 = arg2 + 32  
	bne	$t6, $a2, cont2		# if tmp4 != arg2, else (cont2)
	addi	$v0, $v0, 1		# n++

cont2:	addi	$t4, $t4, 1		# k++
	bne	$t4, $t5, loop3 

	jr	$ra			# return (analyze)

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
# $t0 = i
# $t1 = j
# $t3 = tmp2
# $t8 = tmp5

results:li	$v0, 0			# i = 0
	li	$t1, 1			# j = 1
	li	$t3, 90			# tmp2 = 90

loop4:	li	$v0, 11			# Print (freq[i])
	la	$a0, freq($t0)		
	syscall

	la	$a0, colon		# print (':')		
	syscall	
	
	li	$v0, 1			# print (freq[j])
	la	$a0, freq($t1)
	
	addi	$t0, $t0, 5		# i = i + 5
	addi	$t1, $t0, 1		# j = i + 1
	
	lb	$t8, freq($t0)		# $t8 = freq[i]
	ble	$t8, $t3, loop4		# branch if tmp5 <= tmp2
	
	jr	$ra			# return (main)
