TITLE Project 06
;AUTHOR: Hasana Chaudry
;DATE: 12/6/2016
;PURPOSE: To receive an input array from the user,
; sort it, and return it in ascending order.

INCLUDE Irvine32.inc


.DATA
prompt1		BYTE	"Enter numbers between 0 and 999 (-1 to stop): ", 0
prompt2		BYTE	"Sorted array: ", 0
prompt3		BYTE	"Invalid entry. Try again.", 0

arrayAdd	DWORD		?
arraySize	DWORD		?
.CODE


;--------------------------------------------------------------
; This procedure revceives the address and the number of items
; in an array through the stack. It creates a stack frame and
; calls the procedure named 'smallest' to find the smallest 
; value in the array before swapping it with the first value
; in the array. This is a recursive procedure. Once it swaps 
; the first value, it decreases the array size and increments
; the array adress before calling itself in order to pass an 
; array with different parameters. The procedure continues to 
; call itself recursively until all the value in the array 
; have been sorted.
;-------------------------------------------------------------


sort_array		PROC
				PUSH	EBP
				MOV		EBP, ESP

				MOV		ECX, [EBP+8]
				MOV		EDI, [EBP+12]

				CMP		ECX, 1
				JE		done	
sort:
				CALL	smallest
				MOV		EDI, [EBP+12]
				MOV		EBX, [EDI]
				MOV		[EDI], EAX
				MOV		[ESI], EBX
			
				ADD		EDI, 4
				PUSH	EDI			
				dec		ECX
				PUSH	ECX
				CALL	sort_array
done:	
				MOV		ESP, EBP
				POP		EBP
				RET		
sort_array		ENDP


;--------------------------------------------------------------
; This is an optional procedure that receives the address and 
; number of items in an array. It uses a counter loop to go 
; through the array and find its smallest value. The smallest
; value is returned in the EAX register and its address is 
; stored in the ESI register. This procedure also implements a
; stack frame.
;--------------------------------------------------------------


smallest		PROC
				PUSH	EBP
				MOV		EBP, ESP
		
				PUSH	ECX
				MOV		ECX, [EBP+16]
				MOV		EDI, [EBP+20]

				MOV		EAX, [EDI]
				MOV		ESI, EDI
top:
				ADD		EDI, 4
				MOV		EBX, [EDI]
				CMP		EAX, EBX
				JLE		done
				MOV		ESI, EDI
				MOV		EAX, EBX
done:
				loop top	
				POP		ECX
				MOV		ESP, EBP
				POP		EBP
				RET		
smallest		ENDP


;------------------------------------------------------------------
; This procedure revceives the address and the number of items
; in an array through the stack. It creates a stack frame before 
; going theough the array and displaying each value using the EAX
; register. Afterwards, it removes the stack parameters from the
; stack.
;------------------------------------------------------------------


display_array	PROC
				PUSH	EBP
				MOV		EBP, ESP

				MOV		ECX, [EBP+8]
				MOV		EDI, [EBP+12]
top:
				MOV		EAX, [EDI]
				ADD		EDI, 4 
				CALL	WriteDec
				CALL	Crlf
				loop top
done:
				MOV		ESP, EBP
				POP		EBP
				RET		8
display_array	ENDP


;--------------------------------------------------------------------------
; This is the main procedure. It initializes the program by giving the
; user a prompt to begin inserting the array. The array is stored on the
; stack each value at a time, The procedure then pushes on the address and
; size of the array as stack parameters before calling to sort the array.
; A prompt is then displayed for the sorted array followed by the display
; of the array itself. The program ends with a clean up of the stack.
;--------------------------------------------------------------------------- 


main			PROC
				; initializing the program
				MOV		EDX, OFFSET prompt1
				CALL	WriteString
				CALL	Crlf
				MOV		ECX, 0
				
				; storing the array
more:
				CALL	ReadInt
				CMP		EAX, -1
				JL		bad
				JE		done
				CMP		EAX, 999
				JG		bad

				ADD		ECX, 1
				PUSH	EAX
				JMP		more
bad: 
				MOV		EDX, OFFSET prompt3
				CALL	WriteString
				CALL	Crlf
				JMP		more
done:
				; sorting the array
				MOV		arraySize, ECX
				LEA		EDI, [ESP]
				PUSH	EDI
				PUSH	ECX
				CALL	sort_array

				; displaying the array
				MOV		EDX, OFFSET prompt2
				CALL	WriteString
				CALL	Crlf 
				CALL	display_array
				
				; cleaning up the stack
				MOV		ECX, arraySIze
				MOV		AL, 4
				MUL		ECX
				ADD		ESP, EAX

				exit
main			ENDP
END				main