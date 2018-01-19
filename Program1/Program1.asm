TITLE Program1   (Program1.asm)

; Author: Khoa Phan
; Course / Project ID : Program 1           Date: 09/22/17
; Description: This is Program 1, CS271 Week 1 project.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; (insert variable definitions here)
intro_1		BYTE	"Name: Khoa Phan, Title: Program1", 0
intro_EC1	BYTE	"EC: Loop for again.", 0
intro_EC2	BYTE	"EC: First number is larger than second check.", 0
prompt_1	BYTE	"Enter 2 numbers and I'll show you the sum, difference, product, quotient, and remainder.", 0
prompt_2	BYTE	"Results", 0
prompt_3	BYTE	"First Number: ", 0
prompt_4	BYTE	"Second Number: ", 0
p_again		BYTE	"Would you like to try again? [1]YES [0]NO: ", 0

msg_err1	BYTE	"Second number must be larger than the first.", 0

num1		SDWORD	?
num2		SDWORD	?

input		SDWORD	?

sum			SDWORD	?
diff		SDWORD	?
product		SDWORD	?
quotient	SDWORD	?
remainder	SDWORD	?
	
result_add	BYTE	"Addition: ", 0
result_sub	BYTE	"Subtraction: ", 0
result_mult	BYTE	"Multiplication: ", 0
result_quot	BYTE	"Division: ", 0
result_rem	BYTE	"Remainder: ", 0

goodBye		BYTE	"End of program, good-bye!", 0

.code
main PROC

; (insert executable instructions here)

; display name, title
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrlF
	call	CrlF

top:
; prompt user to enter number
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrlF
	call	CrlF

; user enter first #
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	ReadInt
	mov		num1, eax

; user enter second #
	mov		edx, OFFSET prompt_4
	call	WriteString
	call	ReadInt
	mov		num2, eax
	call	CrlF

; compare two inputs
	mov		eax, num1
	cmp		eax, num2
	jl		checkValid
	jmp		calculations

checkValid:
; check valid number
	mov		edx, OFFSET msg_err1
	call	WriteString
	call	CrlF
	jmp		againLoop
	

calculations:
; calculate addition
	mov		eax, num1
	add		eax, num2
	mov		sum, eax
	
; calculate subtraction
	mov		eax, num1
	sub		eax, num2
	mov		diff, eax

; calculate multiplication
	mov		eax, num1
	mov		ebx, num2
	imul	ebx
	mov		product, eax

; calculate quotient
	mov		eax, num1
	mov		ebx, num2
	idiv	ebx
	mov		quotient, eax

; calculate remainder
	mov		remainder, edx

; report addition

	mov		edx, OFFSET result_add
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrlF

; report subtraction
	mov		edx, OFFSET result_sub
	call	WriteString
	mov		eax, diff
	call	WriteDec
	call	CrlF

; report multiplication
	mov		edx, OFFSET result_mult
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrlF

; report division
	mov		edx, OFFSET result_quot
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	call	CrlF

; report remainder
	mov		edx, OFFSET result_rem
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrlF

againLoop:
; try again prompt
	mov		edx, OFFSET p_again
	call	WriteString
	call	ReadInt
	mov		input, eax
	cmp		eax, 1
	je		top

; say goodbye
	call	CrlF
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrlF

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
