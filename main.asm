TITLE OurAmazingSnake.asm
                             ;snake game written in assembly language using Irvine library
INCLUDE Irvine32.inc 
.DATA

buf WORD 1920 DUP(0) ; frame of the buffer (24 x 80)

str BYTE 12d ; snake tail row number initialization
stc BYTE 42d ; snake tail column number initialization
shr BYTE 16d ; snake head row number initialization
shc BYTE 42d ; snake head column number initialization
fr BYTE 0d ; food row initialization
fc BYTE 0d ; food column initialization
.CODE

;-----Start [Main proc]-----
main PROC

main ENDP
;-----End [Main proc]-----

;-----Start [initSnake proc]-----

;-----End [initSnake proc]-----


;-----Start [clearMemory proc]-----

;-----End [clearMemory proc]-----

;-----Start [startGame proc]-----

;-----End [startGame proc]-----

;-----Start [moveSnake proc]-----

;-----End [moveSnake proc]-----

;-----Start [createFood proc]-----

;-----End [createFood proc]-----

;-----Start [accessIndex proc]-----

;-----End [accessIndex proc]-----

;-----Start [saveIndex proc]-----

;-----End [saveIndex proc]-----

;-----Start [paint proc]-----

;-----End [paint proc]-----

;-----Start [generateLevel proc]-----

;-----End [generateLevel proc]-----

END main