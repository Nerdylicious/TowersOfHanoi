;Author: Irish Medina

;Purpose: Solves Towers of Hanoi using fewest number of moves

;data dictionary for main:
;R0 - for printing out the header and end message
;R1 - the number of disks
;R2 - the original rod, denoted by "1"
;R3 - the final rod, denoted by "2"
;R4 - the spare rod, denoted by "3"
;R5 - not used in main
;R6 - the stackbase to be put in the stack
;R7 - not used in main

	.orig x3000

main
	and	r0,r0,#0
	and	r1,r1,#0
	and	r2,r2,#0
	and	r3,r3,#0
	and	r4,r4,#0
	and	r5,r5,#0
	and	r6,r6,#0
	and	r7,r7,#0

	lea	r0,header	;load the header to print
	puts

	and	r0,r0,#0

	ld	r6,stackbase
	ld	r1,n		;load number of disks

	add	r2,r2,#1	;orig rod
	add	r3,r3,#2	;final rod
	add	r4,r4,#3	;spare rod

	add	r6,r6,#-1	;push spare rod as r5+4
	str	r4,r6,#0

	add	r6,r6,#-1	;push final rod as r5+3
	str	r3,r6,#0
	
	add	r6,r6,#-1	;push orig rod as r5 +2
	str	r2,r6,#0

	add	r6,r6,#-1	;push n as r5+1
	str	r1,r6,#0

	add	r6,r6,#-1	;set aside one word on stack for return value

	jsr 	tower
	
	add	r6,r6,#5	;remove args and return value from stack

	and	r0,r0,#0
	lea	r0,end_message
	puts

	halt


;subroutine tower
;purpose: solves the towers of hanoi in the fewest number of moves
;the algorithm goes like this:

;void tower(int n, char orig, char spare, char final){
;
;	if(n > 0){
;
;		tower(n-1, orig, final, spare);
;		print("Ring moved: %c From rod: %c To Rod: %c", n, orig, final);
;		tower(n-1, spare, orig, final);
;	}
;}


;data dictionary for subroutine:
;R0 - unused
;R1 - the value of n
;R2 - the value of orig
;R3 - the value of final
;R4 - the value of spare
;R5 - frame pointer
;R6 - stack pointer

;stack contents:
;R5 + 0 - return value
;R5 + 1 - n
;R5 + 2 - original rod ("1")
;R5 + 3 - final rod ("2")
;R5 + 4 - spare rod ("3")


tower

	add	r6,r6,#-1	;save r5
	str	r5,r6,#0

	add	r5,r6,#1	;make r5 point to return value

	add	r6,r6,#-1	;save r0
	str	r0,r6,#0

	add	r6,r6,#-1	;save r1
	str	r1,r6,#0

	add	r6,r6,#-1	;save r2
	str	r2,r6,#0

	add	r6,r6,#-1	;save r3
	str	r3,r6,#0

	add	r6,r6,#-1	;save r4
	str	r4,r6,#0

	add	r6,r6,#-1	;save r7
	str	r7,r6,#0


	ldr	r1,r5,#1	;get n from args

	brz	base		;if n = 0 do base case
	brp	recurse		;if n > 0  do recursive case

base
	str	r1,r5,#1	;store 0 as ret value
	br	done

recurse

	ldr	r2,r5,#2	;get orig
	ldr	r3,r5,#3	;get final
	ldr	r4,r5,#4	;get spare

	ldr	r1,r5,#1	;get n
	add	r1,r1,#-1	;do n-1

	add	r6,r6,#-1	;push final (swiched with spare)
	str	r3,r6,#0

	add	r6,r6,#-1	;push spare (switchd with final)
	str	r4,r6,#0	

	add	r6,r6,#-1	;push orig
	str	r2,r6,#0

	add	r6,r6,#-1	;push n-1 onto stack
	str	r1,r6,#0

	add	r6,r6,#-1	;set aside one word for return value

	jsr	tower

	ld	r4,ascii	;load ascii to add
	
	ldr	r2,r5,#2	;get orig
	ldr	r3,r5,#3	;get final

	ldr	r1,r5,#1	;get n

;the following are for calling the print routine

	add	r6,r6,#-1	;push final onto stack
	str	r3,r6,#0

	add	r6,r6,#-1	;push orig onto stack
	str	r2,r6,#0

	add	r6,r6,#-1	;push n onto stack
	str	r1,r6,#0

	add	r6,r6,#-1	;set aside one word for return value

	jsr 	print

	add	r6,r6,#4	;remove args and return value for print routine

