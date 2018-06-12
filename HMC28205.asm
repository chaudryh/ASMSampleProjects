TITLE Project 05
;AUTHOR: Hasana Chaudry
;DATE: 11/21/2016
;PURPOSE: To receive two decimal numbers from the user
; and return and display the result of their sum.

INCLUDE Irvine32.inc

ENTER_KEY = 13

.DATA
manyDec		BYTE	"Too many decimal places, re-enter data = ", 0
large		BYTE	"Value is too large, re-enter data = ", 0
xstuff		BYTE	"Input x = ", 0
ystuff		BYTE	"Input y = ", 0
xystuff		BYTE	"x + y = ", 0
again		BYTE	"Again (y/n)? ", 0
deca		BYTE	".", 0
sum			BYTE	"Sum is too large.", 0
integer		DWORD	?
decimal		DWORD	?


.CODE

; Reads the user's input in the form of charachters and
; then performs arithmetic on those charachters to 
; transform them into a decimal number that can be summed.
; The procedure ensures that a certain number of decimal
; places are entered and that the number doesn't exceed
; the 32-bit register limit. If either of the two things
; happen, the user is prompted with an error statement and
; is allowed to re-enter data.

read_number		PROC
				MOV		EAX, 0
				MOV		EBX, 0
				MOV		ECX, 0
				MOV		EDX, 0
				CALL	ReadChar
				CALL	WriteChar
				CMP		AL, '.'
		 		JE		decpart
				SUB		AL, 30h
				MOVZX	EAX, AL
				MOV		integer, EAX
		
top:
				CALL	ReadChar
				CALL	WriteChar
				CMP		AL, '.'
		 		JE		decpart
				CMP		AL,	ENTER_KEY
				JE		done
				SUB		AL, 30h
				MOVZX	EBX, AL
				MOV		EAX, 10
				MUL		integer
				CMP		EDX, 0
				JNE		biterror
				MOV		integer, EAX
				ADD		integer, EBX
				MOV		EBX, 0
				JC		biterror
				MOV		EAX, integer
				JMP top
decpart:
				CALL	ReadChar
				CALL	WriteChar
				SUB		AL, 30h
				MOVZX	EAX, AL
				MOV		decimal, EAX
				MOV		EBX, decimal
				PUSH	EAX
				MOV		EAX, 10
				MUL		EBX
				MOV		EBX, EAX
				POP		EAX

decpart2:
				CALL	ReadChar
				CALL	WriteChar
				CMP		AL, ENTER_KEY
				JE		done
				SUB		AL, 30h
				MOVZX	EBX, AL
				MOV		EAX, 10
				MUL		decimal
				MOV		decimal, EAX
				ADD		decimal, EBX
				MOV		EBX, decimal
decpart3:
				CALL	ReadChar
				CALL	WriteChar
				CMP		AL, ENTER_KEY
				JE		done
				JMP		decerror

decerror:
				CALL	Crlf
				MOV		EDX, OFFSET manyDec
				CALL	WriteString
				CALL	read_number
				JMP		done

biterror:
				CALL	Crlf
				MOV		EDX, OFFSET large
				CALL	WriteString
				CALL	read_number
done:
				MOV		EAX, integer
				
				RET
read_number		ENDP


; Receives input though all four main registers and
; adds the two integers and their decimal values. The
; sum of the integer part is returned through the EAX
; register and the sum of the decimal part is returned 
; through the EDX register. If the sum is too large to
; fit into a 32-bit register, the sum is not performed
; and the user is prompetd that their sum is too large.
; Otherwise the display_number procedure is called and
; the result of the sum is displayed appropriately.


compute_sum		PROC
				ADD		EAX, ECX
				JC		largesum
				ADD		EDX, EBX
				CMP	 	EDX, 100
				JGE		round
				JMP		done
round:
				ADD		EAX, 1
				PUSH	ECX
				MOV		ECX, 100
				SUB		EDX, ECX
				POP		ECX
done:
				CALL	display_number
				JMP		finish
largesum:
				MOV		EDX, OFFSET sum
				CALL	WriteString
finish:
				RET
compute_sum		ENDP


; Receives input through all four main registers and
; displays the sum of both decimal numbers after the
; appropriate prompt is displayed. A decimal and 0 is
; maunally printed if required. The integer portion of
; the sum is returned through the EAX register while 
; the decimal portion of the sum is returned through
; the EDX register


display_number	PROC
				PUSH	EDX
				MOV		EDX, OFFSET xystuff
				CALL	WriteString
				POP		EDX
				CALL	WriteDec
				PUSH	EDX
				MOV		EDX, OFFSET deca
				CALL	WriteString
				POP		EDX
				CMP		EDX, 10
				JL		zero
back:
				PUSH	EAX
				MOV		EAX, EDX
				CALL	WriteDec
				POP		EAX
				JMP		done
zero:
				PUSH	EAX
				MOV		EAX, 0
				CALL	WriteDec
				POP		EAX
				JMP		back
done:
				RET
display_number	ENDP


; The main procedure calls all of the remaining procedures
; and necessary prompts required to perform the desired
; tasks. In between the procedure calls and prompts, values
; are stored either on the stack or in variables. At the end
; of the procedure, the user is asked if they would like to 
; run the program again with new data or if they would like 
; to exit out of the program.


main			PROC
yess:
				; x input
				MOV		EDX, OFFSET xstuff
				CALL	WriteString
				CALL	read_number
				PUSH	EAX
				PUSH	EBX
				CALL	Crlf

				; y input
				MOV		EDX, OFFSET	ystuff
				CALL	WriteString
				CALL	read_number
				MOV		ECX, EAX
				MOV		EDX, EBX
				POP		EBX
				POP		EAX

				; sum computation and display
				CALL	Crlf
				CALL	compute_sum
				CALL	Crlf
				CALL	Crlf

				; optional exit
				MOV		EDX, OFFSET again
				CALL	WriteString
				CALL	ReadChar
				CALL	WriteChar
				CALL	Crlf
				CALL	Crlf
				CMP		AL, 'y'
				JE		yess
				exit
main			ENDP
END				main