TITLE Program5   (Program5.asm)

; Author: Khoa Phan
; Course / Project ID : Program 5           Date: 11/19/17
; Description: This is Program 5, CS271 Week 8 generating Random
;	numberes and sorting them. This will then be displayed to The
;	in rows of 10.
INCLUDE Irvine32.inc

;constants
MIN	=		10
MAX	=		200
HI	=		999
LO	=		100

.data

;intro prompts
intro_1		BYTE	"Sorting Random Integers", 0
intro_2		BYTE	"Programmed by Khoa Phan. Project: Program5", 0

;body prompts
prompt_1	BYTE	"This program generates random numbers in the range [100 .. 999],", 0
prompt_2	BYTE	"displays the original list, sorts the list, and calculates the", 0
prompt_3	BYTE	"the median value. Finally it displays the list sorted in descending order.", 0

prompt_ask	BYTE	"How many numbers should be generated? [10 .. 200]:", 0

msg_unsort	BYTE	"The unsorted random numbers:", 0
msg_med		BYTE	"The median is ", 0
msg_sort	BYTE	"The sorted list: ", 0

EC_1		BYTE	"**EC: Align the output columns.", 0

spaces		BYTE	" ", 9, 0

msg_err1	BYTE	"Invalid input.", 0

;goodbye prompt
goodbye		BYTE	"Results certified by Khoa Phan. Goodbye.", 0

;variables
num			DWORD	?
falseFlag	DWORD	0
rangeFlag	DWORD	0
array		DWORD	MAX		DUP(?)
counter		DWORD	?
temp		DWORD	?

.code
main PROC

	call	introduction
	call	Randomize		;generates random numbers

	;push by reference to stack to change it globally
	push	num					
	call	getUserData

	;push by reference to stack to change it globally
	push	OFFSET array
	push	num
	call	fillArray

	;display unsorted message
	mov		edx, OFFSET msg_unsort
	call	WriteString
	call	CrlF

	;push by reference to stack to change it globally
	push	OFFSET array		
	push	num					
	call	displayList
	call	CrlF

	;display the median value of all the random numbers
	push	OFFSET array
	push	num
	mov		edx, OFFSET	msg_med
	call	CrlF
	call	WriteString
	call	displayMedian
	call	CrlF

	;sort the array in descending order and display it
	push	OFFSET array
	push	num
	call	sortList

	mov		edx, OFFSET	msg_sort
	call	WriteString
	call	CrlF
	push	OFFSET array
	push	num
	call	displayList
	call	CrlF

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
	call	CrlF
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrlF
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrlF
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	CrlF
	call	CrlF

	ret
introduction ENDP

;--------------------------------------------------------
;getUserData
;
; Prompts for user input for the number of numbers to be
;	displayed.
; Receives: num pushed onto stack (reference)
; Returns:  N/A
;--------------------------------------------------------
getUserData PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp+8]

	;prompts user to enter numbers
	promptLoop:
		mov		edx, OFFSET prompt_ask
		call	WriteString
		call	ReadDec
		mov		num, eax
		mov		ebx, num
		call	checkLimits
		cmp		falseFlag, 1
		je		promptLoop				;loop to input if invalid

		mov		num, eax				; valid number

		call	CrlF

		pop		ebp
		ret		4
getUserData ENDP

;--------------------------------------------------------
;checkLimits
;
; Checks the user's input to see if it is a valid integer
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
checkLimits PROC 
	;compares int with constants for range
	mov		num, ebx
	cmp		eax, MIN
	jl		error
	cmp		eax, MAX
	jg		error
	jmp		done

	error:
	;displays error message if out of range
		mov		edx, OFFSET msg_err1
		call	WriteString
		call	CrlF
		mov		falseFlag, 1
		ret

	done:
		mov		falseFlag, 0
		ret
checkLimits ENDP

