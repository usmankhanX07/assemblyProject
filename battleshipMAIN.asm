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

noOfFailures dword 0
noOfCorrectHits dword 0

.code
main PROC
    mov edx, offset welcomeMessage
    call writeString

    mov eax, 0
    L1:
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
        imul eax, TYPE DWORD

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
    mov edx, OFFSET hitMsg
    call WriteString
    inc noOfCorrectHits
    mov eax, noOfCorrectHits
    cmp eax, 3
    jae successfullyDone
    call crlf
    jmp L1

miss:
    inc noOfFailures
    mov eax, noOfFailures
    cmp eax, 5
    jae lost
    mov edx, OFFSET missMsg
    call WriteString
    call crlf
    jmp L1


lost:

    mov edx, OFFSET losing
    call WriteString
    call Crlf
    exit

successfullyDone:
    mov edx, OFFSET winning
    call WriteString
    exit

main ENDP
END main


