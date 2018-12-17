.ORIG xFD70 		;starting address
AND 	R0,R0,#0 	;Clear register
AND 	R1,R1,#0 	;clear register
AND 	R2,R2,#0 	;clear register
AND 	R3,R3,#0 	;clear register
AND 	R4,R4,#0 	;clear register
AND 	R5,R5,#0 	;clear register
AND 	R6,R6,#0 	;clear register
AND 	R7,R7,#0 	;clear register

LEA	R7,ReadInt 	; Initialize the address of subroutine
; a sub routine is a function, that works in low level mode

ReadInt		LEA	R0,MSG		;load address of display message
		TRAP	x22		;display message

ReadInt1	LD	R0,ASCII_	; Loads the the ascii table values
		LD	R2,ASCII_0 	; loads ascii rep of number zero
		TRAP 	x20		; receive user input
		NOT	R2,R2		; negate 48 to be able to subtract
		;value needs to be increment once
		ADD	R2,R2,#1	; convert to -48
		ADD	R1,R0,R2	; Subtract R0 - 48
		BRzp	NextCheck	; if zero or positive, continue
		BRn	ReadInt1	; else ask for valid input


NextCheck	LD	R2,ASCII_9 	; loads ascii rep of number zero
		AND	R1,R1,#0	; this is checking
		NOT	R2,R2		; for integers only
		ADD	R2,R2,#1	; integers only
		ADD	R1,R0,R2
		BRp	ReadInt		;if the value is positive go back to ReadInt to display msg
		BRz	Continue        ;else keep on

Continue	AND	R1,R1,#0
		ADD	R1,R1,R0
		TRAP	x21		;output char number to user
		
Continue1	LD	R0,ASCII_       ;repeat above statement twice
		LD	R2,ASCII_0
		TRAP	x20		;and store values 
		NOT	R2,R2
		ADD	R2,R2,#1
		ADD	R2,R0,R2
		BRzp	NextCheck1
		BRn	Continue1

NextCheck1	LD	R3,ASCII_9	; continuation of integer check
		NOT	R3,R3		; integer check
		ADD	R3,R3,#1
		ADD	R2,R0,R3
		BRp	Continue1
		TRAP	x21		;display character input
		
LastDigit	LD	R0,ASCII_
		TRAP	x20
		LD	R4,ASCII_0
		TRAP	x20		;checking integers as input 
		NOT	R4,R4
		ADD	R4,R4,#1	;else character will be ignored
		ADD	R3,R0,R4
		BRzp	NextCheck2
		BRn	LastDigit

NextCheck2	LD	R4,ASCII_9	; last integer to check
		NOT	R4,R4		; if letters typed will be ignored
		ADD	R4,R4,#1	;
		ADD	R3,R0,R4	;
		BRp	LastDigit	;
		TRAP	x21		;display character input


; -----------------------This is where multiplication of input begins -------------


ANDT		AND	R5,R5,#0	; holds product
		AND 	R4,R4,#0	; hols n counter
		BRz	Conversion

Conversion	ADD	R5,R5,R1	;R5 holds the product
		ADD	R4,R4,R2	;add counter to loop
		ADD	R4,R4,#-1	; decrement counter for equality when multiplying
		BRp	Calculate
		
Calculate	ADD	R5,R5,R6 	;Product incrementor
		ADD	R4,R4,#-1	;decrement n counter until zero	;halt
		BRp	Calculate

Displayint	AND	R0,R0,#0
		ADD	R0,R0,R5	; R0, holds result of multiplication

		AND 	R1,R1,#0 	;clear register
		AND 	R2,R2,#0 	;clear register
		AND 	R3,R3,#0 	;clear register
		AND 	R4,R4,#0 	;clear register
		AND 	R5,R5,#0 	;clear register
		AND 	R6,R6,#0 	;clear register
		AND 	R7,R7,#0 	;clear register

Displayint1	ST 	R3,SaveR3 	;this is where
		ST 	R4,SaveR4 	; i store values
		ST 	R5,SaveR5 	;in more that 100
		ST 	R6,SaveR6 	;which was multiplied is last methods
		ST 	R7,SaveR7
		LEA 	R6,num 		;loads ascci rep of #100
		LD  	R3,ASCII_ 	;loads tne ascii template
		ADD 	R6,R6,#9

Loophundred	ADD 	R0,R0,#-10	;find the results quotient
		BRn 	End100		;when the value equals negative exit
		ADD 	R4,R4,#1	;else increment R4
		BRnzp 	Loophundred

End100		ADD 	R5,R0,#10
		ADD 	R5,R5,R3
		STR 	R5,R6,#0	;stores the current integer in memory
		ADD 	R6,R6,#-1	;pointer
		ADD 	R4,R4,#-1	; R4 is empty if no digits found
		BRn 	Endten		; if value is neg, jmp to print digits
		ADD 	R4,R4,#1
		ADD 	R0,R4,#0
		AND 	R4,R4,#0
		AND 	R5,R5,#0
		BRnzp 	Loophundred

Endten		ADD 	R6,R6,#1
		ADD 	R0,R6,#0
		Trap 	x22		;puts	
		Trap 	x26		;invoke trap x26

ASCII_		.FILL x0030		;ascii table

;TRAPX26 	.FILL	x0026
newline		.FILL	x00A0		;ascii code of new line
MSG		.STRINGz	"Enter an integer -> "
;MSG1		.STRINGz	" Output calc is: "

num 		.FILL	x0064		; #100

ASCII_0		.FILL	x0030		; number 0 in ascii rep
ASCII_9		.FILL	x0039		; number nine in ascii rep

SaveR3		.BLKW	10		;reserved for calculation outputs
SaveR4		.BLKW	10		;
SaveR5		.BLKW	10		;
SaveR6		.BLKW	10		;
SaveR7		.BLKW   10		;

.END
