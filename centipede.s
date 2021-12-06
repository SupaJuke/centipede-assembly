#####################################################################
#
# CSC258H Winter 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Supanat Wangsutthitham, 1006164669
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the project handout for descriptions of the milestones)
# - Milestone 3
#
# Which approved additional features have been implemented?
# (See the project handout for the list of additional features)
# - (None)
#
# Any additional information that the TA needs to know:
# - (None)
#
#####################################################################

.data
	displayAddress: .word 0x10008000
	bugLoc: 		.word 975
	centiLoc: 		.word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 # 0 = tail; 9 = head
	centiDir: 		.word 1:10 	#  1 = right; -1 = left
	dartsLoc: 		.word -1:32 # -1 = not existing
	fleaLoc: 		.word -1:32	# -1 = not existing
	hitCounter: 	.word 0		#  3 = game end
	
	alphaColon: .word 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
	alphaA: 	.word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1
	alphaC:		.word 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1
	alphaE: 	.word 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1
	alphaD: 	.word 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0 ,1, 1, 1, 0
	alphaI: 	.word 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1
	alphaN_1:	.word 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1
	alphaN_2:	.word 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0
	alphaP: 	.word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0
	alphaR: 	.word 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1
	alphaS: 	.word 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1
	alphaT: 	.word 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0
	alphaX: 	.word 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1
	alphaY: 	.word 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0
	
	
.text
Initialize:
	jal check_input_start_over
	jal disp_welcome
	
	# Sleep
	# li $v0, 32
	# li $a0, 800
	# syscall
	
	# jal setScreenBlack
	
	# Sleep
	# li $v0, 32
	# li $a0, 800
	# syscall
	
	j Initialize

disp_welcome:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t3, displayAddress
	li $t9, 0xffffff
	
	# writing "CENTIPEDE"
	# paint C at 165
	la $a1, alphaC
	li $a2, 165
	jal writeAlpha
	
	# paint E at 169
	la $a1, alphaE
	li $a2, 169
	jal writeAlpha
	
	li $t9, 0xff0000
	# paint N_1 at 173
	la $a1, alphaN_1
	li $a2, 173
	jal writeAlpha
	
	# paint N_2 at 176
	la $a1, alphaN_2
	li $a2, 176
	jal writeAlpha
	
	# changing the head of the centipede
	li $t9, 0xff9900
	li $t0, 177
	sll $t0, $t0, 2
	add $t0, $t0, $t3
	sw $t9, 0($t0)
	
	li $t9, 0xffffff	# change color back to white
	# paint T at 179
	la $a1, alphaT
	li $a2, 179
	jal writeAlpha
	
	# paint I at 183
	la $a1, alphaI
	li $a2, 183
	jal writeAlpha
	
	# paint P at 360
	la $a1, alphaP
	li $a2, 360
	jal writeAlpha
	
	# paint E at 364
	la $a1, alphaE
	li $a2, 364
	jal writeAlpha
	
	# paint D at 368
	la $a1, alphaD
	li $a2, 368
	jal writeAlpha
	
	# paint E at 372
	la $a1, alphaE
	li $a2, 372
	jal writeAlpha
	
	# writing "S - START"
	# paint S at 802
	la $a1, alphaS
	li $a2, 802
	jal writeAlpha
	
	# paint COLON at 806
	la $a1, alphaColon
	li $a2, 806
	jal writeAlpha
	
	# paint S at 810
	la $a1, alphaS
	li $a2, 810
	jal writeAlpha
	
	# paint T at 814
	la $a1, alphaT
	li $a2, 814
	jal writeAlpha
	
	# paint A at 818
	la $a1, alphaA
	li $a2, 818
	jal writeAlpha
	
	# paint R at 822
	la $a1, alphaR
	li $a2, 822
	jal writeAlpha
	
	# paint T at 826
	la $a1, alphaT
	li $a2, 826
	jal writeAlpha
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
# $a1 = address of alphabet
# $a2 = pixel of top-left
writeAlpha:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a3, 15
	
writeAlpha_loop:
	lw $t1, 0($a1)	# 0 if no paint; 1 if paint	
	beq $t1, 0, check_paint
	
	addi $t2, $a2, 0
	sll $t2, $t2, 2		# bias
	add $t2, $t2, $t3	# location
	sw $t9, 0($t2)		# paint
	
