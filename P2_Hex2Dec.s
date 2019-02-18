	AREA	Demo, CODE, READONLY
	IMPORT	main
	EXPORT	start
start 
	LDR r0, =test ;INPUT 
	LDR r1, [r0]
	LDR r2, =8
	LDR r3, =0 ;STACK 
	LDR r4, =0
	LDR r5, =0 
	LDR r6, =0
	LDR r7, =0 ; gets reset later
	LDR r8, =0
	LDR r9, =100 
	LDR r10,=8 ;Just need it for a sec, redefined near line 35
	LDR r11,=1 
	LDR r12,=0xF
	
	MOV r5,r1 
	LDR r6,=2_1111 
	
	;at this point, r3,r5 can be used. Maybe r6? 
	;THIS PART COUNTS THE LENGTH OF THE INPUT. 
initl 
	MOV r5,r5,ROR #28 ;Get the bits in order 
	AND r3,r5, r6 ;get the first nibble 
	CMP r3, #0
	BNE skip000
	ADD r4,r4,#1 ;Count the amount of zero nibbles there is 
	SUB r2,r2,#1
	CMP r2,#0
	BNE initl
skip000
	;NOW r4, has the amount of '0000' periods before we hit a nonzero 
	
	SUB r4,r10,r4 ;Now it has the amount of F periods we need 
	MOV r2,r4 ;copy r4 into r2, counts amt of non-zero parts 
	SUB r4,r4,#1 ;CORRECT 
	
	;THIS PART GENERATES F's the SAME LENGTH AS INPUT 
	ORR r10,r12,#0
Floop 
	MOV r12,r12,LSL #4 ;Move the F out left 'r4' times  
	ORR r10,r12,r10 
	SUB r4,r4,#1 ;Countdown 
	CMP r4,#0 
	BNE Floop ; now F is over 'r4' positions to the left, we have the F's we need 
	;r1 = 0xFFF - 0x419 etc. 
	 
	
	;DETERMINE WHICH SIGN. USE r3 =0 for POSITIVE, r3 = 1 for NEGATIVE 
	LDR r8,=4 ;store in r3, as r3 gets mapped over in then next few lines 
	MUL r7,r2,r8 
	SUB r7,r7,#1 
	MOV r3,r1 ;make a copy 
	MOV r3,r3,LSR r7 
	AND r3,r3,r11 ;AND with 0001 
	
	CMP r3,#0 ;If r3 is 0 then the number is positive 
	BEQ skip00 ;if r3 == 0 skip this
	MOV r3, #1 ;Put 1 in r3 to signify negative number NEGATIVE 
	SUB r1,r10,r1 ;Take away using previously calculated shite 
	ADD r1,r1,#1 ;Correct 
	;push minus to stack
	LDR r2, =0xB ;signifies minus 
	SUB r13,r13, #4 
	STR r2, [r13] 
skip00  
	CMP r3, #1 ;If r3 == 1 then skip this
	BEQ skip01
	MOV r3,#0 ;POSTIVIE 
	LDR r2, =0xA ;signifies plus 
	SUB r13,r13,#4 
	STR r2, [r13] 
skip01
	
	;CALCULATE THE NUMBER HEX -> DECIMAL 
	LDR r10,=10
	LDR r8,=1000
	LDR r7, =10000
	LDR r2,=0 
loop
	CMP r7,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip0
	SUB r1,r1,r7
	ADD r2,r2,#1 
	B loop ;keep looping 
skip0
	;PUSH 01 
	SUB r13,r13,#4
	STR r2, [r13] 
	
	MOV r2,#0
loop1
	CMP r8,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip1 
	SUB r1,r1,r8
	ADD r2,r2,#1 
	B loop1 ;keep looping 
skip1 
	;PUSH 02
	 
	STR r2, [r13, #-4]! 
	
	MOV r2,#0
loop2
	CMP r9,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip2
	SUB r1,r1,r9
	ADD r2,r2,#1 
	B loop2 ;keep looping 
skip2
	;PUSH 03
	
	STR r2, [r13, #-4]!
	
	MOV r2,#0
loop3
	CMP r10,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip3
	SUB r1,r1,r10
	ADD r2,r2,#1 
	B loop3 ;keep looping 
skip3
	;PUSH 04
	STR r2, [r13, #-4]!
	
	MOV r2,#0
loop4
	CMP r11,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip4 
	SUB r1,r1,r11
	ADD r2,r2,#1 
	B loop4 ;keep looping 
skip4
	 ;PUSH 05
	STR r2, [r13, #-4]!
	ADD r13,r13,#20 ;Reset the stack pointer 
	MOV r2,#0

;THIS PART TAKES NUMBERS FROM STACK 1 by 1 INTO R6, INCLUDING SIGN INDICATION FIRST!!! 
	LDR r4, =8  
loop5 
	LDR r6, [r13],#-4 ;Loop down through the number in order 
	SUB r4,r4,#1 
	CMP r4,#0 
	BNE loop5
	
stop	B	stop
test	DCD 0xFFE4,0
	END