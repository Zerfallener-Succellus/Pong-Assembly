STACK SEGMENT PARA STACK
          DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'

    BALL_X DW 0Ah    ;x position (column) of the bal
    BALL_Y DW 0Ah    ;y position (line) of the ball

DATA ENDS

CODE SEGMENT PARA 'CODE'
        
MAIN PROC FAR
         ASSUME CS:CODE,DS:DATA,SS:STACK    ;assume as code,data and stack segments the respective resgisters
         PUSH   DS                          ;push to the stack the DS segments
         SUB    AX,AX                       ;clean the AX register
         PUSH   AX                          ;push AX to the stack
         MOV    AX,DATA                     ;save on the AX register the content of the DATA segment
         MOV    DS,AX                       ;save on the daa segment the contents of AX
         POP    AX                          ;release the top item from the stack to the AX segment
         POP    AX                          ;release the top item from the stack to the AX segment

         MOV    AH,00h                      ;set the configuration to video mode
         MOV    AL,13h                      ;chose the video mode
         INT    10h                         ;execute the configuration
         
         MOV    AH,0Bh                      ;set the configuration
         MOV    BH,00h                      ; to the background color
         MOV    BL,00h                      ;chosing black as background color
         INT    10h                         ; execute the configuration

         MOV    AH,0ch                      ;set the configurantion to writing a pixel
         MOV    AL,0Fh                      ;set color of the pixel to white
         MOV    BH,00h                      ;set the page number to 0
         MOV    CX,BALL_X                   ;set the column (X)
         MOV    DX,BALL_Y                   ;set the line (Y)
         INT    10h                         ;execute the configuration

         RET

MAIN ENDP

CODE ENDS
END