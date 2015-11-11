.data
arr: .word  64,34,25,12,22,11,90
n: .word 7
space:.asciiz  " "          # space to insert between numbers

.text
la $a0,arr
lw $a1,n
jal bubbleSort
################################################################################
############################JUST TO PRINT THE ARRAY#############################
################################################################################
print:
	add  $t0, $zero, $a0  # starting address of array
	add  $t1, $zero, $a1  # initialize loop counter to array size
out:  
	lw   $a0, 0($t0)      # load number for syscall
	li   $v0, 1           # specify Print Integer service
	syscall               # print number
	la   $a0, space       # load address of spacer for syscall
	li   $v0, 4           # specify Print String service
	syscall               # output string
	addi $t0, $t0, 4      # increment address
	addi $t1, $t1, -1     # decrement loop counter
	bgtz $t1, out         # repeat if not finished
################################################################################
############################JUST TO PRINT THE ARRAY#############################
################################################################################
	li   $v0, 10          # system call for exit
	syscall               # we are out of here.

bubbleSort:
	sub $sp,$sp,20
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	#$s0 i
	#$s1 j
	add $s0,$zero,$zero #i = 0
	for:
	addi $t2,$a1,-1 #n-1
	slt $t3,$s0,$t2 #i < n-1
	beq $t3,$zero,out_of_for
	add $s1,$zero,$zero #j = 0
	for2:
	addi $t2,$a1,-1 #n-1
	sub $t2,$t2,$s0 #n-i-1
	slt $t3,$s1,$t2  #j < n-i-1
	beq $t3,$zero,out_of_for2
	sll $t2,$s1,2 
	add $t2,$a0,$t2 #&arr[j]
	lw $t3,0($t2) #arr[j] value
	addi $t4,$s1,1
	sll $t4,$t4,2
	add $t4,$a0,$t4 #&arr[j+1]
	lw $t5,0($t4) #arr[j+1]
	slt $t3,$t5,$t3  #arr[j+1] < arr[j]
	beq $t3,$zero,next
	sw $s0,12($sp) #true statement
	sw $s1,16($sp) 
	add $a0,$zero,$t2
	add $a1,$zero,$t4
	jal swap
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $s0,12($sp)
	lw $s1,16($sp)
	next:
	addi $s1,$s1,1 #j++
	j for2
	out_of_for2:
	addi $s0,$s0,1 #i++
	j for
	out_of_for:
	lw $ra,0($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $s0,12($sp)
	lw $s1,16($sp)
	addi $sp,$sp,20
	jr $ra

swap:
	lw $t0,0($a0)
	lw $t1,0($a1)
	sw $t1,0($a0)
	sw $t0,0($a1)
	jr $ra	