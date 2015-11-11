.data
arr: .word  64,25,12,22,11
n: .word 5
space:.asciiz  " "          # space to insert between numbers

.text
la $a0,arr
lw $a1,n
jal selectionSort
li   $v0, 10          # system call for exit
syscall               # we are out of here.

swap:
	lw $t0,0($a0)
	lw $t1,0($a1)
	sw $t1,0($a0)
	sw $t0,0($a1)
################################################################################
#####################JUST TO PRINT THE FIRST SWAPPED VALUE######################
################################################################################
	li $v0,1
	add $a0,$t0,$zero
	syscall
###############################PRINT A SPACE####################################
	la   $a0, space       # load address of spacer for syscall
	li   $v0, 4           # specify Print String service
	syscall
################################################################################
#####################JUST TO PRINT THE FIRST SWAPPED VALUE######################
################################################################################   
	jr $ra		

selectionSort:
	addi $sp,$sp,-24
	sw $ra,0($sp) 
	sw $s0,4($sp) #arg[]
	sw $s1,8($sp) #n
	sw $s2,12($sp) #i
	sw $s3,16($sp) #j
	sw $s4,20($sp) #min_index
	
	add $s2,$zero,$zero
	
for1:
	addi $t0,$a1,-1  #toma el valor de n y le resta 1
	slt $t1,$s2,$t0
	beq $t1,$zero,out_of_for1
	add $s4,$zero,$s2 #set min index = i
	addi $s3,$s2,1
		
for2: 
	slt $t1,$s3,$a1
	beq $t1,$zero,out_of_for2
	sll $t0,$s3,2 #a[j]
	add $t0,$a0,$t0
	lw $t0,0($t0) #a[min_index]
	sll $t1,$s4,2
	add $t1,$a0,$t1
	lw $t1,0($t1)
	slt $t0,$t0,$t1 #if j<n
	beq $t0,$zero,next
	add $s4,$zero,$s3
	
next:
	addi $s3,$s3,1
	j for2
	
out_of_for2:
	add $s0,$zero,$a0
	add $s1,$zero,$a1
	sll $a0,$s4,2 #direccion del array en la posicion min_index
	add $a0,$a0,$s0 # $arr[min_index]
	sll $a1,$s2,2 # lo mismo que arriba pero 
	add $a1,$s0,$a1 # $arr[i]
	jal swap
	add $a0,$zero,$s0
	add $a1,$zero,$s1
	addi $s2,$s2,1
	j for1
	
out_of_for1:
	addi $t0,$a1,-1 #index n-1
	sll $t0,$t0,2
	add $t0,$a0,$t0
	lw $t0,0($t0) #load last value
			
################################################################################
##########################JUST TO PRINT THE LAST VALUE##########################
################################################################################
	li $v0,1
	add $a0,$t0,$zero
	syscall
################################################################################
##########################JUST TO PRINT THE LAST VALUE##########################
################################################################################
	
	lw $ra,0($sp) 
	lw $s0,4($sp) #arg[]
	lw $s1,8($sp) #n
	lw $s2,12($sp) #i
	lw $s3,16($sp) 
	lw $s4,20($sp) 
	addi $sp,$sp,24
	jr $ra
			
