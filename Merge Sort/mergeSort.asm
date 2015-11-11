.data
arr: .word  38, 27, 43, 3, 9, 82, 10
l: .word 0
r: .word 6
space:.asciiz  " "          # space to insert between numbers

.text
la $a0,arr
lw $a1,l
lw $a2,r
jal mergeSort
################################################################################
############################JUST TO PRINT THE ARRAY#############################
################################################################################
print:
	add  $t0, $zero, $a0  # starting address of array
	addi $t1,$zero,1
	add  $t1, $t1, $a3  # initialize loop counter to array size
out:  
	lw   $a0, 0($t0)      # load number for syscall
	li   $v0, 1           # specify Print Integer service
	syscall               # print  number
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
syscall   

mergeSort:
	addi $sp,$sp,-20
	sw $ra,0($sp)
	sw $a0,4($sp) #arr[] address
	sw $a1,8($sp) #l
	sw $a2,12($sp) #r

	slt $t0,$a1,$a2 #if(l<r)
	beq $t0,$zero,out_of_mergeSort
	add $t0,$a1,$a2 #l + r
	srl $t0,$t0,1 #(l + (r-l))/2
	
	sw $t0,16($sp) #save m
	
	add $a2,$zero,$t0
	
	jal mergeSort
	lw $a2,12($sp) #r
	lw $a1,16($sp) #m 
	addi $a1,$a1,1 #m+1	
	
	jal mergeSort
	lw $a1,8($sp) #l
	lw $a3,12($sp) #r
	lw $a2,16($sp) #m
	
	jal merge
	
out_of_mergeSort:
	lw $ra,0($sp)
	addi $sp,$sp,20
	jr $ra

merge:
	#i = $t0
	#j = $t1
	#k = $t2
	#n1 = $t3
	#n2 = $t4
	#L[n1] = $t5
	#R[n2] = $t6
	sub $t3,$a2,$a1
	addi $t3,$t3,1 #m-l+1
	sub $t4,$a3,$a2 #r-m
	sll $t7,$t3,2
	sub $sp,$sp,$t7
	add $t5,$sp,$zero #L[n1] address
	sll $t7,$t4,2
	sub $sp,$sp,$t7
	add $t6,$sp,$zero #R[n2] address
	
	add $t0,$zero,$zero #i=0
	
for:
	slt $t7,$t0,$t3
	beq $t7,$zero,out_of_for
	sll $t7,$t0,2
	add $t7,$t5,$t7 #L[i] address
	add $t8,$a1,$t0
	sll $t8,$t8,2
	add $t8,$a0,$t8
	lw $t8,0($t8) #load arr[l+i]
	sw $t8,0($t7)
	addi $t0,$t0,1
	j for
	
out_of_for:
	add $t1,$zero,$zero
		
for2: 
	slt $t7,$t1,$t4
	beq $t7,$zero,out_of_for2
	sll $t7,$t1,2
	add $t7,$t6,$t7 #R[j] address
	add $t8,$a2,$t1
	addi $t8,$t8,1
	sll $t8,$t8,2
	add $t8,$a0,$t8
	lw $t8,0($t8)
	sw $t8,0($t7)
	addi $t1,$t1,1
	j for2
		
out_of_for2:
	add $t0,$zero,$zero
	add $t1,$zero,$zero
	add $t2,$a1,$zero
	
while:
	slt $t7,$t0,$t3
	beq $t7,$zero,out_of_while
	slt $t7,$t1,$t4
	beq $t7,$zero,out_of_while
	#start if
	sll $t7,$t0,2
	add $t7,$t5,$t7
	lw $t7,0($t7) #L[i]
	sll $t8,$t1,2
	add $t8,$t6,$t8
	lw $t8,0($t8) #R[j]
	slt $t9,$t8,$t7  #R[j]<L[i]
	bne $t9,$zero,else
	sll $t9,$t2,2
	add $t9,$a0,$t9
	sw $t7,0($t9)
	addi $t0,$t0,1
	j next
	
else: 
	sll $t9,$t2,2
	add $t9,$a0,$t9
	sw $t8,0($t9)
	addi $t1,$t1,1
	
next:
	addi $t2,$t2,1
	j while
	
out_of_while:
while2:
	slt $t7,$t0,$t3
	beq $t7,$zero,out_of_while2
	sll $t7,$t2,2
	add $t7,$a0,$t7 #arr[k] address
	sll $t8,$t0,2
	add $t8,$t5,$t8 #L[i] address
	lw $t8,0($t8) #L[i] value
	sw $t8,0($t7) #arr[k] = L[i]
	addi $t0,$t0,1
	addi $t2,$t2,1
	j while2
	
out_of_while2:
while3:
	slt $t7,$t1,$t4
	beq $t7,$zero,out_of_while3
	sll $t7,$t2,2
	add $t7,$a0,$t7 #arr[k] address
	sll $t8,$t1,2
	add $t8,$t6,$t8 #R[j] address
	lw $t8,0($t8) #R[j] value
	sw $t8,0($t7) #arr[k] = R[j]
	addi $t1,$t1,1
	addi $t2,$t2,1
	j while3
	
out_of_while3:
	sub $t3,$a2,$a1
	addi $t3,$t3,1 #m-l+l
	sub $t4,$a3,$a2 #r-m
	sll $t7,$t3,2
	add $sp,$sp,$t7
	sll $t7,$t4,2
	add $sp,$sp,$t7
	jr $ra