# Ryan Porter
# CSI 404 Assignment 3

.data
	prompt:			.asciiz "Enter an expression:"
	infix:			.space 100
	postfix:		.space 100
	evalStack:		.word 100
	preorderStack:	.word 100
	
	preorderString: .asciiz "Pre-order traversal: "
	resultString: 	.asciiz "\nNumerical result: "
	postfixString:	.asciiz "\nStack based Postfix: "

.text
.globl main

main:
input:	
	li $v0, 4							# Promps user
	la $a0, prompt
	syscall
	
	li $v0, 8							# Gets infix and stores in $s0
	la $a0, infix
	li $a1, 100
	move $s0, $a0
	syscall
	
	
convertToPostfix:	
	li $t0, 0 
	loop:
	
		lb $t1, 0($s0)						# Loads character from expression
		
		beq $t1, $zero, buildTree				# If character is empty, go to buildTree
		
		li $t2, '0'						# If character is 0, to go num
		beq $t2, $t1, num
		
		li $t2, '1'						# If character is 1, to go num
		beq $t2, $t1, num
		
		li $t2, '2'						# If character is 2, to go num
		beq $t2, $t1, num
		
		li $t2, '3'						# If character is 3, to go num
		beq $t2, $t1, num
		
		li $t2, '4'						# If character is 4, to go num
		beq $t2, $t1, num
		
		li $t2, '5'						# If character is 5, to go num
		beq $t2, $t1, num

		li $t2, '6'						# If character is 6, to go num
		beq $t2, $t1, num
		
		li $t2, '7'						# If character is 7, to go num
		beq $t2, $t1, num
		
		li $t2, '8'						# If character is 8, to go num
		beq $t2, $t1, num

		li $t2, '9'						# If character is 9, to go num
		beq $t2, $t1, num
		
		li $t2, '+'  						# If character is +, to go expr
		beq $t2, $t1, expr
		
		li $t2, '-'						# If character is -, to go expr
		beq $t2, $t1, expr
		
		li $t2, '('						# If character is (, to go oParen
		beq $t2, $t1, oParen
		
		li $t2, ')'						# If character is ), to go cParen
		beq $t2, $t1, cParen
		
		j done
	
	num:
		sb $t2, postfix($t0)					# Add number to infix array
		addi $t0, $t0, 1					# Add Increase array size
		j done							# Move to done
		
	expr:
		addi $sp, $sp, -4					# Increase stack size	
		sb $t2, ($sp)						# Add expression to stack
		j done							# Move to done

	oParen:	
		addi $sp, $sp, -4					# Increase stack size
		sb $t2, ($sp)						# Add ( to stack
		j done							# Move to done

	
	cParen:
		li $t2, '('
		loop2:	
			lb $t1, ($sp)					# Pull char from stack
			beq $t1, $zero, done				# If stack is empty, go to done
			addi $sp, $sp, 4				# Go to next char in stack
			beq $t1, $t2, done				# If char pulled from stack = '(' go to done
			sb $t1, postfix($t0)				# Add char to infix
			addi $t0, $t0, 1				# Increase array amount
			j loop2
		j done
	
	done:
		addi $s0, $s0, 1					# Move to next character in expression
		j loop							# Loop to top

	
	buildTree:
		li $t0, 0
		
		buildTreeLoop:
		
		lb $t1, postfix($t0)
		
		beq $t1, $zero, treeDone
		
		li $t2, '0'						# If character is 0, to go numTree
		beq $t2, $t1, numTree
		
		li $t2, '1'						# If character is 1, to go numTree
		beq $t2, $t1, numTree
		
		li $t2, '2'						# If character is 2, to go numTree
		beq $t2, $t1, numTree
		
		li $t2, '3'						# If character is 3, to go numTree
		beq $t2, $t1, numTree
		
		li $t2, '4'						# If character is 4, to go numTree
		beq $t2, $t1, numTree
		
		li $t2, '5'						# If character is 5, to go numTree
		beq $t2, $t1, numTree

		li $t2, '6'						# If character is 6, to go numTree
		beq $t2, $t1, numTree
		
		li $t2, '7'						# If character is 7, to go numTree
		beq $t2, $t1, numTree
		
		li $t2, '8'						# If character is 8, to go numTree
		beq $t2, $t1, numTree

		li $t2, '9'						# If character is 9, to go numTree
		beq $t2, $t1, numTree
	
		li $t2, '+'  						# If character is +, to go exprTree
		beq $t2, $t1, exprTree
		
		li $t2, '-'						# If character is -, to go exprTree
		beq $t2, $t1, exprTree
	
		numTree: 							
			li $v0, 9
			addi $a0, $zero, 12
			syscall
			add $t2, $v0, $zero
		
			sw $t1, 0($t2)
			sw $zero, 4($t2)
			sw $zero, 8($t2)
		
			addi $sp, $sp, -12
			sw $t2, ($sp)

			j nextTree
		
		exprTree:
	
			lw $t3, ($sp)					# Pop Right from stack and store in $t3
			addi $sp, $sp, 12
		
			lw $t4, ($sp)					# Pop Left from stack and store in $t4
			addi $sp, $sp, 12				
		
			li $v0, 9					# Make space for $t5 node
			addi $a0, $zero, 12
			syscall
			add $t5, $v0, $zero
		
			sw $t1, 0($t5)					# Store value
			sw $t4, 4($t5)					# Store left
			sw $t3, 8($t5)					# Store right
			
			addi $sp, $sp, -12				# Push new node to Stack
			sw $t5, ($sp)
	
			j nextTree
		
		nextTree:
			addi $t0, $t0, 1
			j buildTreeLoop 
	
	treeDone:
		lw $s0, ($sp)						# Root stored in $s0
		addi $sp, $sp, 12
	
	preorder:
		li $v0, 4
		la $a0, preorderString
		syscall
		
		li $t0, 0						# Stack Count
		sw $s0, preorderStack($t0)
		addi $t0, $t0, 4
		preorderLoop:
			beq $t0, 0, output
			addi $t0, $t0, -4
			lw $t1, preorderStack($t0)			# Current Node
			lw $t2, 0($t1)					# Current Value
			
			li $v0, 11					# Print value
			move $a0, $t2
			syscall
			
			lw $t2, 8($t1)					# Right
			lw $t3, 4($t1)					# Left
			
			beq $t2, $zero, preorderNext
			sw $t2, preorderStack($t0)
			addi $t0, $t0, 4
			
			preorderNext:
			
			beq $t3, $zero, preorderLoop
			sw $t3, preorderStack($t0)
			addi $t0, $t0, 4
			
			j preorderLoop

