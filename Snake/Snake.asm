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
mGotoxy MACRO X:REQ, Y:REQ								; make the cursor going to x,y coordinates
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

; KeyCodes:
	VK_LEFT		EQU	25h  ; key code for left arrow
	VK_UP		EQU	26h  ; key code for up arrow
	VK_RIGHT	EQU	27h  ; key code for right arrow
	VK_DOWN		EQU	28h  ; key code for down arrow

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
	snakeChar    	BYTE	'O'
	FsnakeChar    	BYTE	'#'
	foodPoint	AXIS    <0,0>							
	SnakeBody    	AXIS    maxSize DUP(<0,0>)	
	currentX	BYTE    40   ; 	X of headsnake						
        currentY	BYTE    10   ; Y of headsnake							
        headIndex   BYTE    3   ; index of headsnake in array of 255 elements
		 headIndextest   BYTE    3   ; index of headsnake in array of 255 elements
        tailIndex   BYTE    0   ; index of headsnake in array of 255 elements
	RIGHT BYTE    1		; Initialize with snake moving right
	LEFT  BYTE    0							
    	UP    BYTE    0
    	DOWN  BYTE    0
	    lives     BYTE    3   



	
;Begin of the code
.code

  main PROC 
  
   ; our main process that handles all the logics and functions
								
	CALL	DrawTitleScreen						; Load Title Screen(first of all)								
	CALL	DrawMainMenu						; entering name and level(starting the game)
	CALL	ClrScr										
	CALL	PrintWalls						    ; printing the walls of the game
	CALL	GenerateFood						; using randomize to produce a food seed
	
    X00:										
        CALL	Grow							; Checking a the snake ate the food, produce a new one
	CALL	KeySync							   ; Getting directions from the player

    X01:
	CALL	IsCollision						; check if the snake collides with the wall
	CMP	EAX, 1							; EAX holds whether game is over or not
	JNE	X02							; Continue if there is no collision
	JMP	X03							; If the snake hit the wall, jump to GameOver
	
    X02:      
        CALL	MoveSnake						; Keep the snake moving 
	CALL	ScoureInfo						; updating the score
	JMP	X00							; loop to get a new direction from keySync

    X03:																																			
	     INVOKE	Sleep, 100
        CALL	DrawGameOver																												

   

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
	JNE X02
	MOV	speed, 50
	JMP	X02

    X02:
	INVOKE	Sleep, 100
	mGotoxy 0, 0									; Reset cursor, clear screen
	CALL	ClrScr									; Exit main menu

	MOV EAX, cyan + (black * 16)                    ; make the color cyan      
    CALL SetTextColor

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

	mGotoxy	34, 0									
	mWrite	"Time Delay:  "    
	MOV	EAX, speed								; Displays time delay
	CALL	WriteInt	

	mGotoxy	56, 0									
	mWrite	"Lives:  "    
	MOV	al, lives								; Displays time delay
	CALL	WriteInt

	RET
ScoureInfo ENDP

GenerateFood PROC									; Put food on a random point
	CALL Randomize									; Produce new random seed
													
	; Random X Coordinate
	CALL Random32									; Generates a random value between 0 and FFFFFFFFh
	XOR	EDX, EDX									; Quickly clears EDX (faster than moving a zero to edx)
	MOV	ECX, maxX - 3								
	DIV	ECX											; DIV EAX by ECX, then store EAX=Quotient, EDX=Remainder
	INC	DL	
	INC	DL											; Fixing a bug (printing the food in the wall)
	MOV	foodPoint.x, DL								; Get the x coordinates of the food and store it infoodPoint.x

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

        CMP     AH, FoodPoint.x							; If the snake X is equal to food X
        JNE     X00									    ; IF not, Exit PROC
        CMP     AL, FoodPoint.y							; If the snake Y is equal to food Y
        JNE     X00

        CALL    GenerateFood							; IF the snake is "colliding" with Food
        INC     headIndex								; Move head index for new growth
        ADD     score, 1								; Score is incremented after eating by +1
   
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
      
	MOV	ECX, 0  
	MOV	CL, tailIndex								; Tail index in the snakebody array

    	mGotoxy SnakeBody[2 * ECX].x, SnakeBody[2 * ECX].y  				; Go to the coordinates of the old tail
    	mWrite	" "									; Delete the old tail

	INC	tailIndex								; Update the tail index (moving one step)
	INC	headIndex								; Udpate the head index (moving one step)

	CMP	headIndex, maxSize							; If the head reaches the end of the array
	JNE	X01
	MOV	headIndex, 0								; make the head index start again from the begining

   	X00:
	CMP	tailIndex, maxSize							; If the tail reaches the end of the array
	JNE	X01
	MOV	tailIndex, 0								; make the tail index start again from the begining

   	X01:
	RET
	
