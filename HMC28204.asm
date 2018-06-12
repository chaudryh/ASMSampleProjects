TITLE Project 04
;AUTHOR: Hasana Chaudry
;DATE: 11/07/2016
;PURPOSE: To analyze data entered by a user and perform
; operations of their choice.

INCLUDE Irvine32.inc

.DATA

prompt1	BYTE "Please select one of the following: ",0
prompt2 BYTE "(1) Shift left (logical)",0
prompt3 BYTE "(2) Shift right (logical)", 0
prompt4 BYTE "(3) Shift left (arithmetic)",0
prompt5 BYTE "(4) Shift right (arithmetic)", 0
prompt6 BYTE "(5) Rotate left",0
prompt7 BYTE "(6) Rotate right",0
prompt8 BYTE "(7) Rotate left with carry",0
prompt9 BYTE "(8) Rotate right with carry",0
prompt10 BYTE "(9) Input new number",0
prompt11 BYTE "Your choice: ", 0
prompt12 BYTE "Enter a number between 0 and 255: ",0
prompt14 BYTE	"Enter a a number within the range: ",0
prompt15 BYTE	"Select a valid choice: ",0
prompt16 BYTE	"The byte",0
prompt17 BYTE	"CF",0
prompt18 BYTE	"Value", 0
one		 BYTE	"1", 0
zero	 BYTE	"0", 0
erase2	 BYTE	"                                   ", 0
erase1	 BYTE	" ",0
bitstring BYTE	8 DUP(0), 0
number	 DWORD	?

.CODE

; This procedure deals with display of the user's
; decimal value in binary bits, by converting it 
; into a string first. The bits are then displayed
; beneath the bit title in the menu.

bit_stuff	PROC
				PUSHFD
				MOV		DH, 1
				MOV		DL, 0
				CALL	Gotoxy
				MOV		ESI, OFFSET bitstring
				MOV		ECX, 8
top:
				MOV		BYTE PTR [ESI], '0'
				ROL		AL, 1
				JNC		cf0
				MOV		BYTE PTR [ESI], '1'
cf0:
				INC		ESI
				MOV		BYTE PTR [ESI], ' '
				INC		ESI
				loop top
				MOV		EDX, OFFSET bitstring
				CALL	WriteString
				CALL	Crlf
				POPFD
				RET
bit_stuff		ENDP

; This procedure receives the user's value
; through the EAX register and then displays
; it under the value title in the menu.

value_stuff		PROC
				PUSHFD
				MOV		DH, 1
				MOV		DL, 31
				CALL	Gotoxy
				MOV		EDX, OFFSET erase2
				CALL	WriteString	
				MOV		DH, 1
				MOV		DL, 31
				CALL	Gotoxy
				CALL	WriteDec
				POPFD
				RET
value_stuff		ENDP
		
; This procedure checks whether the carry
; flag has been set or not. If it has been
; set, a 1 is printed onto the secreen 
; beneath the carry flag title. Otherwise
; a 0 is printed to the screen.

carry_stuff		PROC
				JNC		uncarry
				MOV		EDX, OFFSET one
				CALL	WriteString
				JMP		pastcarry
uncarry:
				MOV		EDX, OFFSET zero
				CALL	WriteString
pastcarry:
				RET
carry_stuff 	ENDP

; handles the menu display and calls
; necessary functions to execute the user's 
; choice and perform the desired operations

display_menu	Proc
				; displays the small menu where the binary bits, 
				; value of the carry flag, and decimal value
				; will be displayed

				; carry title
				PUSHFD
				MOV		DH, 0
				MOV		DL, 20
				CALL	Gotoxy
				POPFD
				MOV		EDX, OFFSET prompt17
				CALL	WriteString

				; value title
				PUSHFD
				MOV		DH, 0
				MOV		DL, 30
				CALL	Gotoxy
				POPFD
				MOV		EDX, OFFSET prompt18
				CALL	WriteString
				CALL	value_stuff

				; bits title
				PUSHFD
				MOV		DH, 0
				MOV		DL, 0
				CALL	Gotoxy
				POPFD
				MOV		EDX, OFFSET prompt16
				CALL	WriteString
				CALL	bit_stuff

				; presents the user with all the available 
				; options in the menu
				PUSHFD
				CALL	Crlf
				MOV		EDX, OFFSET prompt1
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt2
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt3
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt4
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt5
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt6
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt7
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt8
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt9
				CALL	WriteString
				CALL	Crlf
				MOV		EDX, OFFSET prompt10
				CALL	WriteString
				CALL	Crlf
				CALL	Crlf
				POPFD
				CALL	choice
				RET
display_menu	ENDP

; This procedure prompts the user to select an option 
; from the diplayed menu and then checks the user's
; input to make sure it is within the required
; range before proceeding to evaluate the choice.
; If the number is out of range, a prompt is 
; displayed and the user is allowed to select
; another choice

choice			PROC
				MOV		EDX, OFFSET prompt11
				CALL	WriteString
				MOV		number, EAX
