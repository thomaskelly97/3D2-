	AREA	Demo, CODE, READONLY
	IMPORT	main
	EXPORT	start
start 
	LDR	r0, =test ;INPUT 
	LDR r1, [r0]
	LDR r2, =0 
	LDR r3, =0xA1001004 ;STACK 
	LDR r4, =8
	LDR r6, =0
	LDR r7, =10000
	LDR r8, =1000
	LDR r9, =100 
	LDR r10,=10 ;DEFINE ALL DECADES 
	LDR r11,=1 

loop
	CMP r7,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip0
	SUB r1,r1,r7
	ADD r2,r2,#1 
	B loop ;keep looping 
skip0
	;PUSH 
	SUB r3,r3,#4
	STR r2, [r3] 
	
	MOV r2,#0
loop1
	CMP r8,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip1 
	SUB r1,r1,r8
	ADD r2,r2,#1 
	B loop1 ;keep looping 
skip1 
	;PUSH
	 
	STR r2, [r3, #-4]! 
	
	MOV r2,#0
loop2
	CMP r9,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip2
	SUB r1,r1,r9
	ADD r2,r2,#1 
	B loop2 ;keep looping 
skip2
	;PUSH 
	
	STR r2, [r3, #-4]!
	
	MOV r2,#0
loop3
	CMP r10,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip3
	SUB r1,r1,r10
	ADD r2,r2,#1 
	B loop3 ;keep looping 
skip3
	;PUSH
	
	STR r2, [r3, #-4]!
	
	MOV r2,#0
loop4
	CMP r11,r1 ;If r7 > r1 we will get negative so skip this 
	BGT skip4 
	SUB r1,r1,r11
	ADD r2,r2,#1 
	B loop4 ;keep looping 
skip4
	 ;PUSH 
	STR r2, [r3, #-4]!
	LDR r5, =0xA1001004
	MOV r3,r5
	MOV r2,#0
	 	 
loop5 
	LDR r6, [r3],#-4
	SUB r4,r4,#1 
	CMP r4,#0 
	BNE loop5
	
stop	B	stop
test	DCD 0x419,0
	END