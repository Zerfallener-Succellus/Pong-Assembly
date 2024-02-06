STACK SEGMENT PARA STACK
          DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'

    WINDOW_W        DW 140h    ;width of the window (320 pixels)
    WINDOW_H        DW 0C8h    ;height of the window (200 pixels)
    WINDOW_BOUNDS   DW 6       ;variable used to check colisions early

    TIME_AUX        DB 0       ;variable used when checking if time has changed

    BALL_ORIGINAL_X DW 0A0h
    BALL_ORIGINAL_Y DW 64h
    BALL_X          DW 0A0h    ;x position (column) of the bal
    BALL_Y          DW 64h     ;y position (line) of the ball
    BALL_SIZE       DW 04h     ;size of the ball (how many pixels does the ball have in with and heigth)
    BALL_VEL_X      DW 05h     ;X (horizontal) velocity of the ball
    BALL_VEL_Y      DW 02h     ;Y (verticaltal) velocity of the ball

    PADDLE_L_X      DW 0Ah
    PADDLE_L_Y      DW 0Ah

    PADDLE_R_X      DW 131h
    PADDLE_R_Y      DW 0Ah

    PADDLE_WIDTH    DW 05h
    PADDLE_HEIGHT   DW 1Fh
    PADDLE_VEL      DW 05h


DATA ENDS

CODE SEGMENT PARA 'CODE'
        
MAIN PROC FAR
                                    ASSUME CS:CODE,DS:DATA,SS:STACK           ;assume as code,data and stack segments the respective resgisters
                                    PUSH   DS                                 ;push to the stack the DS segments
                                    SUB    AX,AX                              ;clean the AX register
                                    PUSH   AX                                 ;push AX to the stack
                                    MOV    AX,DATA                            ;save on the AX register the content of the DATA segment
                                    MOV    DS,AX                              ;save on the daa segment the contents of AX
                                    POP    AX                                 ;release the top item from the stack to the AX segment
                                    POP    AX                                 ;release the top item from the stack to the AX segment

                                    MOV    AH,00h                             ;set the configuration to video mode
                                    MOV    AL,13h                             ;chose the video mode
                                    INT    10h                                ;execute the configuration
         
                                    MOV    AH,0Bh                             ;set the configuration
                                    MOV    BH,00h                             ; to the background color
                                    MOV    BL,00h                             ;chosing black as background color
                                    INT    10h                                ; execute the configuration
    
    CHECK_TIME:                     
                                    MOV    AH,2Ch                             ;get the system time
                                    INT    21h                                ;CH = hour CL = minute DH = second DL =1/100 seconds

                                    CMP    DL,TIME_AUX                        ;is the current time equal top the previous one(TIME_AUX)?
                                    JE     CHECK_TIME                         ;if it is the smae, check again
    ;if isn't, then drawn, move,etc.

                                    MOV    TIME_AUX,DL                        ;update the time

                                    CALL   CLR_SCR                            ;paint the screen black again after update

                                    CALL   MOVE_BALL                          ;calls the procedimento to move the ball
                                    CALL   DRAW_BALL                          ;calls the process of drawing the ball

                                    CALL   MOVE_PADDLES
                                    CALL   DRAW_PADDLES

                                    JMP    CHECK_TIME                         ;after everthing checks time again

                                    RET

MAIN ENDP


MOVE_BALL PROC NEAR

                                    MOV    AX,BALL_VEL_X                      ;--
                                    ADD    BALL_X,AX                          ;move the ball horizontaly


                                    MOV    AX,WINDOW_BOUNDS
                                    CMP    BALL_X,AX                          ;--
                                    JL     RESET_POSITION                     ;BALL_X < 0 + WINDOW_BOUNDS (Y -> collided)
                         

                                    MOV    AX,WINDOW_W                        ;--
                                    SUB    AX,BALL_SIZE                       ;sub the ball size to not pass the wall
                                    SUB    AX,WINDOW_BOUNDS
                                    CMP    BALL_X,AX                          ;BALL_X > WINDOW_W - BALL_SIZE - WINDOW_BOUNDS (Y -> colided)
                                    JG     RESET_POSITION                     ;--
                                    MOV    AX,BALL_VEL_Y                      ;--
                                    ADD    BALL_Y,AX                          ;move the ball verticaly

                                    MOV    AX,WINDOW_BOUNDS
                                    CMP    BALL_Y,AX                          ;--
                                    JL     NEG_VEL_Y                          ;BALL_Y < 0 + WINDOW_BOUNDS (Y -> collided)
                         
                                    MOV    AX,WINDOW_H                        ;--
                                    SUB    AX,BALL_SIZE                       ;sub the ball size to not pass the wall
                                    SUB    AX,WINDOW_BOUNDS
                                    CMP    BALL_Y,AX                          ;BALL_Y > WINDOW_H - BALL_SIZE - WINDOW_BOUNDS (Y -> colided)
                                    JG     NEG_VEL_Y                          ;--

                                    RET
    RESET_POSITION:                 
                                    CALL   RESET_BALL_POSITION                ;call the process reset
                                    RET

    NEG_VEL_Y:                      
                                    NEG    BALL_VEL_Y                         ;BALL_VEL_Y = - BALL_VEL_Y
                                    RET