check_paint:	
	addi $a2, $a2, 1	# next location
	addi $a1, $a1, 4	# next index
	addi $a3, $a3, -1	# $a3--

	div $t0, $a3, 3
	mfhi $t0
	beq $t0, 0, nextRow
	
writeAlpha_cont:
	bne $a3, 0, writeAlpha_loop
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
nextRow:
	addi $a2, $a2, 29
	j writeAlpha_cont


Start:
	li $a3, 40 # spawn 40 mushrooms

spawnMushroom:
	li $t9, 0x00ff00	# green
	jal randomizer 		# set value at $a0 -- Note we have to make it within 30x30
	
	lw $t0, displayAddress	# base address -- at 0 index
	sll $t1, $a0, 2			# $t1 is the bias of the mushroom
	add $t1, $t0, $t1		# $t1 is the address of the mushroom
	
	sw $t9, 0($t1) 			# paint pixel with mushroom color at $t9
	
	addi $a3, $a3, -1		# a3--
	bne $a3, $zero, spawnMushroom
	
	j Loop
	
randomizer:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, 42
	li $a0, 0 		# might change 0 to level here
	li $a1, 768		# 0-768 pixel (3/4 of the screen)
	syscall			# 0 <= $a0 <= 767
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
Loop:
	jal check_input
	jal disp_centi
	jal create_flea
	jal disp_flea
	jal disp_darts
	
	# Sleep
	li $v0, 32
	li $a0, 100
	syscall

	j Loop
	
Gameover:
	jal setScreenBlack
	jal disp_gameover

Gameover_loop:
	jal check_input_start_over
	
	# Sleep
	# li $v0, 32
	# li $a0, 800
	# syscall
	
	j Gameover_loop

disp_gameover:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t3, displayAddress
	li $t9, 0xffffff
	
	# writing "S: RETRY"	
	# paint S at 322
	la $a1, alphaS
	li $a2, 322
	jal writeAlpha
	
	# paint COLON at 326
	la $a1, alphaColon
	li $a2, 326
	jal writeAlpha
	
	# paint R at 330
	la $a1, alphaR
	li $a2, 330
	jal writeAlpha
	
	# paint E at 334
	la $a1, alphaE
	li $a2, 334
	jal writeAlpha
	
	# paint T at 338
	la $a1, alphaT
	li $a2, 338
	jal writeAlpha
	
	# paint R at 342
	la $a1, alphaR
	li $a2, 342
	jal writeAlpha
	
	# paint Y at 346
	la $a1, alphaY
	li $a2, 346
	jal writeAlpha
	
	# writing "E: EXIT"
	# paint E at 548
	la $a1, alphaE
	li $a2, 548
	jal writeAlpha
	
	# paint COLON at 552
	la $a1, alphaColon
	li $a2, 552
	jal writeAlpha
	
	# paint E at 556
	la $a1, alphaE
	li $a2, 556
	jal writeAlpha
	
	# paint X at 560
	la $a1, alphaX
	li $a2, 560
	jal writeAlpha
	
	# paint I at 564
	la $a1, alphaI
	li $a2, 564
	jal writeAlpha
	
	# paint T at 568
	la $a1, alphaT
	li $a2, 568
	jal writeAlpha
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

Exit:
	jal setScreenBlack
	li $v0, 10
	syscall			# quit program gracefully


disp_centi:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $a3, $zero, 10
	la $a1, centiLoc	
	la $a2, centiDir	

arr_loop:
	lw $t1, 0($a1)	# load a word from the centiLoc array to $t1
	lw $t2, 0($a2)	# load a word from the centiDir array to $t2
	
	lw $t3, displayAddress 	# $t3 stores the base address for display
	li $t7, 0xff9900		# orange
	li $t8, 0xff0000 		# red
	li $t9, 0x000000 		# black
	
	sll $t4, $t1, 2			# $t4 is the bias of the curr centipede location (offset *4)
	add $t4, $t3, $t4		# $t4 is the address of the curr centipede location
	sw $t9, 0($t4)			# paint centiLoc[i] black
	
	# check next centipede position
	add $t1, $t1, $t2
	sll $t4, $t1, 2			
	add $t4, $t3, $t4		
	
	# colliding into mushroom?
	lw $t6, 0($t4)
	beq $t6, 0x00ff00, centi_col
	
	# colliding into l/r border?
	div $t6, $t1, 32			# $t6 = $t1 mod 32: 0 = colliding right;
	mfhi $t6 					# 31 = colliding left
		
	beq $t2, 1, r_border_col	# check for right border collision
	beq $t2, -1, l_border_col	# check for left border collision
	
