.data
arr: .word  12, 11, 13, 5, 6
n: .word 5
space:.asciiz  " "          # space to insert between numbers

.text
la $a0,arr
lw $a1,n
jal insertionSort
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

insertionSort:
	addi $sp,$sp,-12
	sw $s0,0($sp) #i
	sw,$s1,4($sp) #key
	sw $s2,8($sp) #j
	addi $s0,$zero,1
	
for:
	slt $t0,$s0,$a1
	beq $t0,$zero,out_of_for
	sll $t0,$s0,2
	add $t0,$a0,$t0
	lw $t0,0($t0)
	add $s1,$zero,$t0 #key = arr[i]
	addi $s2,$s0,-1 #j=i-1
		
while:
	slt $t0,$s2,$zero # j<0
	bne $t0,$zero,out_of_while
	sll $t1,$s2,2
	add $t1,$a0,$t1
	lw $t1,0($t1)
	slt $t0,$s1,$t1
	beq $t0,$zero,out_of_while
	addi $t0,$s2,1
	sll $t0,$t0,2
	add $t0,$a0,$t0
	sw $t1,0($t0) #arr[j+1]=key
	addi $s2,$s2,-1 #j=j-1
	j while
			
out_of_while:
	addi $t0,$s2,1
	sll $t0,$t0,2
	add $t0,$a0,$t0
	sw $s1,0($t0)
	addi $s0,$s0,1
	j for
				
out_of_for:
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	addi $sp,$sp,12
	jr   $ra
					
					
					
			
					
