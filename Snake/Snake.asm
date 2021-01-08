TITLE Snake V1							(Snake.asm)


;Authors : 
;Mostafa Abobakr
;Ahmed Samy
;Mostafa Ramzy
;Mahmoud Diab
;Mohamed Omar
;This project is built by 32 assembly using Ivrine32 library

; Files:
INCLUDE		Irvine32.inc								; GoToXY, Random32, Randomize
INCLUDELIB	user32.lib								; GetKeyState


; Macros:
mGotoxy MACRO X:REQ, Y:REQ								; Reposition cursor to x,y position
	PUSH	EDX
	MOV	DH, Y
	MOV	DL, X
	CALL	Gotoxy
	POP	EDX
ENDM


mWrite MACRO text:REQ									; Write string literals.
	LOCAL string
	.data
		string BYTE text, 0
	.code
		PUSH	EDX
		MOV	EDX, OFFSET string
		CALL	WriteString
		POP	EDX
ENDM


mWriteString MACRO buffer:REQ								; Write string variables
	PUSH	EDX
	MOV	EDX, OFFSET buffer
	CALL	WriteString
	POP	EDX
ENDM


mReadString MACRO var:REQ								; Read string from console
	PUSH	ECX
	PUSH	EDX
	MOV	EDX, OFFSET var
	MOV	ECX, SIZEOF var
	CALL	ReadString
	POP	EDX
	POP	ECX
ENDM


;Some vars

; Game "Window" Setup:
	maxX		EQU       79							; Fits standard console size
	maxY		EQU       23
	wallHor       	EQU       "--------------------------------------------------------------------------------"
	wallVert      	EQU       '|'
	maxSize		EQU       255
											

;data 
.data

	speed		DWORD   60							; How fast we update the sleep function in ms
    playerName   	BYTE    13 + 1 DUP (?)
    choice       	BYTE    0							; menu selection variable

					

;Begin of the code
.code

main PROC
	CALL	StartGame
	RET
main ENDP


;This function used to draw the window walls in all game windows

PrintWalls PROC										; Draw Walls to screen
	mGotoxy 0, 1     
	mWrite	wallHor
	mGotoxy 0, maxY									; Draw top and bottom walls
	mWrite	wallHor    
	MOV	CL, maxY - 1								; Prepare CL for vertical wall placement
	
    X00:
	CMP	CL, 1									; WHILE CL != 0
	JE	X01									; IF it does, exit WHILE loop
        mGotoxy 0, CL									; Write left wall piece
        mWrite	wallVert								
        mGotoxy maxX, CL
        mWrite	wallVert								; Write right wall piece
        DEC	CL									; travel up the screen until all are placed
	JMP	X00									; Jump to top of WHILE loop
    
    X01:
	RET
PrintWalls ENDP


;This function is used to manage all the gameplay in sequence
StartGame PROC										; Handles main game state logic and loop.
	CALL	DrawTitleScreen								; Load Title Screen

     X00:										; Initial start game
	CALL	DrawMainMenu									


	RET
StartGame ENDP


;Start game window

DrawTitleScreen PROC									; Writes the title screen stuff, nothing special
	CALL	ClrScr
	CALL	PrintWalls
		
	mGotoxy 15, 4									; Draw ASCII Title
	mWrite	"  ___                 _            __   __      _  "	
	mGotoxy 15, 5
	mWrite	" / __|  _ _    __ _  | |__  ___    \ \ / /     / | "
	mGotoxy 15, 6
	mWrite	" \__ \ | ' \  / _` | | / / / -_)    \ V /   _  | | "
	mGotoxy 15, 7
	mWrite	" |___/ |_||_| \__,_| |_\_\ \___|     \_/   (_) |_| "
					
	mGotoxy 32, 12									; Pretty self explanatory
	mWrite	"Test Version"
	mGotoxy 32, 14
	mWrite	"Assembly(x86)"
	mGotoxy 32, 16
	mWrite	"MASM and Irvine32"
	mGotoxy 25, 20

	CALL	WaitMsg
	mGotoxy 0, 0  
	   
	RET
DrawTitleScreen ENDP

;This function display main menu to make user able to choose game difficulty and put his name
DrawMainMenu PROC									; Game settings initializing for speed

	CALL	ClrScr
	CALL	PrintWalls

	mGotoxy 30, 5									; Main Menu display and name prompt
	mWrite	"--MAIN MENU--"
	mGotoxy 30, 7
	mWrite	"Enter Name: "
	mReadString playerName								; Get player name
	mGotoxy 30, 10
	mWrite	"--DIFFICULTY--"							; Difficulty Prompt
	mGotoxy 30, 12  
	mWrite	"0) Easy"						
	mGotoxy 30, 13 
	mWrite	"1) Normal"
	mGotoxy 30, 14 
	mWrite	"2) Hard"
	mGotoxy 30, 15 
	mWrite	"Selection: "

	CALL	ReadChar    
	MOV	choice, AL								; Get difficulty choice
	CALL	WriteChar
											; Pretty much a switch(choice)
	CMP	choice, '0'								; case: '0'
	JNE	X00									; IF it was not '0' check other cases
	MOV	speed, 100								; IF it was, set speed to 100
	JMP	X02									; Jump to logic at bottom

    X00:
	CMP	choice, '1'								; Same as above case
	JNE	X01
	MOV	speed, 75
	JMP	X02

    X01:
	CMP	choice, '2'								; Same as above case
	JNE	X02
	MOV	speed, 50
	JMP	X02

    X02:
	INVOKE	Sleep, 100
	mGotoxy 0, 0									; Reset cursor, clear screen
	CALL	ClrScr									; Exit main menu

	RET
DrawMainMenu ENDP


END main
