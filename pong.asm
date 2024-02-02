STACK SEGMENT PARA STACK
          DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'

    BALL_X DW 0Ah    ;x position (column) of the bal
    BALL_Y DW 0Ah    ;y position (line) of the ball

DATA ENDS

CODE SEGMENT PARA 'CODE'
        
MAIN PROC FAR

         MOV AH,00h    ;set the configuration to video mode
         MOV AL,13h    ;chose the video mode
         INT 10h       ;execute the configuration
         
         MOV AH,0Bh    ;set the configuration
         MOV BH,00h    ; to the background color
         MOV BL,00h    ;chosing black as background color
         INT 10h       ; execute the configuration

         MOV AH,0ch    ;set the configurantion to writing a pixel
         MOV AL,0Fh    ;set color of the pixel to white
         MOV BH,00h    ;set the page number to 0
         MOV CX,0Ah    ;set the column (X)
         MOV DX,0Ah    ;set the line (Y)
         INT 10h       ;execute the configuration
         RET
MAIN ENDP

CODE ENDS
END