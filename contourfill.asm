
.data

#You must use accurate an file path.
#These file paths are EXAMPLES,
#These will not work for you!
	
str1:		.asciiz "C:/Users/lidl2/OneDrive/Desktop/homeworks/273a3/Comp273-A3/test1.txt"
str3:		.asciiz "C:/Users/lidl2/OneDrive/Desktop/homeworks/273a3/Comp273-A3/testfill.pbm"	#used as output
err:    	.asciiz "Error occures when finding the file, please check\n"
err_read: 	.asciiz "Error occures when reading the file, please check\n"
err_close: 	.asciiz "Error occures when closing the file, please check\n"
strwrite:      .asciiz "P1\n 50 50\n"
n:	        .asciiz "n"
one: 		.asciiz "1"
zero: 		.asciiz "0"
str2:  		.asciiz "the newbuffer array is \n"
add_zero:	.asciiz "add zero accomplished"
add_one:	.asciiz "add one accomplished"
add_none:	.asciiz "add none accomplished"
buffer:        .space 10000		# buffers for upto 10000 bytes


# the temp buffer that has all the 0s and 1s in the array, without \n
newbuffer: .space 10000	# store 0s and 1s in bytes
	    
	    
newbuff: .space 10000		# (increase sizes if necessary)# not used in my code 



	.text
	.globl main

main:	la $a0,str1		#readfile takes $a0 as input
	jal readfile
	
	# we already fill the array in the first step.
	
	la $a0,newbuffer		#$a0 contains the address of the array that we want to traceback
			
	addi $t0, $zero, 14  # the number can be modified
	move $a1, $t0 # a1 is the i index
	addi $t1, $zero, 29# the number can be modified
	move $a2, $t1 #a2 is the j index
	jal fillregion
	
	
	la $a0, newbuffer
	addi $t1, $zero, 0
	addi $t3, $zero, 2499 
loop_array:
	lb $t2, 0($a0)
	addi $t2, $t2, 48
	sb $t2, 0($a0)
	addi $t1, $t1, 1 #increment t1 by 1
	addi $a0, $a0, 1 #increment a0 by 1
	beq $t1, $t3, continue
	j loop_array		
	
continue:	
	la $a0, str3		#writefile will take $a0 as file location
	la $a1,newbuffer		#$a1 takes location of what we wish to write.
	jal writefile
exit:
	li $v0,10		# exit
	syscall

readfile:
#done in warmup
	move $t1, $a0
	li $v0, 13	#openfile syscall code = 13
	move $a0, $t1
	li $a1, 0 #0 for read file, 1 for write file
	
	syscall
	bgt $zero, $v0, error # check for errors, when error occurs, the return value is negative
	
	move $s0, $v0 #save thee file descriptor to $s0
#Open the file to be read,using $a0
#Conduct error check, to see if file exists
	li $v0, 14
	move $a0, $s0
	la $a1, buffer
	la $a2, 10000
	syscall
	bgt $zero, $v0, error_read
# You will want to keep track of the file descriptor*
	# now print what is inside the file
	li $v0, 4
	la $a0, buffer
	syscall
	 # check for errors (place that returns negative)
	#close the file 
	li $v0, 16
	move $a0, $s0
	syscall
	bgt $zero, $v0, error_close # check for errors
	j end
error: 
	li $v0, 4
	la $a0, err
	syscall
	j end
	
error_read:
	li $v0, 4
	la $a0, err_read
	syscall
	j end	
	
error_close:
	li $v0, 4
	la $a0, err_close
	syscall
	j end