output:
	li $t0, 0							# Loop Count
	
	li $v0, 4
	la $a0, postfixString
	syscall
	
	printLoop:				
	lb $a0, postfix($t0)						# Load character from postfix stack
	beq $a0, $zero, evaluate					# If character is empty, go to evaluate
	li $v0, 11							
	syscall								# Print character
	addi $t0, $t0, 1						# Increase loop count
	j printLoop							# Loop
	
evaluate:
	li $t0, 0							# Stack count
	li $t1, 0							# Loop count
	
	evalLoop:
		lb $t2, postfix($t1)					# Load character from postfix stack		
		beq $t2, $zero, printEval				# If character is empty, go to output
		
		li $t3, '0'						
		bne $t2, $t3, notZero					# If character is not 0, go to notZero
		li $t2, 0
		sw $t2, evalStack($t0)					# Push 0 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notZero:	
		li $t3, '1'
		bne $t2, $t3, notOne					# If character is not 1, go to notOne
		li $t2, 1
		sw $t2, evalStack($t0)					# Push 1 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notOne:
		li $t3, '2'
		bne $t2, $t3, notTwo					# If character is not 2, go to notTwo
		li $t2, 2
		sw $t2, evalStack($t0)					# Push 2 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notTwo:
		li $t3, '3'
		bne $t2, $t3, notThree					# If character is not 3, go to notThree
		li $t2, 3
		sw $t2, evalStack($t0)					# Push 3 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notThree:
		li $t3, '4'
		bne $t2, $t3, notFour					# If character is not 4, go to notFour
		li $t2, 4
		sw $t2, evalStack($t0)					# Push 4 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notFour:
		li $t3, '5'
		bne $t2, $t3, notFive					# If character is not 5, go to notFive
		li $t2, 5
		sw $t2, evalStack($t0)					# Push 5 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notFive:
		li $t3, '6'
		bne $t2, $t3, notSix					# If character is not 6, go to notSix
		li $t2, 6
		sw $t2, evalStack($t0)					# Push 6 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notSix:
		li $t3, '7'
		bne $t2, $t3, notSeven					# If character is not 7, go to notSeven
		li $t2, 7
		sw $t2, evalStack($t0)					# Push 7 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notSeven:
		li $t3, '8'
		bne $t2, $t3, notEight					# If character is not 8, go to notEight
		li $t2, 8
		sw $t2, evalStack($t0)					# Push 8 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		notEight:
		li $t3, '9'
		bne $t2, $t3, plus					# If character is not 9, go to plus
		li $t2, 9
		sw $t2, evalStack($t0)					# Push 9 to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next							# Jump to next
		
		plus: 
		li $t3, '+'
		bne $t2, $t3, minus					# If character is not +, go to minus
		addi $t0, $t0, -4					# Decrease stack count
		lw $t4, evalStack($t0)					# Pop first number from stack, store in $t4
		addi $t0, $t0, -4					# Decrease stack count
		lw $t5, evalStack($t0)					# Pop second number from stack, store in $t5
		add $t6, $t5, $t4					# $t6 = $t5 + $t4
		sw $t6, evalStack($t0)					# Push sum to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next
		
		minus:
		li $t3, '-'
		bne $t2, $t3, next					# If character is not -, go to next
		addi $t0, $t0, -4					# Decrease stack count
		lw $t4, evalStack($t0)					# Pop first number from stack, store in $t4
		addi $t0, $t0, -4					# Decrease stack count
		lw $t5, evalStack($t0)					# Pop second number from stack, store in $t5
		sub $t6, $t5, $t4					# $t6 = $t5 - $t4
		sw $t6, evalStack($t0)					# Push sum to evalStack
		addi $t0, $t0, 4					# Increase stack count
		j next
		
		next:
			addi $t1, $t1, 1				# Increase loop count
		
		j evalLoop						# Loop


printEval:
	li $v0, 4
	la $a0, resultString
	syscall
	
	
	li $t0, 0
	lw $t1, evalStack($t0)						# Load first item in evalStack
	li $v0, 1
	move $a0, $t1
	syscall								# Print answer from evalStack



exit:
	li $v0, 10							# Ends program
	syscall