MoveSnake ENDP

;this proc check that the snake hits the border to enter it on "game over"

;This figure shows the boundaries that if the snake hits it, it gets game over
;------(1 1 1 1)-------
;|					  |
;|                    | 
;(0 0 0)           (maxX)
;|                    |  
;|                    |
;|                    |
;|-----(maxY)---------|
;1---> top 
;0--->left
;(maxX)---> Right
;(maxY)---> Bottom

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
DEC lives				;when the snake hit the wall decrease one live
MOV cl, lives
CMP cl,0				
JNE X02				    ;IF CL > 0 , reset the snake position and continue playing 
MOV EAX, 1              ;when EAX is equal 1 , then go to game over
RET


X02:
CALL ClrScr
call printwalls
call ScoureInfo
call generateFood
call grow
call ResetData
jmp X01

X01:
MOV EAX, 0 ; 0 means that the game is not over .
RET

IsCollision ENDP






DrawGameOver PROC									; Draw game over screen with showing score
	CALL	Clrscr
	CALL	PrintWalls

	MOV EAX, Red+ (black * 16)                         ;make  ASCII Title "Game Over"  Red
        CALL SetTextColor	
	
			mGotoxy 7, 3									; Draw ASCII Title "Game Over"
			mWrite	"  ________                        ________                     "	
			mGotoxy 7, 4									
			mWrite	" /  _____/_____    _____   ____   \_____  \___  __ ___________ "	
			mGotoxy 7, 5									
			mWrite	"/   \  ___\__  \  /     \_/ __ \   /   |   \  \/ // __ \_  __ \"	
			mGotoxy 7, 6									
			mWrite	"\    \_\  \/ __ \|  Y Y  \  ___/  /    |    \   /\  ___/|  | \/"	
			mGotoxy 7, 7									
			mWrite	" \______  (____  /__|_|  /\___  > \_______  /\_/  \___  >__|   "	
			mGotoxy 7, 8									
			mWrite	"        \/     \/      \/     \/          \/          \/       "	

	mGotoxy 30, 13  
	mWrite	"Final Score:"
	mGotoxy 42, 13

	MOV	EAX, score								; Reset screen and display score
	CALL	WriteInt
	INVOKE	Sleep, 5000
															

	mGotoxy 30, 16                          ; waiting msg "press any key to containue..."
CALL  WaitMsg
mGotoxy 0,0
MOV EAX, white + (black * 16)          ; reset color to white

;reset gameplay vars
MOV currentX,40
MOV currentY,10
MOV headindex,3
MOV tailIndex,0
MOV RIGHT,1
MOV LEFT,0
MOV UP,0
MOV DOWN,0
MOV lives,3


CALL	main						; Load Title Screen again	


		
	RET													
DrawGameOver ENDP

ResetData PROC
	MOV currentX, 40
	MOV currentY, 10
	MOV headIndex, 3
	MOV tailIndex, 0
	INVOKE SetDirection, 1,0,0,0
	RET
ResetData ENDP 


END main