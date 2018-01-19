TITLE Program6A   (Program6A.asm)

; Author: Khoa Phan
; Course / Project ID : Program 6A           Date: 11/25/17
; Description: This is Program 6A, 

INCLUDE Irvine32.inc

;constants
arraySize	=	10

;Macros
displayString	MACRO	string
		push	edx
		mov		edx, OFFSET string
		call	WriteString
		pop		edx
ENDM

getString		MACRO	variable, string
		push	edx
		push	ecx
		displayString	string
		mov		edx, OFFSET variable
		mov		ecx, (SIZEOF variable) - 1
		call	ReadString
		pop		edx
		pop		ecx

ENDM

.data

;intro prompts
intro_1		BYTE	"Programming Assignment 6A: Designing low-level I/O procedures", 0
intro_2		BYTE	"Programmed by Khoa Phan.", 0

;body prompts
prompt_1	BYTE	"Please provide 10 unsigned decimal integers.", 0
prompt_2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
prompt_3	BYTE	"After you have finished inputting the raw numbers I will display a list", 0
prompt_4	BYTE	"of the integers, their sum, and their average value.", 0

prompt_ask	BYTE	". Please enter an unsigned number: ", 0

comma		BYTE	", ", 0

msg_result	BYTE	"You entered the following numbers: ",0
msg_sum		BYTE	"The sum of these numbers is: ", 0
msg_avg		BYTE	"The average is: ", 0

msg_err1	BYTE	"ERROR: You did not enter an unsigned number or your number was too big."
msg_err2	BYTE	" Please try again.", 0

;goodbye prompt
goodbye		BYTE	"Thanks for playing! Results certified by Khoa Phan.", 0

;variables
array		DWORD	arraySize DUP(?)
input		BYTE	20 DUP (?)
inputSize	DWORD	0
num			DWORD	?
counter		DwORD	0
sum			DWORD	0

.code
main PROC
	;intro prompts
	call	introduction

	;initialize counter
	mov		ecx, arraySize

	;get input variables and push into stack
	getInfo:
	push	OFFSET	array
	push	counter
	call	ReadVal
	inc		counter
	loop	getInfo
	call	CrlF

	;display the results in array
	displayString msg_result
	push	OFFSET array
	push	arraySize
	call	WriteVal

	;calculate the sum of numbers in array
	call	CrlF
	push	OFFSET array
	push	arraySize
	push	sum
	call	calcSum

	;calculate the average of t numbers in array
	push	sum
	push	arraySize
	call	calcAvg
	call	CrlF

	call	farewell

	exit	; exit to operating system
main ENDP


;--------------------------------------------------------
;introduction 
;
; Displays information regarding the program and author
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
introduction PROC
	;intro prompts
	push	ebp
	mov		ebp, esp

	displayString	intro_1
	call	CrlF
	displayString	intro_2
	call	CrlF
	call	CrlF
	displayString	prompt_1
	call	CrlF
	displayString	prompt_2
	call	CrlF
	displayString	prompt_3
	call	CrlF
	displayString	prompt_4
	call	CrlF
	call	CrlF

	pop		ebp
	ret		24
introduction ENDP

;--------------------------------------------------------
;ReadVal 
;
; Get user input and validates that input then convert
;	the string value into integers
; Receives: array and count pushed onto the stack
; Returns:  N/A
;--------------------------------------------------------
ReadVal PROC
	pushad
	mov	ebp, esp

	;set counter and add 1, the validate
	mov		eax, [ebp+36]
	add		eax, 1
	call	WriteDec
	getString input, prompt_ask
	jmp		validate

	;if input is invalid display error
	ERROR:
		getString	input, msg_err1

	validate:
		mov		inputSize, eax
		mov		ecx, eax
		mov		esi, OFFSET input
		mov		edi, OFFSET num

	;counter that cycles through each number
	count:
		lodsb
		cmp		al, 48	;character 48 = 0
		jl		ERROR
		cmp		al, 57	;character 57 = 9
		jg		ERROR
		loop	count
		jmp		VALID

	;if valid using Irvine proc of parsing int
	VALID:
		mov		edx, OFFSET input
		mov		ecx, inputSize

		;irvine library convert unsigned integer to binary
		call	ParseDecimal32
		;calls carry flag to see if valid
		.IF CARRY?
		jmp		ERROR
		
		;if valid, proceed
		.ENDIF
		mov		edx, [ebp+40]
		mov		ebx, [ebp+36]
		imul	ebx, 4
		mov		[edx+ebx], eax

	popad
	ret 8
ReadVal ENDP

;--------------------------------------------------------
;WriteVal 
;
; Displays numbers in array
; Receives: array, arraySize onto stack
; Returns:  N/A
;--------------------------------------------------------
WriteVal PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12]
	mov		ecx, [ebp+8]

	disp:
		mov		eax, [edi]
		call	WriteDec
		cmp		ecx, 1
		je		noComma
		displayString comma
		add		edi, 4
		noComma:
			loop disp

	pop		 ebp
	ret		 8
WriteVal ENDP

;--------------------------------------------------------
;calcSum 
;
; Totals all numbers within array up
; Receives: array, arraySize, sum pushed onto stack
; Returns:  N/A
;--------------------------------------------------------
calcSum PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+16]
	mov		ecx, [ebp+12]
	mov		ebx, [ebp+8]

	moveNum:
		mov		eax, [edi]
		add		ebx, eax
		add		edi, 4
		loop	moveNum

	displayString msg_sum
	mov		eax, ebx
	call	WriteDec
	call	CrlF
	mov		sum, ebx
	
	pop		ebp
	ret		12
calcSum ENDP

;--------------------------------------------------------
;calcAvg 
;
; Takes sum and divide by total in array to get average
; Receives: arraySize, sum pushed onto stack
; Returns:  N/A
;--------------------------------------------------------
calcAvg PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+12]
	mov		ebx, [ebp+8]
	mov		edx, 0

	idiv ebx

	displayString	msg_avg
	call	WriteDec

	pop		ebp
	ret 8
calcAvg	ENDP

;--------------------------------------------------------
;farewell 
;
; Displays the good bye to the program to user
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
farewell PROC
	call	CrlF
	displayString	goodbye
	call	CrlF
	ret
farewell ENDP

END main