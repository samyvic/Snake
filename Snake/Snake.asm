TITLE Snake V1							(Snake.asm)


;Authors : 
;Mostafa Abobakr
;Ahmed Samy
;Mostafa Ramzy
;Mahmoud Diab
;Mohamed Mahmoud Omar
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

; Structs:
AXIS STRUCT										; Struct used to put the seed of food and keep track of snake body.
    x BYTE 0
    y BYTE 0
AXIS ENDS

;Some vars

; Game "Window" Setup:
	maxX		EQU       79							; Fits standard console size
	maxY		EQU       23
	wallHor       	EQU       "--------------------------------------------------------------------------------"
	wallVert      	EQU       '|'
	maxSize		EQU       255
									
									
									; Prototypes:
GetKeyState PROTO STDCALL, nVirtKey:DWORD

;data 
.data

	speed			DWORD   100							; How fast we update the sleep function in ms
    playerName   	BYTE    13 + 1 DUP (?)
    choice       	BYTE    0							; menu selection variable

	score        	DWORD   0
	foodChar     	BYTE   '0'
	snakeChar    	BYTE	'#'
	foodPoint	AXIS    <0,0>							
	SnakeBody    	AXIS    maxSize DUP(<0,0>)	
	currentX	BYTE    40   ; 	X of headsnake						
        currentY	BYTE    10   ; Y of headsnake							
        headIndex   BYTE    3   ; index of headsnake in array of 255 elements
        tailIndex   BYTE    0   ; index of headsnake in array of 255 elements
	RIGHT BYTE    1		; Initialize with snake moving right
	LEFT  BYTE    0							
    	UP    BYTE    0
    	DOWN  BYTE    0
	
	
;Begin of the code
.code

  main PROC 
                 ; our main process that handle all the logics and functions






									
	CALL	DrawTitleScreen								; Load Title Screen(first of all)

     X00:										; entering name and level(starting the game)
	CALL	DrawMainMenu
	
     X01:
	CALL	ClrScr										
	CALL	ScoureInfo
	CALL	PrintWalls
	CALL	GenerateFood
	call waitmsg
	
      X02:										
        CALL	Grow
	    CALL	KeySync									; Did I press any keys?
	RET

	X03:      
        CALL	MoveSnake								; IF game is not over, continue playing
	JMP	X02
	
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





;Start game window


DrawTitleScreen PROC									; Writes the title screen stuff, nothing special
	CALL	ClrScr	
	CALL	PrintWalls

	MOV EAX, cyan+ (black * 16)                         ;make  ASCII Title "Snake"  cyan
        CALL SetTextColor	
	
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



	
		MOV EAX, white + (black * 16)           ;make  our names  white
        CALL SetTextColor	
		
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
	mWrite	"5-Mohamed Mahmoud Omar"

	MOV EAX, red + (black * 16)           ; make the waiting msg red color 
	CALL SetTextColor

mGotoxy 26,18                           ; waiting msg "press any key to containue..."
CALL  WaitMsg
mGotoxy 0,0
MOV EAX, white + (black * 16)          ; reset color to white
CALL SetTextColor
	
	   
	RET
DrawTitleScreen ENDP





;This function display main menu to make user able to choose game Levels and type his name
DrawMainMenu PROC									

	CALL	ClrScr
	CALL	PrintWalls

	MOV EAX, cyan + (black * 16)        ; make the next text cyan 
     CALL SetTextColor

	mGotoxy 26, 7
	mWrite	"Enter Name to continue: "         ; ask the playes to input his name 
    mReadString playerName	

	mGotoxy 30, 10
	mWrite	"Select level you want..."        ; ask the player to select the level

	MOV EAX, Red + (black * 16)               ; make the list of level red color
    CALL SetTextColor

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
	JNE	X0false
	MOV	speed, 50
	JMP	X02

	 X0false:
	INVOKE	Sleep, 100
	mGotoxy 0, 0									; Reset cursor, clear screen
	CALL	DrawMainMenu
	RET


    X02:
	INVOKE	Sleep, 100
	mGotoxy 0, 0									; Reset cursor, clear screen
	CALL	ClrScr									; Exit main menu

	RET
DrawMainMenu ENDP

ScoureInfo PROC										; Display scoure and player name

	mGotoxy	2, 0									
	mWrite	"Score:  "    
	MOV	EAX, score								; Displays all info on top of the screen
	CALL	WriteInt								

	mGotoxy 18, 0								; comment
	mWrite	"Name: "
	mWriteString OFFSET playerName   

	RET
ScoureInfo ENDP

GenerateFood PROC									; Put food on a random point
	CALL Randomize									; Produce new random seed
													
	; Random X Coordinate
	CALL Random32									; Return random (0 to FFFFFFFFh) in EAX	
	XOR	EDX, EDX									; Quickly clears EDX (faster than moving a zero to edx)
	MOV	ECX, maxX - 3								
	DIV	ECX											; DIV EAX by ECX, then store EAX=Quotient, EDX=Remainder
	INC	DL	
	INC	DL											; Fixing a bug (printing the food in the wall)
	MOV	foodPoint.x, DL								; Store new Random X Coordinate for Food

	; Random Y Coordinate, same deal
	CALL	Random32
	XOR	EDX, EDX
	MOV	ECX, maxY - 3
	DIV	ECX
	INC	DL
	INC	DL
	MOV	foodPoint.y, DL
    
	mGotoxy foodPoint.x, foodPoint.y				; Move cursor to the calculated random coordinate
	MOV	AL, foodChar								
	CALL	WriteChar								; print food character on screen

	RET
GenerateFood ENDP

