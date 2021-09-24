.data
	msg: 	.asciiz "Hello World!\n"
	char: 	.byte 	'x'
	age: 	.word 	20
	temp:	.word	-1
	pi:		.float 	3.14
	str1: 	.asciiz	"\nI am "
	str2: 	.asciiz	" years old\n"
	
.text
	# printing string
	li 		$v0, 4
	la 		$a0, msg
	syscall
	
	# printing char
	li 		$v0, 4
	la 		$a0, char
	syscall
	
	# printing float (double is super hard, don't do it)
	li		$v0, 2
	lwc1 	$f12, pi
	syscall	
	
	# Making a comibination of str-int-str
	li 		$v0, 4
    la 		$a0, str1
    syscall
    
    # printing int
    li 		$v0, 1
    lw		$t0, temp
    mul		$t0, $t0, 4
    add 	$a0, $t0, $t0
	syscall
	
	li		$v0, 1
	li		$t0, 5
	li		$t1, 2
	div		$t0, $t0, $t1
	mfhi	$a0
	syscall

    