arr_loop_cont:
	# cont here
	sw $t1, 0($a1)			# update centiLoc[i]
		
	sll $t5, $t1, 2			# $t5 = bias of the address of the pixel
	add $t5, $t3, $t5		# $t5 = the address of the new bug location
	
	sw $t8, 0($t5)			# paint centiLoc[i] with color at $t8
	
	# paint head with orange
	bne $a3, 10, paint_head
	sw $t7, 0($t5)
	
paint_head:
	addi $a1, $a1, 4		# move pointer to the next index of centiLoc
	addi $a2, $a2, 4		# same stuff but for centiDir
	addi $a3, $a3, -1		# decrement $a3 by 1
	bne $a3, $zero, arr_loop
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

r_border_col:
	beq $t6, 0, centi_col	# colliding into border?
	
	j arr_loop_cont
	
l_border_col:
	beq $t6, 31, centi_col	# colliding into border?
	
	j arr_loop_cont

centi_col:
	sub $t1, $t1, $t2	# shift $t1 back to current position
	bge $t1, 960, centi_bottom_block # at the bottom row
	addi $t1, $t1, 32 	# shift down by a row

centi_bottom_block:	
	mul $t2, $t2, -1	# change direction to left
	sw $t2, 0($a2)		# update cendiDir[i]
	j arr_loop_cont


create_flea:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# if 767 mod 24 = 0 then create a flea (1/24 chance)
	jal randomizer
	div $t9, $a0, 24
	mfhi $t0
	bne $t0, 0, fail_to_create_flea
	
	# finding an empty spot for a flea
	la $t0, fleaLoc		# fleaLoc address
	lw $t3, displayAddress
	li $t8, 0xcc0099	# purple-red color

create_flea_loop:
	lw $t1, 0($t0)		# load value
	bne $t1, -1, find_empty_flea
	addi $t1, $t9, 0	# $t9 range from 0 - 31 (767 / 24 integer div)
	sw $t1, 0($t0)		# update flea value
	
	sll $t4, $t1, 2		# bias
	add $t4, $t3, $t4	# actual address
	sw $t8, 0($t4)		# paint

fail_to_create_flea:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
find_empty_flea:
	addi $t0, $t0, 4	# go to the i+1 dart
	j create_flea_loop

disp_flea:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $a3, 32			# check through the array
	la $t0, fleaLoc		# fleaLoc address
	lw $t3, displayAddress
	li $t8, 0xcc0099	# purple-red
	li $t9, 0x000000	# black

update_flea:
	lw $t1, 0($t0)
	beq $t1, -1, check_flea_exists
	
	sll $t4, $t1, 2		# bias
	add $t4, $t3, $t4	# address
	lw $t5, 0($t4)		# color at address
	beq $t5, 0x00ff00, flea_col_mush
	sw $t9, 0($t4)		# paint curr flea black
	
flea_col_mush:
	addi $t1, $t1, 32	# shift location down 1 pixel
	addi $t4, $t4, 128	# shift address down 1 pixel
	
	bgt $t1, 992, flea_check_col # check hit border
	
	# TODO: implement player_col (if you want to implement lives and stuffs)
	lw $t5, 0($t4)					# $t5 = color at $t4
	beq $t5, 0xffffff, player_col	# check hit player
	
	sw $t1, 0($t0)		# update flea location
	beq $t5, 0x00ff00, flea_collided	# skip painting if col w/mushroom
	sw $t8, 0($t4)		# paint

flea_collided:
# jump here if collided & go to next flea
	addi $t0, $t0, 4	# go to the i+1 flea
	addi $a3, $a3, -1	# $a3--
	bne $a3, 0, update_flea # loop until a3 = 0
	
disp_flea_cont:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

check_flea_exists:
	beq $a3, 1, disp_flea_cont
	addi $t0, $t0, 4	# go to the i+1 flea
	addi $a3, $a3, -1	# $a3--
	j update_flea

flea_check_col:
	li $t1, -1
	sw $t1, 0($t0)
	j flea_collided

player_col:
	j Gameover