Grow PROC										; Check if snake ate the food
	MOV     AH, currentX
        MOV     AL, currentY

        CMP     AH, FoodPoint.x								; Is my X equal to the Food X
        JNE     X00									; IF not, Exit PROC
        CMP     AL, FoodPoint.y								; Is my y equal to the Food Y
        JNE     X00

        CALL    GenerateFood								; IF we are "colliding" with Food
        INC     headIndex								; Move head index for new growth
        ADD     score, 10								; Score is incremented after eating
   
	X00:
        RET
Grow ENDP

SetDirection PROC, R:BYTE, L:BYTE, U:BYTE, D:BYTE	

	MOV	DL, R										; When the right arrow is pressed, then set the direction to move right
	MOV	RIGHT, DL
    
	MOV	DL, L										; same logic for the other arrows
	MOV	LEFT, DL								
    
	MOV	DL, U
	MOV	UP, DL
    
	MOV	DL, D
	MOV	DOWN, DL
	RET
SetDirection ENDP


KeySync PROC										; Handles arrow key presses

  	X00:
        MOV	AH, 0                                                                   ; Make AH equal zero to work on it
        INVOKE GetKeyState, VK_DOWN                                                     ; getting states of key was pressed						
        CMP	AH, 0									; if the key Pressed? so AH is 1 --> Key Is Pressed
        JE	X01									; id not pressed, jump to next logic
        CMP	currentY, maxY								; Are our snake  in bounds?
        JNL	X08									; if not within bounds jump to X08 which just retrn
		CMP UP, 1                                                                       ; checking current direction of the snake
		JE X08                                                                          ; return if we clicked in opposite direction of snake
        INC	currentY								; if all above conditions are true , Increment y index
        INVOKE	SetDirection, 0, 0, 0, 1						; Travel in -y direction, DOWN is set
        RET
	
	;note that the next three logics works as same as the previous one so no need to add comments

  	X01:
        MOV     AH, 0									
        INVOKE  GetKeyState, VK_UP							
        CMP     AH, 0									
        JE      X02
        CMP     currentY, 0
        JNG     X08 
	CMP DOWN, 1                                                                     
	JE X08                                                                          
        DEC     currentY
        INVOKE  SetDirection, 0, 0, 1, 0
        RET

    X02:     
        MOV     AH, 0									
        INVOKE  GetKeyState, VK_LEFT						
        CMP     AH, 0   
        JE      X03
        CMP     currentX, 0
        JNG     X08
	CMP RIGHT, 1
	JE X08
        DEC     currentX
        INVOKE  SetDirection, 0, 1, 0, 0
        RET

    X03:  
        MOV		AH, 0								
        INVOKE  GetKeyState, VK_RIGHT
        CMP     AH, 0   
        JE      X04
        CMP     currentX, maxX
        JNL     X08 
	CMP LEFT, 1
	JE X08
        INC     currentX
        INVOKE  SetDirection, 1, 0, 0, 0
        RET
	
	; the next logics to make the snake in contionous moving if we didnt changed the direction!

    X04:     
        CMP     RIGHT, 0							; have we changed our direction?
        JE      X05									; if RIGHT has been changed jump to next logic
        CMP     currentX, maxX						; Are we out of bounds?
        JNL     X08									; if out of bounds, just return
        INC     currentX                            ; if above conditions are true , travel x direction
	ret
	
	;the next three logics as same as the previous one!
	
    
	X05:
        CMP     LEFT, 0									
        JE	X06
        CMP     currentX, 0
        JNG     X08
        DEC     currentX
	ret
    
	X06:
        CMP     UP, 0									
        JE      X07
        CMP     currentY, 0
        JNG     X08
        DEC     currentY
	ret

    X07:
        CMP     DOWN, 0									
        JE      X08
        CMP     currentY, maxY
        JNL     X08
        INC     currentY
	ret

    X08:													
        RET													
KeySync ENDP

MoveSnake PROC
	MOV	ECX, 0
	MOV	CL, headIndex								; Head index in the snakebody array
    
	MOV	AL, currentX								; new (updated) current X and Y coordinates of the snake head
	MOV	AH, currentY								; moving them to AL and Ah

	MOV	SnakeBody[2 * ECX].x, AL						; moving the snake body to the new position
	MOV	SnakeBody[2 * ECX].y, AH						; [2*ECX] --> each array element is 2 bytes 
															
	mGotoxy SnakeBody[2 * ECX].x, SnakeBody[2 * ECX].y				; moving the cursor to the new postion
	MOV	AL, snakeChar									
	CALL	WriteChar								; printing a snakechar to the screen
    
	INVOKE	Sleep, speed								; Suspends execution, for a specified interval equals to the interval of speed 
      

	RET
MoveSnake ENDP

;this proc check that the snake hits the border to enter it on "game over"

;This figure shows the boundaries that if the snake hits it, it gets game over
;----------------------
;|(1 1 1 1 1 1 1 1 1 )|
;| 0                  | 
;| 0            (maxX)|
;| 0                  |  
;| 0      (maxY)      |
;|--------------------|
;1---> top 
;0--->left
;(maxX)---> Right
;(maxY)---> Left

IsCollision PROc

CMP	currentX, 0				         ; Did the snake hit the left side??		
JE	X00										
CMP	currentY, 1						 ; Did the snake hit the top side??
JE	X00
CMP	currentX, maxX					 ; Did the snake hit the right side..??
JE	X00
CMP	currentY, maxY					 ; Did the snake hit the bottom side..??
JE	X00
JMP	X01								; if the snake didn't hit any walls ...jamp
	
X00:
MOV	EAX, 1							;this register (EAX) check if the game is over or not..
RET

X01:
MOV	EAX, 0									; 0 means that the gme is not over .
RET
IsCollision ENDP

END main
