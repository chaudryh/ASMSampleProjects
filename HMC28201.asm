TITLE Project 01
;AUTHOR: Hasana Chaudry
;DATE: 9/15/2016
;PURPOSE: Producing the sum of variables in an array.

INCLUDE Irvine32.inc

.DATA
array	DWORD	2, 4, 6			; creates an array of size 3
sum		DWORD	0BADABADAh		; initializes a variable sum

.CODE
main	PROC
		MOV		EAX, 0			; clears out the EAX register
		MOV		EAX, [array]	; moves the first value in array to the EAX register
		ADD		EAX, [array+4]	; adds the second value of array to the EAX register
		ADD		EAX, [array+8]	; adds the third value of array to the EAX register
		MOV		ECX, EAX		; moves the EAX register to the ECX register
		MOV		EAX, sum		; moves the value of sum to the EAX register
		MOV		sum, ECX		; moves the ECX register to sum
		MOV		ECX, EBX		; preserves the value of EBX in the ECX register
		MOV		EBX, sum		; stores the value of sum in the EBX register

		CALL	DumpRegs		; outputs the values of all registers
		exit					; exits program
main	ENDP
END		main