try:
				CALL	ReadChar
				CALL	WriteChar	
				CALL	IsDigit
				JNZ		no		
				MOVZX	EAX, AL
				SUB		EAX, 30h
				CMP		AL, 0
				JE		no
				PUSH	EAX
				MOV		EAX, 500
				CALL	Delay
				POP		EAX
				PUSHFD
				MOV		DH, 14
				MOV		DL, 13
				CALL	Gotoxy
				POPFD
				; erases previous choices when 
				; the operation is done
				MOV		EDX, OFFSET erase1
				CALL	WriteString
				PUSHFD
				MOV		DH, 15
				MOV		DL, 0
				CALL	Gotoxy
				POPFD
				MOV		EDX, OFFSET erase2
				CALL	WriteString
				MOV		EBX, EAX
				MOV		EAX, number
				CALL	eval_choice
				JMP		yes
no:
				PUSHFD
				CALL	Crlf
				POPFD
				MOV		EDX, OFFSET prompt15
				CALL	WriteString
				PUSHFD
				MOV		DH, 15
				MOV		DL, 23
				CALL	Gotoxy
				MOV		DH, 16
				MOV		DL, 0
				CALL	Gotoxy
				POPFD
				MOV		EDX, OFFSET erase2
				CALL	WriteString
				PUSHFD
				MOV		DH, 15
				MOV		DL, 23
				CALL	Gotoxy
				POPFD
				JMP		try
				
yes:
				RET
choice			ENDP

; This procedure recognizes the menu selection that
; the user has made in the choice procedure and then
; evaluates that choice by performing the operation 
; that user has selected. When the process is done,
; the user is presented with the menu again and is 
; allowed to perform other operations by selecting
; another choice. After the user's desired operation
; is performed, the display menu at the top is updated 
; with the corresponding bits, decimal value, and 
; carry flag value.

eval_choice		PROC
				PUSHFD
				MOV		DH, 17
				MOV		DL, 0
				CALL	Gotoxy
				CMP		EBX, 1
				JNE		two
				POPFD
				SHL		AL, 1
				JMP		done
two:
				CMP		EBX, 2
				JNE		three
				POPFD
				SHR		AL, 1
				JMP		done
three:
				CMP		EBX, 3
				JNE		four
				POPFD
				SAL		AL, 1
				JMP		done
four:
				CMP		EBX, 4
				JNE		five
				POPFD
				SAR		AL, 1
				JMP		done
five:
				CMP		EBX, 5
				JNE		six
				POPFD
				ROL		AL, 1
				JMP		done
six:
				CMP		EBX, 6
				JNE		seven
				POPFD
				ROR		AL, 1
				JMP		done
seven:
				CMP		EBX, 7
				JNE		eight
				POPFD
				RCL		AL, 1
				JMP		done
eight:
				CMP		EBX, 8
				JNE		nine
				POPFD
				RCR		AL, 1
				JMP		done
nine:
				CMP		EBX, 9
				POPFD
				CALL	Clrscr
				CALL	input_value
				CALL	Clrscr
				CALL	bit_stuff
				CALL	value_stuff
				PUSHFD
				CALL	Crlf
				POPFD
				PUSHFD	
				MOV		DH, 1
				MOV		DL, 20
				CALL	Gotoxy
				MOV		EDX, OFFSET zero
				CALL	WriteString
				POPFD
				CALL	display_menu	
done:		
				CALL	bit_stuff
				PUSHFD
				MOV		DH, 1
				MOV		DL, 20
				CALL	Gotoxy
				POPFD
				CALL	carry_stuff
				CALL	value_stuff
				PUSHFD
				MOV		DH, 14
				MOV		DL, 14
				CALL	Gotoxy
				POPFD
				CALL	display_menu
				
				RET
eval_choice		ENDP

; The program begins with this procedure. It
; displays a single prompt that asks the user 
; for an initial decimal value to start the display a
; and operations with. After a value has been received,
; it is evaluated to ensure it is within the 8-bit 
; range before the screen is cleared.

input_value		PROC
				MOV		EDX, OFFSET prompt12
				CALL	WriteString 
				CALL	ReadInt
				MOV		EBX, 0
				MOV		ECX, 255
				CALL	check_range
				RET
input_value		ENDP

; This procedure performs the operations that
; ensure the user's input value is within the
; 8-bit range. If it is not, the user is 
; prompted to input another value. This is 
; repeated until a valid selection has been
; received.

check_range		proc	USES EBX ECX
recheck:
		CMP		EAX, EBX
		JL		error			; displays error message too small

		CMP		EAX, ECX		; moves to this step if not
		JLE		done			
error:							; asks for valid number if error
		MOV		EDX, OFFSET prompt14
		CALL	WriteString
		CALL	ReadInt
		JMP		recheck
done:
		RET
check_range	ENDP

; This is the main procedure. All of the 
; remaining necessary procedures are 
; called in this procedure in an specific
; order so that the program runs accordingly. 

main	Proc
				CALL	input_value
				CALL	Clrscr
				PUSHFD	
				MOV		DH, 1
				MOV		DL, 20
				CALL	Gotoxy
				MOV		EDX, OFFSET zero
				CALL	WriteString
				CALL	Crlf
				POPFD
				CALL	display_menu
		exit
main	ENDP
END		main