MOVE_BALL ENDP

MOVE_PADDLES PROC NEAR

    ;left paddle movement

    ;check if any key is being pressed (if not check the other paddle)
                                    MOV    AH,01h
                                    INT    16h
                                    JZ     CHECK_RIGHT_PADDLE_MOVEMENT        ;ZF =1, JZ -> Jump If Zero

    ;check which key is being pressed (AL = ASCII character)
                                    MOV    AH,00h
                                    INT    16h

    ;if it is 'w' or 'W' move up
                                    CMP    AL,77h                             ;'w'
                                    JE     MOVE_LEFT_PADDLE_UP
                                    CMP    AL,57h                             ;'W'
                                    JE     MOVE_LEFT_PADDLE_UP

    ;is it is 's' or 'S' move down
                                    CMP    AL,73h                             ;'s'
                                    JE     MOVE_LEFT_PADDLE_DOWN
                                    CMP    AL,55h                             ;'S'
                                    JE     MOVE_LEFT_PADDLE_DOWN
                                    JMP    CHECK_RIGHT_PADDLE_MOVEMENT

    MOVE_LEFT_PADDLE_DOWN:          
                                    MOV    AX, PADDLE_VEL
                                    ADD    PADDLE_L_Y,AX
                                 
                                    MOV    AX,WINDOW_H
                                    SUB    AX,WINDOW_BOUNDS
                                    SUB    AX,PADDLE_HEIGHT
                                    CMP    PADDLE_L_Y,AX
                                    JG     FIX_PADDLE_LEFT_BOTTOM_POSITION
                                    JMP    CHECK_RIGHT_PADDLE_MOVEMENT

    FIX_PADDLE_LEFT_BOTTOM_POSITION:
                                    MOV    PADDLE_L_Y,AX
                                    JMP    CHECK_RIGHT_PADDLE_MOVEMENT


    MOVE_LEFT_PADDLE_UP:            
                                    MOV    AX,PADDLE_VEL
                                    SUB    PADDLE_L_Y, AX

                                    MOV    AX,WINDOW_BOUNDS
                                    CMP    PADDLE_L_Y,AX
                                    JL     FIX_PADDLE_LEFT_TOP_POSITION
                                    JMP    CHECK_RIGHT_PADDLE_MOVEMENT

    FIX_PADDLE_LEFT_TOP_POSITION:   
                                    MOV    PADDLE_L_Y,AX
                                    JMP    CHECK_RIGHT_PADDLE_MOVEMENT


    ;right paddle movement
    CHECK_RIGHT_PADDLE_MOVEMENT:    

    ;check if any key is being pressed (if not exite the procedure)

    ;check which key is being pressed

    ;if it is 'o' or 'O' move up

    ;is it is 'l' or 'L' move down


                                    RET
MOVE_PADDLES ENDP

RESET_BALL_POSITION PROC NEAR                                                 ;make the ball come back to the inicial pos

                                    MOV    AX,BALL_ORIGINAL_X
                                    MOV    BALL_X,AX

                                    MOV    AX,BALL_ORIGINAL_Y
                                    MOV    BALL_Y,AX

                                    RET
RESET_BALL_POSITION ENDP