;--------------------------------------------------------
;checkRange
;
; Checks generated number to see if it is within the
;	correct low range and corrects it by adding 100(LO).
; Receives: N/A
; Returns:  N/A
;--------------------------------------------------------
checkRange PROC 
	;compares int with constants for range
	mov		num, ebx
	cmp		eax, LO
	jl		increment
	jmp		done

	;if number is under 100, increment by 100
	increment:
		add		eax, LO
		ret

	done:
		ret
checkRange ENDP


;--------------------------------------------------------
;fillArray
;
; Fills the pushed array with random numbers.
;	NOTE: borrowed elements from demo5.asm
; Receives: array, num, numCounter onto stack
; Returns:  N/A
;--------------------------------------------------------
fillArray PROC
	;move addresses into esi(array) and ecx(num),
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]
	mov		esi, [ebp+12]

	;generate random numbers
	genNum:
		;create number between 1-1000
		mov		eax, 1000
		call	RandomRange

		;checks the range
		call	checkRange
		je		genNum

		;if number is valid, write into array
		mov		[esi], eax
		add		esi, 4
		loop	genNum
	
	pop		ebp
	ret		8
fillArray ENDP

;--------------------------------------------------------
;sortList
;
; Sorts the array in descending order. Uses a bubble sort
;	to arrange them in order.
;	NOTE: borrows elements from bubblesort, chap 9.5
; Receives: array, num onto stack
; Returns:  Nothing
;--------------------------------------------------------
sortList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]
	dec		ecx

	;point to first value in array
	L1:
		push	ecx
		mov		esi, [ebp+12]

	;compared next element to current element in array
	L2:
		mov		eax, [esi]
		cmp		[esi+4], eax
		jl		L3
		xchg	eax, [esi+4]	;if next element less, swap
		mov		[esi], eax

	;if current element is less than the next, continue to next
	L3:
		add		esi, 4
		loop	L2

	;reset counter
		pop		ecx
		loop	L1

	pop		ebp
	ret		8
sortList ENDP

;--------------------------------------------------------
;displayMedian
;
; Calculates the median value of the numbers in array
;	and displays it.
; Receives: array, num onto stack
; Returns:  Nothing
;--------------------------------------------------------
displayMedian PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		eax, [ebp+8]			;number of elements by user (num)
	mov		edx, 0					;reset to 0 for division

	;locate center value of num and mid point
	mov		ebx, 2					
	div		ebx						;div num by 2
	cmp		edx, 0
	je		ifOdd					;if remainder 0, jump to calculations
	mov		ebx, 4
	mul		ebx
	add		esi, eax
	mov		eax, [esi]
	jmp		print					;else print

	ifOdd:
		;locate highest value
		mov		ebx, 4
		mul		ebx					;by multiplying by 4 then adding esi,
		add		esi, eax			;the address location should be known 
		mov		edx, [esi]			

		;locate smallest value
		mov		eax, esi
		sub		eax, 4				;go down one address location for low
		mov		esi, eax			;the address location should be known 
		mov		eax, [esi]

		;get the average to locate median value
		add		eax, edx
		mov		edx, 0				;add both values then divide in half
		mov		ebx, 2
		div		ebx

	print:
		call	WriteDec
		call	CrlF

	done:
		pop		ebp
		ret		8
displayMedian ENDP

;--------------------------------------------------------
;displayList
;
; Displays the list of integers with 10 numbers per line.
; Receives: array, num onto stack
; Returns:  nothing
;--------------------------------------------------------
displayList PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		ecx, [ebp+8]
	mov		ebx, 1

	;displays the number list
	showList:
		;checks # of elements in row
		cmp		ebx, 10
		jg		newLine

		;move array element into eax, print out
		mov		eax, [esi]
		call	WriteDec

		;move pointer 4, print spaces, increase counter
		add		esi, 4
		mov		edx, OFFSET spaces
		call	WriteString
		inc		ebx
		loop	showList
		jmp		done

	newLine:
		call	CrlF
		mov		ebx, 1
		jmp		showList

	done:
		pop ebp
		ret 12
displayList ENDP

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