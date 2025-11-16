INCLUDE Irvine32.inc

.data
; 1 = ship, 0 = empty
board DWORD   0,0,0,
              1,1,1,
              0,0,0

board1 DWORD  0,1,0,
              0,1,0,
              0,1,0
rows = 3
cols = 3

welcomeMessage byte "Welcome to the battleship game",0Ah,0Dh,
                    "This is an ambitious game made by:",0Ah,0Dh,
                    "Usman Khan 24K-3032, Aleem Abbas 24K-3070 & Abdul Hadi 24K-3018",0Ah,0Dh,0

promptRow byte "Enter row (0-2): ",0
promptCol byte "Enter col (0-2): ",0
hitMsg    byte "Hit!",0
missMsg   byte "Miss!",0
winning   byte "You have found all ships and won",0
losing    byte "You lost, better luck next time",0
matchEnd  byte "The match is over",0
duplicateInput byte "You have already tried this block",0

noOfFailures dword 0
noOfCorrectHits dword 0
noOfTries dword 0
locationsAlreadyHit dword 9 dup(?)

.code
main PROC
    mov edx, offset welcomeMessage
    call writeString

    mov eax, 0
    L1:
        call normalBG
        ; --- Ask for row ---
        mov edx, OFFSET promptRow
        call WriteString
        call ReadInt
        mov ebx, eax      ; row in EBX

        ; --- Ask for col ---
        mov edx, OFFSET promptCol
        call WriteString
        call ReadInt
        mov ecx, eax      ; col in ECX



        ; --- Compute index = (row * cols + col) * 4 ---
        mov eax, ebx
        imul eax, cols
        add eax, ecx
        imul eax, type dword

        ; --- Check if value already hit ---
        call addOffset
        call manageOffset       ; this function causes edx to be 1 when duplicate inputs are found
        inc noOfTries
        cmp edx, 1
        je l1

        ; --- Access board[row][col] ---
        mov esi, OFFSET board
        add esi, eax
        mov eax, [esi]

        ; --- Check value ---

        cmp eax, 1
        je hit
        cmp eax, 0
        je miss


hit:
    call greenBG
    mov edx, OFFSET hitMsg
    call WriteString
    call crlf
    inc noOfCorrectHits
    mov eax, noOfCorrectHits
    cmp eax, 3
    jae won
    jmp L1

miss:
    call redBG
    mov edx, OFFSET missMsg
    call WriteString
    call crlf
    inc noOfFailures
    mov eax, noOfFailures
    cmp eax, 5
    jae lost
    jmp L1


lost:
    call clrscr
    mov ebx, offset matchEnd
    mov edx, OFFSET losing
    call msgBox
    exit

won:
    call clrscr
    mov ebx, offset matchEnd
    mov edx, OFFSET winning
    call msgBox
    exit

main ENDP

manageOffset proc
    ; eax contains the current offset
    mov ecx, noOfTries
    mov esi, offset locationsAlreadyHit
    mov edx, 0
    cmp ecx, 0
    je endFunc

    checkLoop:
        cmp [esi], eax
        je duplicateFound
        add esi, 4
    loop checkLoop
    jmp endFunc

    duplicateFound:
    mov edx, offset duplicateInput
    call WriteString
    call crlf
    mov edx, 1
    
    endFunc:
    ret
manageOffset endp

addOffset proc
    mov ebx, noOfTries
    mov esi, offset locationsAlreadyHit
    imul ebx, 4
    add esi, ebx
    mov dword ptr[esi], eax

    ret
addOffset endp

; Coloring section
redBG proc
    mov eax, yellow + red*16
    call setTextColor 
    ret
redBG endp

normalBG proc
    mov eax, white + black*16
    call setTextColor
    ret
normalBG endp

greenBG proc
    mov eax, white + green*16
    call setTextColor
    ret
greenBG endp

END main