;done calling print routine

	and	r4,r4,#0
	ldr	r4,r5,#4	;get spare

;get the stuff, then push it on where they once were

	add	r6,r6,#5	;remove args and return value from stack

	add	r6,r6,#-1	;push orig (switched with spare)
	str	r2,r6,#0

	add	r6,r6,#-1	;push final (like normal)
	str	r3,r6,#0
	
	add	r6,r6,#-1	;push spare (switched with orig)
	str	r4,r6,#0	

	add	r1,r1,#-1	;do n-1

	add	r6,r6,#-1	;push n-1 onto stack
	str	r1,r6,#0

	add	r6,r6,#-1	;set aside one word for return value

	jsr 	tower

;take the args and return value out
	
	add	r6,r6,#5	;remove args and return value form stack
		
done

	ldr	r7,r6,#0	;restore r7
	add	r6,r6,#1

	ldr	r4,r6,#0	;restore r4
	add	r6,r6,#1

	ldr	r3,r6,#0	;restore r3
	add	r6,r6,#1

	ldr	r2,r6,#0	;restore r2
	add	r6,r6,#1

	ldr	r1,r6,#0	;restore r1
	add	r6,r6,#1

	ldr	r0,r6,#0	;restore r0
	add	r6,r6,#1

	ldr	r5,r6,#0	;restore r5
	add	r6,r6,#1

	ret			;return from subroutine


;subroutine print
;prints a number between 1 and 9 inclusive passed to it
;assuming the number being passed is 1 <= n <= 9 and nothing else

;data dictionary for subroutine:
;R0 - used as a temp for printing
;R1 - value of n
;R2 - value of orig (this is in fact the "from rod")
;R3 - value of final (this is in fact the "to rod")
;R4 - the ascii value #48
;R5 - frame pointer
;R6 = stack pointer

;stack contents:
;R5+0 - return value
;R5+1 - n
;R5+2 - orig "from rod"
;R5+3 - final	"to rod"

print

	add	r6,r6,#-1	;save r5
	str	r5,r6,#0

	add	r5,r6,#1	;make r5 point to return value

	add	r6,r6,#-1	;save r0
	str	r0,r6,#0

	add	r6,r6,#-1	;save r1
	str	r1,r6,#0	

	add	r6,r6,#-1	;save r2
	str	r2,r6,#0

	add	r6,r6,#-1	;save r3
	str	r3,r6,#0

	add	r6,r6,#-1	;save r4
	str	r4,r6,#0

	add	r6,r6,#-1	;save r7
	str	r7,r6,#0

	ldr	r1,r5,#1	;get n
	ldr	r2,r5,#2	;get orig
	ldr	r3,r5,#3	;get final

	ld	r4,ascii	;get ascii value so it print out properly

	and	r0,r0,#0
	add	r0,r0,r1	;print n
	add	r0,r0,r4	
	out		

	and	r0,r0,#0	;print out spaces
	lea	r0,tabs
	puts	

	and	r0,r0,#0	;print orig
	add	r0,r0,r2
	add	r0,r0,r4
	out

	and	r0,r0,#0	;print out spaces
	lea	r0,tabs
	puts	

	and	r0,r0,#0	;print final
	add	r0,r0,r3
	add	r0,r0,r4
	out

	and	r0,r0,#0	;print out a newline
	ld	r0,new_line
	out

	;restore stack before returning

	ldr	r7,r6,#0	;restore r7
	add	r6,r6,#1

	ldr	r4,r6,#0	;restore r4
	add	r6,r6,#1

	ldr	r3,r6,#0	;restore r3
	add	r6,r6,#1

	ldr	r2,r6,#0	;restore r2
	add	r6,r6,#1

	ldr	r1,r6,#0	;restore r1
	add	r6,r6,#1

	ldr	r0,r6,#0	;restore r0
	add	r6,r6,#1

	ldr	r5,r6,#0	;restore r5
	add	r6,r6,#1
	
	ret			;return from subroutine print
	

stackbase	.fill	x4000
n		.fill	#4
ascii		.fill	#48

header		.stringz	"Ring Moved:\tfrom Rod:\t\tto Rod:\n"
tabs		.stringz	"\t\t\t"
new_line	.stringz	"\n"
end_message	.stringz	"\nProcessing Complete\n"

	.end
