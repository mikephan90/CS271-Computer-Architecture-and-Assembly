TITLE Program3   (Program3.asm)

; Author: Khoa Phan
; Course / Project ID : Program 3           Date: 10/23/17
; Description: This is Program 32, CS271 Week 3 project.

INCLUDE Irvine32.inc

;constants
LOWERLIMIT	=		-100
UPPERLIMIT	=		-1

.data

;intro prompts
intro_1		BYTE	"Welcome to the Integer Accumulator", 0
intro_2		BYTE	"Programmed by Khoa Phan, Project: Program3", 0

;extra credit prompts
EC_1		BYTE	"**EC: Number the lines for user input.", 0

;body prompts
prompt_1	BYTE	"What is your name? ", 0
prompt_2	BYTE	"Hello, ", 0
prompt_3	BYTE	"Please enter numbers in [-100, -1].", 0
prompt_4	BYTE	"Enter a non-negative number when you are finished to see results.", 0
numEnter	BYTE	". Enter number: ", 0

;counter
validNum1	BYTE	"You entered ", 0
validNum2	BYTE	" valid numbers.", 0

msg_err1	BYTE	"Number out of range. ", 0

;display results
sumDisp		BYTE	"The sum of your valid numbers is ", 0
avgDisp		BYTE	"The rounded average is ", 0

;goodbye prompt
noNumber	BYTE	"There were no valid numbers entered.", 0
goodbye		BYTE	"Thank you for playing the Integer Accumulator! Its been a pleasure to meet you, ", 0
period		BYTE	".", 0

;variables
userName	DWORD	33 DUP(0)
num			DWORD	?
count		DWORD	1
sum			DWORD	0
avg			DWORD	?

.code
main PROC

; (insert executable instructions here)

introduction:
; display name, title
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrlF
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrlF
	call	CrlF
	mov		edx, OFFSET EC_1
	call	WriteString
	call	CrlF
	call	CrlF

userInstructions:
; prompt user to enter name, display
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString
	mov		edx, OFFSET prompt_2
	call	WriteString
	mov		edx, OFFSET	userName
	call	WriteString
	call	CrlF
	call	CrlF

numPrompt:
; prompts user to enter numbers
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	CrlF
	mov		edx, OFFSET prompt_4
	call	WriteString
	call	Crlf

	mov		eax, count				;EC number the valid inputs
	call	WriteDec
	mov		edx, OFFSET numEnter
	call	WriteString
	call	ReadInt
	mov		num, eax
	mov		ebx, num
	
	;check limits
	cmp		eax, LOWERLIMIT
	jl		error
	cmp		eax, UPPERLIMIT
	jg		displayResults

	;addition
	mov		eax, num
	add		eax, sum				;add to sum
	mov		sum, eax
	mov		eax, count
	inc		eax
	mov		count, eax
	loop numPrompt

noInput:
; if no numbers are present
	mov		edx, OFFSET noNumber
	call	WriteString
	jmp		farewell

error:
; display error if out of range
	mov		edx, OFFSET msg_err1
	call	WriteString
	jmp		numPrompt

oneInput:
; avg with single valid input
	sub		ebx, 1
	idiv	ebx
	mov		avg, eax
	call	WriteInt
	call	CrlF
	jmp		farewell

displayResults:
; displays results
	call	Crlf
	call	Crlf

	;checks to see if there are entered numbers
	mov		eax, count
	sub		eax, 1
	cmp		eax, 0
	jle		noInput

	;display numbers entered
	mov		edx, OFFSET validNum1
	call	WriteString
	mov		eax, count
	sub		eax, 1
	call	WriteDec
	mov		edx, OFFSET	validNum2
	call	WriteString
	call	Crlf

	;display sum
	mov		edx, OFFSET sumDisp
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrlF

	;display avg
	mov		edx, OFFSET avgDisp
	call	WriteString

	;calc average
	mov		eax, 0
	mov		eax, sum
	cdq
	mov		ebx, count
	cmp		count, 2

	;check if only 1 valid input
	jle		oneInput		

	;multiple valid inputs
	sub		ebx, 1
	idiv	ebx
	mov		avg, eax
	call	WriteInt
	call	CrlF

farewell:
; say goodbye
	call	CrlF
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET	userName
	call	WriteString
	mov		edx, OFFSET	period
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