end:	
	#l finished reading to buffer, now we have a "buffer " that contains all 0, 1,\n with ascii values
	# we want to eliminate the \n part and add the 0s and 1s in the new array
	# load content in buffer and check for their ascii values,  
	# now that all the elements in the txt file is in the buffer 
	# in this step we have to access the buffer, take out its values of 0s and 1s, put it into a 1d array 
	#a1 = address of the first buffer with \n in it
	# $a2 = address of the new array
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	addi $s6, $zero, 0
	
	addi $s1, $zero, 1 #t1 = 1 # the "1" that we want to add to the destination array
	
	addi $s2, $zero, 0 #t2 = 0 # the "0" that we want to add to the destination array
	
	addi $s3, $zero, 48 #ascii for 0
	
	addi $s4, $zero, 49 #ascii for 1
	
	addi $s5, $zero, 10 #ascii for \n
	
	addi $t3, $zero, 0 #t3 will be the pointer for newbuffer: 10000 count from 0 to 10000, add 4 each time
	
	la $t1, buffer # this is the index 0 of buffer
	
	la $t3, newbuffer #this is the index 0 of the newbuffer
looparray:
		# if all 0s and 1s are added to newbuffer, terminate and jump to the end 
		
	lb $t0, 0($t1)# load the content in the buffer 
	
	
	
	beq $t0, $s6, finish # if $t0 = 0(it contains the null character we terminates)
	beq $t0, $s3, addzero #if $t0 = 48 then we add a 0 to the array
	# check for ascii in buffer 
	# 48, 49, 10
	beq $t0, $s4, addone #if $t0 = 49 then we add a 1 to the array
	beq $t0, $s5, addnone #if $t0 = 10, then we add nothing to the array
				# in each sub label, we add the 0s and 1s correspond to the ascii value
				# and we increment both index in the buffer array and the new buffer array
				# except the time we find \n in the buffer array
				
	#beq ..... end of file; jump over 
	
jumpback:
	# check if $t0 
	j looparray
	
addone: 
	#t1  = 1; t2 = 0	#array.insert 1 at index a2
	sb $s1, 0($t3)
	addi $t3, $t3, 1
	addi $t1, $t1, 1
	##############################
	
	
	j jumpback
addzero:	
	sb $s2, 0($t3) #array.inset 0 at index a2
	addi $t3, $t3, 1
	addi $t1, $t1, 1
	
	##############################
	
	
	
	j jumpback
addnone:
	addi $t1, $t1, 1
	###############################
	
	
	j jumpback
	
finish:
	
	
	jr $ra



fillregion:
	# a0 = i a3 = j
	# a1 = buffer address: la $a1, newbuffer
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s1, 4($sp) # the i index 
	sw $s2, 8($sp) # the j index 
	sw $s0, 12($sp) # the address of the array
	sw $s5, 16($sp) # the "1" we want to swap inside the array
	sw $s6, 20($sp) # for a = 1 to a = -1
	sw $s7, 24($sp) # for b = 1 to b = -1
	sw $s3, 28($sp) # the unchanged -2 for the range of a and b
	
	# move the arguments into the stack to save them:
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	
	
	# add code here
	#
	#
	#
	# fillregion(i, j, newbuffer)£º
	# 	if newbuffer[i][j] == 1: return
	#	else:
	#		 newbuffer[i][j] = 1
	# 		 do fillregion(i+1, j+1, newbuffer)£º
	# 		 do fillregion(i+1, j, newbuffer)£º
	# 		 do fillregion(i+1, j-1, newbuffer)£º
	# 		 do fillregion(i, j+1, newbuffer)£º
	# 		 do fillregion(i, j-1, newbuffer)£º
	# 		 do fillregion(i-1, j+1, newbuffer)£º
	# 		 do fillregion(i-1, j, newbuffer)£º
	# 		 do fillregion(i-1, j-1, newbuffer)£º
	# }
	
	# get newbuffer[i][j]
	mul $t0, $s1, 50
	add $t1, $t0, $s2 # t1 = s1*50 + s2
	add $t2, $s0, $t1 # $s2 =  $a0 + t1
	lb $t7, 0($t2)
	
	beq $t7, 1, end2 # exit when this index contains 1
	addi $s5, $zero, 1
	sb $s5, 0($t2)
	# [i-1, j-1]routeA, [i-1, j]routeB, [i-1, j+1]routeC
	# [i  , j-1]routeD, [i  , j], [i  , j+1]routeE
	# [i+1, j-1]routeF, [I+1, J]routeG, [I+1, J+1]routeH
	
	
	#		 do fillregion(i+1, j+1, newbuffer)£º
	# 		 do fillregion(i+1, j, newbuffer)£º
	# 		 do fillregion(i+1, j-1, newbuffer)£º
	# 		 do fillregion(i, j+1, newbuffer)£º
	# 		 do fillregion(i, j-1, newbuffer)£º
	# 		 do fillregion(i-1, j+1, newbuffer)£º
	# 		 do fillregion(i-1, j, newbuffer)£º
	# 		 do fillregion(i-1, j-1, newbuffer)£º
	
	addi $s6, $zero, 1 # a = 1
