TITLE Project 02
;AUTHOR: Hasana Chaudry
;DATE: 10/10/2016
;PURPOSE: To create a triangle using a charachter of the user's choice

INCLUDE Irvine32.inc

.DATA
char	BYTE	?	; stores the user's charachter
num		DWORD 	?	; stores the triangle's height as chosen by the user
prompt1	BYTE	"Enter a charachter to build the triangle from: ", 0
prompt2	BYTE	"Enter how tall the triangle should be: ", 0
prompt3	BYTE	"A triangle of height ", 0
colon	BYTE	":", 0

.CODE
main	PROC  
		MOV		EDX, OFFSET prompt1	 ; loads the address of prompt1 into the EDX register
		CALL	WriteString			 ; writes prompt1 to the console window
		CALL	ReadChar			 ; waits for the user to enter a charachter and then stores it
		CALL	WriteChar			 ; prints the entered charachter to the console window
		MOV		char, AL			
	 	CALL	Crlf					
		MOV		EDX, OFFSET prompt2	 ; loads prompt2
		CALL	WriteString			 ; writes prompt2 
		CALL	ReadDec				 ; waits for user to choose triangle's height and prints it
		CALL	Clrscr				 ; clears screen
		MOV		num, EAX
		MOV		EDX, OFFSET prompt3	 ; loads prompt3
		CALL	WriteString			 ; writes prompt3
		CALL	WriteDec
		MOV		EDX, OFFSET colon
		CALL	WriteString
		CALL	Crlf					
		MOV		AL, char
		MOV		ECX, num		     ; loads first loops value into the ECX register
height:								 ; controls the triangle's height
		MOV		EBX, ECX			 ; stores the first loops current value in the EBX
row:								 ; controls the triangle's width
		CALL	WriteChar			 ; prints the rows of the triangle
loop row 
		CALL	Crlf
		MOV		ECX, EBX			 ; reloads the first loops stored value into the ECX
loop height

		exit					
main	ENDP
END		main