TITLE Program4   (Program4.asm)

; Author: Khoa Phan
; Course / Project ID : Program 4           Date: 11/04/17
; Description: This is Program 4, CS271 Week 6 project.
;				It takes a user input integer to determine
;				the limit to display the number of 
;				composite numbers shown onto the screen.

INCLUDE Irvine32.inc

;constants
LOWERLIMIT	=		1
UPPERLIMIT	=		400

.data

;intro prompts
intro_1		BYTE	"Composite Numbers", 0
intro_2		BYTE	"Programmed by Khoa Phan, Project: Program4", 0

;body prompts
prompt_1	BYTE	"Enter the number of composite numbers you would like to see.", 0
prompt_2	BYTE	"I'll accept orders for up to 400 composites", 0
prompt_3	BYTE	"Enter the number of composites to display. [1 .. 400]: ", 0

EC_1		BYTE	"**EC: Align the output columns.", 0

spaces		BYTE	" ", 9, 0

msg_err1	BYTE	"Out of range. Try again.", 0

;goodbye prompt
goodbye		BYTE	"Results certified by Khoa Phan. Goodbye.", 0

;variables
num			DWORD	?
falseFlag	DWORD	0
col			DWORD	?
currentNum	DWORD	0
factor		DWORD	?
factorMax	DWORD	?



.code
main PROC

	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP


;--------------------------------------------------------
;introduction 
;
; Displays information regarding the program and author.
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
introduction PROC
	;intro prompts
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrlF
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrlF

	;EXTRA CREDIT 
	mov		edx, OFFSET EC_1
	call	WriteString
	call	CrlF
	call	CrlF
	ret
introduction ENDP

;--------------------------------------------------------
;getUserData
;
; Gets integer from user that then calls for the number
;	in range.
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
getUserData PROC USES edx eax ebx,
	;prompts user to enter numbers
	promptLoop:
		mov		edx, OFFSET prompt_3
		call	WriteString
		call	ReadDec
		mov		num, eax
		mov		ebx, num
		call	checkLimits
		cmp		falseFlag, 1
		je		promptLoop

		call	CrlF
		ret
getUserData ENDP

;--------------------------------------------------------
;checkLimits
;
; Takes user input integer then compares it to the
;	upper and lower limits to see if it is a valid
;	input.
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
checkLimits PROC
		;compares int with constants
		mov		num, ebx
		cmp		eax, LOWERLIMIT
		jl		error
		cmp		eax, UPPERLIMIT
		jg		error
		jmp		done

		error:
		; display error if out of range, set falseFlag to true
			mov		edx, OFFSET msg_err1
			call	WriteString
			call	CrlF
			mov		falseFlag, 1
			ret

		done:
			;if valid, return falseFlag as false
			mov		falseFlag, 0
			ret
checkLimits ENDP

;--------------------------------------------------------
;showComposites
;
; Displays calculated composite numbers and prints them
;	out in a row up to 10 per row.
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
showComposites PROC USES eax edx edx,
	;set first composite number to 4
		mov		ecx, num
		mov		currentNum, 4
		mov		col, 1
	
	;checks composites
	compositeLoop:
		call	isComposite

	; prints composites out in rows of 10
	printComp:
		mov		eax, currentNum
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		currentNum
		cmp		col, 10
		jge		newRow
		inc		col
		jmp		continue


	;new line, reset column if row exceeds 10
	newRow:
		call	CrlF
		mov		col, 1

	continue:
		loop	compositeLoop

	done:
		ret
showComposites ENDP

;--------------------------------------------------------
;isComposite
;
; Calculates composite number to be printed. Divides
;	number by 2 then 3 ... x-1 until remainder equals 0.
; Receives: N/A
; Returns:  currentNum, same value or new value
;--------------------------------------------------------
isComposite PROC
	;resets factorials to default values to check composite
	resetFact:
		mov		eax, currentNum
		dec		eax
		mov		factor, 2
		mov		factorMax, eax

	;dividing number by 2, 3, x-1 until 0 to
	;find composite
	factoring:
		mov		eax, currentNum
		cdq
		div		factor
		cmp		edx, 0
		je		done
		inc		factor
		mov		eax, factor
		cmp		eax, factorMax
		jle		factoring
		inc		currentNum
		jmp		resetFact

	done:
		ret
isComposite ENDP

;--------------------------------------------------------
;farewell 
;
; Displays the good bye to the program to user
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
farewell PROC 
	call	CrlF
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrlF
	ret
farewell ENDP

END main