TITLE Snake.asm
INCLUDE Irvine32.inc
.DATA
.CODE

;-----Start [Main proc]-----
main PROC

main ENDP
;-----End [Main proc]-----

;-----Start [initSnake proc]-----
initSnake PROC USES EBX EDX

; This procedure initializes the snake to the default position
; in the center of the screen

    MOV DH, 13      ; Set row number to 13
    MOV DL, 47      ; Set column number to 47
    MOV BX, 1       ; First segment of snake
    CALL saveIndex  ; Write to framebuffer

    MOV DH, 14      ; Set row number to 14
    MOV DL, 47      ; Set column number to 47
    MOV BX, 2       ; Second segment of snake
    CALL saveIndex  ; Write to framebuffer

    MOV DH, 15      ; Set row number to 15
    MOV DL, 47      ; Set column number to 47
    MOV BX, 3       ; Third segment of snake
    CALL saveIndex  ; Write to framebuffer

    MOV DH, 16      ; Set row number to 16
    MOV DL, 47      ; Set column number to 47
    MOV BX, 4       ; Fourth segment of snake
    CALL saveIndex  ; Write to framebuffer

    RET

initSnake ENDP
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