#route_i:
	
	addi $s7, $zero, 1 # b = 1

#route_j:
	add $a1, $s1, $s6 # s1 = i
	add $a2, $s2, $s7 # s2 = j
	jal fillregion
	
	
	addi $s6, $zero, 1
	addi $s7, $zero, 0
	add $a1, $s1, $s6
	add $a2, $s2, $s7
	jal fillregion
	
	addi $s6, $zero, 1
	addi $s7, $zero, -1
	add $a1, $s1, $s6
	add $a2, $s2, $s7
	jal fillregion
	
	addi $s6, $zero, 0
	addi $s7, $zero, 1
	add $a1, $s1, $s6
	add $a2, $s2, $s7
	jal fillregion
	
	
	addi $s6, $zero, 0
	addi $s7, $zero, -1
	add $a1, $s1, $s6
	add $a2, $s2, $s7
	jal fillregion
	
	
	addi $s6, $zero, -1
	addi $s7, $zero, 1
	add $a1, $s1, $s6
	add $a2, $s2, $s7
	jal fillregion
	
	
	addi $s6, $zero, -1
	addi $s7, $zero, 0
	add $a1, $s1, $s6
	add $a2, $s2, $s7
	jal fillregion
	
	addi $s6, $zero, -1
	addi $s7, $zero, 1
	add $a1, $s1, $s6
	add $a2, $s2, $s7
	jal fillregion
	
	addi $s3, $zero, -2 #ignore this 

	
	
end2:	
# now we have an array with all 0s and 1s
	
	lw $ra, 0($sp)
	lw $s1, 4($sp) # the i index 
	lw $s2, 8($sp) # the j index 
	lw $s0, 12($sp) # the address of the array
	lw $s5, 16($sp) # the "1" we want to swap inside the array
	lw $s6, 20($sp) # for a = 1 to a = -1
	lw $s7, 24($sp) # for b = 1 to b = -1
	lw $s3, 28($sp)	 # the unchanged -2
	addi $sp, $sp, 32
	
	jr $ra
	
	
	
writefile:
#done in warmup
	
	
	move $t0, $a0
	# same as the previous one, we open the file first, then read the file
	li $v0, 13
	move $a0, $t0
	li $a1, 1	# 1 for write
	syscall
	bgt $zero, $v0, error1
	move $s1, $v0  # save the file descriptor to s1 for further use
	
	
	li $v0, 15 		#	 write file syscall
	move $a0, $s1 		#	include the file descriptor
	la $a1, strwrite 	# the string that will be writtern into the file
	la $a2, 10   		# P1
				# 50 50 (allocate space)			
	syscall
	bgt $zero, $v0, error_read1
	
	
	
	li $v0, 15 		#	 write file syscall
	move $a0, $s1 		#	include the file descriptor
	la $a1, newbuffer	# the string that will be writtern into the file
	la $a2, 10000   	#buffer 10000
	syscall
	bgt $zero, $v0, error_read1
	
	li $v0, 16
	move $a0, $s1
	syscall
	#close file
	
	j end1
error1:	
	li $v0, 4
	la $a0, err
	syscall
	j end1
error_read1:
	li $v0, 4
	la $a0, err_read
	syscall
	j end1
error_close1:
	li $v0, 4
	la $a0, err_close
	syscall
	j end1
end1:	
	jr $ra