disp_darts:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a3, 32				# loop counter -- 32 times
	la $t0, dartsLoc		# i-dart address
	lw $t3, displayAddress	# displayAddress
	li $t8, 0x99ccff		# light blue
	li $t9, 0x000000		# black

update_darts:
	lw $t1, 0($t0)		# i-dart location
	beq $t1, -1, check_dart_exists	# skip if i-dart doesn't exist
	
	sll $t4, $t1, 2		# $t4 = curr dart bias
	add $t4, $t4, $t3	# $t4 = curr dart address
	
	# check overlap w/flea
	lw $t6, 0($t4)		# $t6 = color at $t4
	beq $t6, 0xcc0099, hit_flea		# purple-red: collide w/flea
	
	sw $t9, 0($t4)		# paint curr location black
		
	addi $t1, $t1, -32	# shift $t1 up 1 pixel
	addi $t4, $t4, -128 # $t4 = next dart address
	
	blt $t1, 0, dart_check_col	# collide w/top border
	
	lw $t6, 0($t4)		# $t6 = color at $t4
	
	# check collision with mushroom, flea, and centipede
	beq $t6, 0x00ff00, hit_mush		# green: collide w/mushroom
	beq $t6, 0xcc0099, hit_flea		# purple-red: collide w/flea
	beq $t6, 0xff0000, hit_centi	# red: collide w/centipede (body)
	beq $t6, 0xff9900, hit_centi	# orange: collide w/centipede (head)
	
	sw $t1, 0($t0)		# save new location of dart
	
	sll $t4, $t1, 2		# $t4 = new dart bias
	add $t4, $t4, $t3	# $t4 = new dart address
	sw $t8, 0($t4)		# paint new dart lightblue

dart_collided:
# jump here if collided & go to next dart
	addi $t0, $t0, 4	# go to the i+1 dart
	addi $a3, $a3, -1	# $a3--
	bne $a3, 0, update_darts # loop until a3 = 0
	
update_darts_cont:
# end of the loop--updated every darts
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

check_dart_exists:
	beq $a3, 1, update_darts_cont
	addi $t0, $t0, 4	# go to the i+1 dart
	addi $a3, $a3, -1	# $a3--
	j update_darts

hit_mush:
	sw $t9, 0($t4)
	j dart_check_col

hit_flea:
	la $t7, fleaLoc
	
hit_flea_loop:
	lw $t2, 0($t7)
	beq $t1, $t2, hit_flea_cont
	
	addi $t7, $t7, 4
	addi $a2, $a2, -1
	
	j hit_flea_loop

hit_flea_cont:
	sw $t9, 0($t4)		# paint black
	
	li $t2, -1
	sw $t2, 0($t7)		# update flea to be non-existing
	
	j dart_check_col	# update dart
	
hit_centi:
	la $t7, hitCounter
	lw $t2, 0($t7)
	addi $t2, $t2, 1
	beq $t2, 3, Gameover	# quit game if centipede has been hit 3 times
	sw $t2, 0($t7)
	j dart_check_col

dart_check_col:
	li $t1, -1		# set i-dart to be non-existing
	sw $t1, 0($t0)	# save it to the dartLoc
	j dart_collided


check_input:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t8, 0xffff0000
	beq $t8, 1, get_input
	addi $t8, $zero, 0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
get_input:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t2, 0xffff0004
	addi $v0, $zero, 0
	beq $t2, 0x6A, pressed_j
	beq $t2, 0x6B, pressed_k
	beq $t2, 0x78, pressed_x
	beq $t2, 0x73, pressed_s
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
pressed_j:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, bugLoc 			# $t0 = bugLoc address
	lw $t1, 0($t0)			# $t1 = bugLoc location
	lw $t2, displayAddress  # $t2 = display address
	li $t3, 0x000000		# $t3 = black colour code
	sll $t4,$t1, 2			# $t4 the bias of the old bug location
	add $t4, $t2, $t4		# $t4 is the address of the old bug location
	sw $t3, 0($t4)			# paint the first (top-left) unit white.
	beq $t1, 960, l_block 	# prevent the bug from getting out of the canvas
	addi $t1, $t1, -1		# move the bug one location to the left
	
l_block:
	sw $t1, 0($t0)
	
	li $t3, 0xffffff
	
	sll $t4,$t1, 2
	add $t4, $t2, $t4
	sw $t3, 0($t4)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
