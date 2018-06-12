TITLE Project 03
;AUTHOR: Hasana Chaudry
;DATE: 10/25/2016
;PURPOSE: To analyze data entered by a user and return the highest value

INCLUDE Irvine32.inc

.DATA


array	DWORD	100 DUP(?)
prompt1	BYTE	"Enter up to 100 numbers, one per line (-1 when done): ", 0
prompt2 BYTE	"Invalid entry: numbers must be from 1 to 5000", 0
prompt3 BYTE	"Highest number entered: ", 0


.CODE


; The program begins with this procedure that prompts the user to enter
; data until they reach te maximum limit of the array or enter -1. The
; procedure keeps track of the number of positive values entered in the 
; array and return that number to the ECX register.


enter_data	proc	USES EAX
	    INC		ECX
		MOV		EDX, OFFSET prompt1
		CALL	WriteString
		CALL	Crlf
		MOV		EBX, 0			;entries read by array so far
more_data:					
		DEC		ECX				;controls the length of the array
		JECXZ	finish
		INC		EBX
		CALL	ReadInt			; reads signed input 
		MOV		[ESI], EAX		; movesentered number to ESI location
		MOV		EDI, ESI		; passes addres of number being examined
		ADD		ESI, TYPE DWORD		
		CMP		EAX, -1			; allows user to exit with -1
		JE		done				
		PUSH	EAX
		PUSH	EBX
		MOV		EAX, 1
		MOV		EBX, 5000
		CALL	check_range
		POP		EBX
		POP		EAX
		JMP		more_data
done:
		DEC		EBX	
finish:
		MOV		ECX, EBX
		MOV		EAX, ECX												
		RET					
enter_data	ENDP


; This procedure evaluates a single value that it receives via 
; the EDI and verifies that it is in the range between 1 and 5000. 
; If the number isn't in the range, it allows the user to re-enter
; data until the range is met. It doesn't return any value.


check_range		proc	USES EAX EBX
recheck:
		CMP		[EDI], EAX
		JL		error			; displays error message too small

		CMP		[EDI], EBX		; moves to this step if not
		JLE		done			
error:							; asks for valid number if error
		MOV		EDX, OFFSET prompt2 
		CALL	WriteString
		CALL	Crlf
		PUSH	EAX
		CALL	ReadDec			; re-entry until range is satisfied
		MOV		[EDI], EAX		; re-entered vaue in place of old one
		POP		EAX
		JMP		recheck	
done:
		RET
check_range	ENDP


; This procedure analyzes the array once it has been completely
; entered and goes through each value to find the highest one.
; The highest value is returned to the EAX register


compute_high	PROC	USES ECX ESI
		MOV		EAX, [ESI]		;stores the largest number
		DEC		ECX
L5:								;loops through the array
		ADD		ESI, 4		
		MOV		EBX, [ESI]		
		CMP		EAX, EBX		; compares two elements in array
		JAE		L6
		MOV		EAX, EBX
L6:
		loop L5	 
		RET
compute_high	ENDP


; This procedure recieves the highest value that was returned to 
; the EAX register by the compute_high procedure and displays it
; on the screen after a prompt that informs the user that the 
; displayed value is the highest value.


display_high	PROC
		CALL	compute_high
		CALL	Crlf
		MOV		EDX, OFFSET prompt3
		CALL	WriteString
		CALL	WriteDec
		CALL	Crlf
		RET
display_high	ENDP


; This is the main procedure that calls all the other
; procedures and executes the code that is required 
; to perform the specifications of this program.
; It recieves the address of the array via the ESI.
; It returns the highest value entered by the user.


main	Proc
		MOV		ESI, OFFSET array	
		MOV		ECX, 100				
		CALL	enter_data
		MOV		ESI, OFFSET array   
		CALL	display_high

		exit
main	ENDP
END		main