DRAW_BALL PROC NEAR


                                    MOV    CX,BALL_X                          ;set the initial column (X)
                                    MOV    DX,BALL_Y                          ;set the initial line (Y)

    DRAW_BALL_HORIZONTAL:           
                                    MOV    AH,0ch                             ;set the configurantion to writing a pixel
                                    MOV    AL,0Fh                             ;set color of the pixel to white
                                    MOV    BH,00h                             ;set the page number to 0
                                    INT    10h                                ;execute the configuration

                                    INC    CX                                 ;CX = CX+1
                                    MOV    AX,CX                              ;CX - BALL_X > BALL_SIZE (Y -> we go to the next line, N -> we go to the next collumn)
                                    SUB    AX,BALL_X                          ;--
                                    CMP    AX,BALL_SIZE                       ;--
                                    JNG    DRAW_BALL_HORIZONTAL               ;--

                                    MOV    CX,BALL_X                          ;the CX register goes back to the initial column
                                    INC    DX                                 ;we advance one line
                         
                                    MOV    AX,DX                              ;DX - BALL_SIZE > BALL SIZE (Y -> we exit this procedure, N -> we continue to the next line)
                                    SUB    AX,BALL_Y                          ;--
                                    CMP    AX,BALL_SIZE                       ;--
                                    JNG    DRAW_BALL_HORIZONTAL               ;--

                                    RET
DRAW_BALL ENDP

DRAW_PADDLES PROC NEAR
                                    MOV    CX,PADDLE_L_X                      ;set the initial column (X)
                                    MOV    DX,PADDLE_L_Y                      ;set the initial line (Y)

    DRAW_PADDLE_LEFT_HORIZONTAL:    
                                    MOV    AH,0ch                             ;set the configurantion to writing a pixel
                                    MOV    AL,0Fh                             ;set color of the pixel to white
                                    MOV    BH,00h                             ;set the page number to 0
                                    INT    10h                                ;execute the configuration

                                    INC    CX                                 ;CX = CX+1
                                    MOV    AX,CX                              ;CX - PADDLE_LEFT_X > PADDLE_WIDTH (Y -> we go to the next line, N -> we go to the next collumn)
                                    SUB    AX,PADDLE_L_X                      ;--
                                    CMP    AX,PADDLE_WIDTH                    ;--
                                    JNG    DRAW_PADDLE_LEFT_HORIZONTAL        ;--

                                    MOV    CX,PADDLE_L_X                      ;the CX register goes back to the initial column
                                    INC    DX                                 ;we advance one line
                         
                                    MOV    AX,DX                              ;DX - PADDLE_LEFT_Y > PADDLE_HEIGHT (Y -> we exit this procedure, N -> we continue to the next line)
                                    SUB    AX,PADDLE_L_Y                      ;--
                                    CMP    AX,PADDLE_HEIGHT                   ;--
                                    JNG    DRAW_PADDLE_LEFT_HORIZONTAL        ;--



                                    MOV    CX,PADDLE_R_X                      ;set the initial column (X)
                                    MOV    DX,PADDLE_R_Y                      ;set the initial line (Y)

    DRAW_PADDLE_RIGHT_HORIZONTAL:   
                                    MOV    AH,0ch                             ;set the configurantion to writing a pixel
                                    MOV    AL,0Fh                             ;set color of the pixel to white
                                    MOV    BH,00h                             ;set the page number to 0
                                    INT    10h                                ;execute the configuration

                                    INC    CX                                 ;CX = CX+1
                                    MOV    AX,CX                              ;CX - PADDLE_RIGHT_X > PADDLE_WIDTH (Y -> we go to the next line, N -> we go to the next collumn)
                                    SUB    AX,PADDLE_R_X                      ;--
                                    CMP    AX,PADDLE_WIDTH                    ;--
                                    JNG    DRAW_PADDLE_RIGHT_HORIZONTAL       ;--

                                    MOV    CX,PADDLE_R_X                      ;the CX register goes back to the initial column
                                    INC    DX                                 ;we advance one line
                         
                                    MOV    AX,DX                              ;DX - PADDLE_RIGHT_Y > PADDLE_HEIGHT (Y -> we exit this procedure, N -> we continue to the next line)
                                    SUB    AX,PADDLE_R_Y                      ;--
                                    CMP    AX,PADDLE_HEIGHT                   ;--
                                    JNG    DRAW_PADDLE_RIGHT_HORIZONTAL       ;--

                                    RET
DRAW_PADDLES ENDP

CLR_SCR PROC NEAR
                                    MOV    AX, 0A000h                         ; Set the video memory segment to 0A000h
                                    MOV    ES, AX
                                    MOV    DI, 0                              ; ES:0 is the start of the framebuffer
                                    MOV    CX, 7D00h                          ; Store the total number of bytes required for mode 0Dh (320x200 at 16 colors)
                                    CLD
                                    XOR    AX, AX
                                    REP    STOSW                              ; zero CX * 2 bytes at ES:DI

                                    RET
CLR_SCR ENDP

CODE ENDS
END