pressed_k:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, bugLoc			# $t0 = bugLoc address
	lw $t1, 0($t0)			# $t1 = bugLoc location
	lw $t2, displayAddress  # $t2 = display address
	li $t3, 0x000000		# $t3 = black color code
	sll $t4,$t1, 2			# $t4 the bias of the old bug location
	add $t4, $t2, $t4		# $t4 is the address of the old bug location
	sw $t3, 0($t4)			# paint the block with black
	beq $t1, 991, r_block 	# prevent the bug from getting out of the canvas
	addi $t1, $t1, 1		# move the bug one location to the right
	
r_block:
	sw $t1, 0($t0)			# update bugLoc
	li $t3, 0xffffff
	
	sll $t4,$t1, 2
	add $t4, $t2, $t4
	sw $t3, 0($t4)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
pressed_x:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, bugLoc			# $t0 = bugLoc address
	lw $t1, 0($t0)			# $t1 = bugLoc location
	lw $t2, displayAddress  # $t2 = display address
	la $t3, dartsLoc		# $t3 = dartsLoc address
	li $t4, 0x99ccff		# $t4 = blue color code (maybe just use 0000ff)
	
	jal create_dart			# $t5 = the first non-existing dart "LOCATION"
	
	sw $t4, 0($t5)			# paint dart with $t4 color
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

create_dart:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

dart_loop:
	# loop until we find a non-existing spot
	lw $t9, 0($t3)			# $t9 = dartsLoc location (-1 if not existing)
	beq $t9, -1, create_dart_cont
	addi $t3, $t3, 4		# move to the next index
	j dart_loop				# keep looping until you find an empty spot

create_dart_cont:
	addi $t5, $t1, -32		# $t5 = dart location = bugLoc + 1 row
	sw $t5, 0($t3)			# update dart location in memory
	sll $t5, $t5, 2			# $t5 the bias of the old bug location
	add $t5, $t2, $t5		# $t5 is the address of the old bug location
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
pressed_s:
	# reset every variable to its default value
	la $t0 bugLoc
	li $t1 975
	sw $t1 0($t0)
	
	jal resetcentiLoc
	jal resetcentiDir
	jal reset_darts_flea_Loc
	jal reset_darts_flea_Loc
	
	la $t0 hitCounter
	li $t1 0
	sw $t1 0($t0)
	
	jal setScreenBlack
	
	# Sleep
	li $v0, 32
	li $a0, 200
	syscall
	
	j Start

resetcentiLoc:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a3 10
	la $t0 centiLoc
	li $t1 9
	
reset_centiLoc_loop:
	sw $t1, 0($t0)
	
	addi $t1, $t1, -1	# offset the location
	addi $t0, $t0, 4	# move to next index
	addi $a3, $a3, -1	# a3--
	
	bne $a3, 0, reset_centiLoc_loop		# loop until $a3 = 0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
resetcentiDir:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a3 10
	la $t0 centiDir
	li $t1 1
	
reset_centiDir_loop:
	sw $t1, 0($t0)

	addi $t0, $t0, 4	# move to next index
	addi $a3, $a3, -1	# a3--
	
	bne $a3, 0, reset_centiDir_loop		# loop until $a3 = 0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

reset_darts_flea_Loc:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a3 32
	la $t0 dartsLoc
	li $t1 -1
	
reset_darts_flea_Loc_loop:
	sw $t1, 0($t0)
	
	addi $t0, $t0, 4	# move to next index
	addi $a3, $a3, -1	# a3--
	
	bne $a3, 0, reset_darts_flea_Loc_loop # loop until $a3 = 0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

setScreenBlack:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a3 1024
	lw $t0 displayAddress
	li $t1 0x000000
	
setScreenBlack_loop:
	sw $t1, 0($t0)

	addi $t0, $t0, 4	# move to next index
	addi $a3, $a3, -1	# a3--
	
	bne $a3, 0, setScreenBlack_loop		# loop until $a3 = 0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

pressed_e:
	j Exit
	
check_input_start_over:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t8, 0xffff0000
	beq $t8, 1, get_input_start_over
	addi $t8, $zero, 0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
get_input_start_over:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t2, 0xffff0004
	addi $v0, $zero, 0
	beq $t2, 0x65, pressed_e
	beq $t2, 0x73, pressed_s

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

delay:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a2, 10000
	addi $a2, $a2, -1
	bgtz $a2, delay
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
