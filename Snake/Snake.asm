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

	
			mGotoxy 22, 3									; Draw ASCII Title "Snake"
			mWrite	" _____                _         "	
			mGotoxy 22, 4									
			mWrite	"/  ___|              | |        "	
			mGotoxy 22, 5									
			mWrite	"\ `--.  _ __    __ _ | | __ ___ "	
			mGotoxy 22, 6									
			mWrite	" `--. \| '_ \  / _` || |/ // _ \"	
			mGotoxy 22, 7									
			mWrite	"/\__/ /| | | || (_| ||   <|  __/"	
			mGotoxy 22, 8									
			mWrite	"\____/ |_| |_| \__,_||_|\_\\___|"	



	
					
	mGotoxy 32, 10						; the project name and our names
	mWrite	"Snake's team"
	mGotoxy 29, 12
	mWrite	"1-Mostafa abo bakr"
	mGotoxy 29, 13
	mWrite	"2-Ahmed Samy"
	mGotoxy 29, 14
	mWrite	"3-Mahmoud diab"
	mGotoxy 29, 15
	mWrite	"4-Mostafa ramzy"
	mGotoxy 29, 16
	mWrite	"5-Mohamed omar"


mGotoxy 26,18                           ; waiting msg "press any key to containue..."
CALL  WaitMsg
mGotoxy 0,0
	
	
	   
	RET
DrawTitleScreen ENDP





;This function display main menu to make user able to choose game Levels and type his name
DrawMainMenu PROC									

	CALL	ClrScr
	CALL	PrintWalls

	
	mGotoxy 26, 7
	mWrite	"Enter Name to continue: "         ; ask the playes to input his name 
mReadString playerName	

	mGotoxy 30, 10
	mWrite	"Select level you want..."        ; ask the player to select the level


    mGotoxy 30, 12                           ; We have three level(Easy-Normal-Hard)                   
	mWrite	"0) Easy"                        ;the speed of the game is differant in each level						
	mGotoxy 30, 13                           ;the initial speed in the first level is 100 and dec by 25 ms in each level 
	mWrite	"1) Normal"
	mGotoxy 30, 14 
	mWrite	"2) Hard"
	mGotoxy 30, 15 
	mWrite	"Selection: "                  

	CALL	ReadChar    
	MOV	choice, AL								; get the level choice
	CALL	WriteChar
											; if the choice is "0"
	CMP	choice, '0'						    ; that means this is the first level
	JNE	X00									; if the choice isn't "0" check the other cases
	MOV	speed, 100							; if the is "0" set the speed 100ms 
	JMP	X02									

    X00:
	CMP	choice, '1'							; Same as above case
	JNE	X01
	MOV	speed, 75
	JMP	X02

    X01:
	CMP	choice, '2'							; Same as above case
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
