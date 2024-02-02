STACK SEGMENT PARA STACK
          DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'

    WINDOW_W      DW 140h    ;width of the window (320 pixels)
    WINDOW_H      DW 0C8h    ;height of the window (200 pixels)
    WINDOW_BOUNDS DW 6       ;variable used to check colisions early

    TIME_AUX      DB 0       ;variable used when checking if time has changed

    BALL_X        DW 0Ah     ;x position (column) of the bal
    BALL_Y        DW 0Ah     ;y position (line) of the ball
    BALL_SIZE     DW 04h     ;size of the ball (how many pixels does the ball have in with and heigth)
    BALL_VEL_X    DW 05h     ;X (horizontal) velocity of the ball
    BALL_VEL_Y    DW 02h     ;Y (verticaltal) velocity of the ball

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
    
    CHECK_TIME:          
                         MOV    AH,2Ch                      ;get the system time
                         INT    21h                         ;CH = hour CL = minute DH = second DL =1/100 seconds

                         CMP    DL,TIME_AUX                 ;is the current time equal top the previous one(TIME_AUX)?
                         JE     CHECK_TIME                  ;if it is the smae, check again
    ;if isn't, then drawn, move,etc.

                         MOV    TIME_AUX,DL                 ;update the time

                         CALL   CLR_SCR                     ;paint the screen black again after update
                         CALL   MOVE_BALL                   ;calls the procedimento to move the ball
                         CALL   DRAW_BALL                   ;calls the process of drawing the

                         JMP    CHECK_TIME                  ;after everthing checks time again

                         RET

MAIN ENDP


MOVE_BALL PROC NEAR

                         MOV    AX,BALL_VEL_X               ;--
                         ADD    BALL_X,AX                   ;move the ball horizontaly


                         MOV    AX,WINDOW_BOUNDS
                         CMP    BALL_X,AX                   ;--
                         JL     NEG_VEL_X                   ;BALL_X < 0 + WINDOW_BOUNDS (Y -> collided)
                         

                         MOV    AX,WINDOW_W                 ;--
                         SUB    AX,BALL_SIZE                ;sub the ball size to not pass the wall
                         SUB    AX,WINDOW_BOUNDS
                         CMP    BALL_X,AX                   ;BALL_X > WINDOW_W - BALL_SIZE - WINDOW_BOUNDS (Y -> colided)
                         JG     NEG_VEL_X                   ;--
                         MOV    AX,BALL_VEL_Y               ;--
                         ADD    BALL_Y,AX                   ;move the ball verticaly

                         MOV    AX,WINDOW_BOUNDS
                         CMP    BALL_Y,AX                   ;--
                         JL     NEG_VEL_Y                   ;BALL_Y < 0 + WINDOW_BOUNDS (Y -> collided)
                         
                         MOV    AX,WINDOW_H                 ;--
                         SUB    AX,BALL_SIZE                ;sub the ball size to not pass the wall
                         SUB    AX,WINDOW_BOUNDS
                         CMP    BALL_Y,AX                   ;BALL_Y > WINDOW_H - BALL_SIZE - WINDOW_BOUNDS (Y -> colided)
                         JG     NEG_VEL_Y                   ;--

                         RET
    NEG_VEL_X:           
                         NEG    BALL_VEL_X                  ;BALL_VEL_X = - BALL_VEL_X
                         RET

    NEG_VEL_Y:           
                         NEG    BALL_VEL_Y                  ;BALL_VEL_Y = - BALL_VEL_Y
                         RET

MOVE_BALL ENDP


DRAW_BALL PROC NEAR


                         MOV    CX,BALL_X                   ;set the initial column (X)
                         MOV    DX,BALL_Y                   ;set the initial line (Y)

    DRAW_BALL_HORIZONTAL:
                         MOV    AH,0ch                      ;set the configurantion to writing a pixel
                         MOV    AL,0Fh                      ;set color of the pixel to white
                         MOV    BH,00h                      ;set the page number to 0
                         INT    10h                         ;execute the configuration

                         INC    CX                          ;CX = CX+1
                         MOV    AX,CX                       ;CX - BALL_X > BALL_SIZE (Y -> we go to the next line, N -> we go to the next collumn)
                         SUB    AX,BALL_X                   ;--
                         CMP    AX,BALL_SIZE                ;--
                         JNG    DRAW_BALL_HORIZONTAL        ;--

                         MOV    CX,BALL_X                   ;the CX register goes back to the initial column
                         INC    DX                          ;we advance one line
                         
                         MOV    AX,DX                       ;DX - BALL_SIZE (Y -> we exit this procedure, N -> we continue to the next line)
                         SUB    AX,BALL_Y                   ;--
                         CMP    AX,BALL_SIZE                ;--
                         JNG    DRAW_BALL_HORIZONTAL        ;--

                         RET
DRAW_BALL ENDP

CLR_SCR PROC NEAR
                         MOV    AX, 0A000h                  ; Set the video memory segment to 0A000h
                         MOV    ES, AX
                         MOV    DI, 0                       ; ES:0 is the start of the framebuffer
                         MOV    CX, 7D00h                   ; Store the total number of bytes required for mode 0Dh (320x200 at 16 colors)
                         CLD
                         XOR    AX, AX
                         REP    STOSW                       ; zero CX * 2 bytes at ES:DI

                         RET
CLR_SCR ENDP

CODE ENDS
END