;**************************************************************************************
;* Lab 3 Main [includes LibV2.2]                                                      *
;**************************************************************************************
;* Summary:                                                                           *
;*   -                                                                                *
;*                                                                                    *
;* Authors:
;     Benjamin Fields
;     Miles Alderman              
;                                                                                     *
;* Cal Poly University                                                                *
;* Spring 2022                                                                        *
;*                                                                                    *
;* Revision History:                                                                  *
;*   -                                                                                *
;*                                                                                    *
;* ToDo:                                                                              *
;*   -                                                                                *
;**************************************************************************************

;/------------------------------------------------------------------------------------\
;| Include all associated files                                                       |
;\------------------------------------------------------------------------------------/
; The following are external files to be included during assembly


;/------------------------------------------------------------------------------------\
;| External Definitions                                                               |
;\------------------------------------------------------------------------------------/
; All labels that are referenced by the linker need an external definition

              XDEF  main

;/------------------------------------------------------------------------------------\
;| External References                                                                |
;\------------------------------------------------------------------------------------/
; All labels from other files must have an external reference

              XREF  ENABLE_MOTOR, DISABLE_MOTOR
              XREF  STARTUP_MOTOR, UPDATE_MOTOR, CURRENT_MOTOR
              XREF  STARTUP_PWM, STARTUP_ATD0, STARTUP_ATD1
              XREF  OUTDACA, OUTDACB
              XREF  STARTUP_ENCODER, READ_ENCODER
              XREF  INITLCD, SETADDR, GETADDR, CURSOR_ON, CURSOR_OFF, DISP_OFF
              XREF  OUTCHAR, OUTCHAR_AT, OUTSTRING, OUTSTRING_AT
              XREF  INITKEY, LKEY_FLG, GETCHAR
              XREF  LCDTEMPLATE, UPDATELCD_L1, UPDATELCD_L2
              XREF  LVREF_BUF, LVACT_BUF, LERR_BUF,LEFF_BUF, LKP_BUF, LKI_BUF
              XREF  Entry, ISR_KEYPAD
            
;/------------------------------------------------------------------------------------\
;| Assembler Equates                                                                  |
;\------------------------------------------------------------------------------------/
; Constant values can be equated here

PORTP         EQU   $0258              ; output port for LEDs 
DDRP          EQU   $025A 
 
G_LED_1       EQU   %00010000          ; green LED output pin for LED pair_1 
R_LED_1       EQU   %00100000          ; red LED output pin for LED pair_1 
LED_MSK_1     EQU   %00110000          ; LED pair_1 
G_LED_2       EQU   %01000000          ; green LED output pin for LED pair_2 
R_LED_2       EQU   %10000000          ; red LED output pin for LED pair_2 
LED_MSK_2     EQU   %11000000          ; LED pair_2 

;/------------------------------------------------------------------------------------\
;| Variables in RAM                                                                   |
;\------------------------------------------------------------------------------------/
; The following variables are located in unpaged ram

DEFAULT_RAM:  SECTION

masterstate:  DS.B     1        ;Mastermind State to go to/is in
keystate:     DS.B     1        ;Keypad State
displaystate: DS.B     1        ;Display State
pat1state:    DS.B     1        ;Pattern_1 State
time1state:   DS.B     1        ;Timing_1 State
pat2state:    DS.B     1        ;Pattern_2 State
time2state:   DS.B     1        ;Timing_2 State
delaystate:   DS.B     1        ;Delay_1ms State
KEY_FLG:      DS.B     1        ;flag mirroring LKEY_FLG to set keypad state
CURSOR_ADD:   DS.B     1
DMESS_DIGIT:  DS.B     1
DMESS_BS:     DS.B     1
DMESS_ENT:    DS.B     1
DMESS_F1:     DS.B     1
DMESS_F2:     DS.B     1
DMESS_EB1:    DS.B     1
DMESS_EB2:    DS.B     1
DMESS_EZ1:    DS.B     1
DMESS_EZ2:    DS.B     1
DMESS_EN1:    DS.B     1
DMESS_EN2:    DS.B     1
FIRSTCH:      DS.B     1
DPTR:         DS.B     1
LASTCH:       DS.B     1
ERRORCOUNT1:  DS.W     1
ERRORCOUNT2:  DS.W     1
                                ;NOTE: Changed from array of 2 bytes to word. Will this cause issues?
COUNT_1:      DS.W     1        ; number of ticks remaining in LED Pair 1 delay
COUNT_2:      DS.W     1        ; number of ticks remaining in LED Pair 2 delay
TICKS_1:      DS.W     1        ; total number of ms delay for LED Pair 1
TICKS_2:      DS.W     1        ; total number of ms delay for LED Pair 1 delay
DONE_1:       DS.B     1        ; If loop 1 is done
DONE_2:       DS.B     1        ; If loop 2 is done
KEY_COUNT     DS.B     1        ; Number of digits in buffer
KEY_POINT     DS.B     2        ; Location of next address in buffer
KEY_BUFFER    DS.B     1        ; Intermediate ascii key holder 
BUFFER        DS.B     5        ; Storage for pressed keys pre-translation
LED_1_ON      DS.B     1        ; to enable turn on/off of LEDs when Fxn pressed
LED_2_ON      DS.B     1        ; to enable turn on/off of LEDs when Fxn pressed

; MASTERMIND KEYS  //  FLGS Used to specify which mastermind state should be entered after decode state
; these are set by the decode state and cleared when key states are exited back to waiting state
FXN_1_FLG     DS.B     1        ; Flag for key pressed was a function 1 button
FXN_2_FLG     DS.B     1        ; Flag for key pressed was a function 2 button
ERR_FLG       DS.B     1        ; Flag for there was an error, go into error state
TEMP          DS.B     1        ; temporary used in ascii->bcd
RESULT        DS.W     1        ; used for result storage of ascii -> bcd conversion
COUNT         DS.B     1        ; used for counting in ascii -> bcd
ECHO          DS.B     1        ; echo character for indexed addressing storage


;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode:       SECTION
main:   
        clr   ECHO
        clr   KEY_FLG
        clr   CURSOR_ADD
        clr   DMESS_DIGIT
        clr   DMESS_BS
        clr   DMESS_ENT
        clr   DMESS_F1
        clr   DMESS_F2
        clr   DMESS_EB1
        clr   DMESS_EB2
        clr   DMESS_EZ1
        clr   DMESS_EZ2
        clr   DMESS_EN1
        clr   DMESS_EN2
        clr   FIRSTCH
        clr   DPTR
        clr   LASTCH
        clr   ERRORCOUNT1
        clr   ERRORCOUNT2
        clr   masterstate
        clr   keystate
        clr   displaystate
        clr   pat1state
        clr   time1state
        clr   pat2state
        clr   time2state
        clr   delaystate
        clr   FXN_1_FLG
        clr   FXN_2_FLG
        clr   ERR_FLG
        clr   KEY_COUNT
        clr   TICKS_1
        clr   TICKS_2
        clr   LED_1_ON                 ; start off until initialized
        clr   LED_2_ON                 ; start off until initialized
        
        jsr   INITLCD                  ; initialize the LCD
        jsr   INITKEY                  ; initialize keypad
      
top:    
        jsr   MASTERMIND
        jsr   KEYPAD_TASK
        jsr   DISPLAY_TASK
        jsr   PATTERN_TASK_1
        jsr   TIMING_TASK_1
        jsr   PATTERN_TASK_2
        jsr   TIMING_TASK_2
        jsr   DELAY_TASK
        bra   top
        
spin:   bra   spin     
        
;-------------TASK_1 MASTERMIND---------------------------------------------------------        

MASTERMIND:

masterloop:        
        ldaa  masterstate
        lbeq   masterstate0             ; init state
        deca
        lbeq   masterstate1             ; waiting for key press state
        deca
        lbeq   masterstate2             ; decode state
        deca
        lbeq   masterstate3             ; digit key state
        deca
        lbeq   masterstate4             ; function key state
        deca
        lbeq   masterstate5             ; backspace key state
        deca
        lbeq   masterstate6             ; enter key state
        deca
        lbeq   masterstate7             ; error state
        
        bra   masterloop       

masterstate0: ; // INIT STATE  ///////////////////////////////////////////////////////////
        movb  #$01, masterstate
        rts
        
masterstate1: ; // WAITING FOR KEY STATE //////////////////////////////////////////////////
        tst   ERR_FLG                    ; no error if flag is 0
        bne   errorstateset              ; go to error routine if there is one
        tst   KEY_FLG
        beq   exitmasterstate1
        movb  #$02, masterstate

exitmasterstate1:        
        rts
        
masterstate2: ; // DECODE STATE   /////////////////////////////////////////////////////////
        ; decode state will only figure out which key it is and then redirected to the appropriate state
        ; error checking and more advanced case handling will be done in respective key states
        
        ldaa  KEY_BUFFER                ; load ascii code for pressed key
       
        cmpa  #$F1                      ; compare key to ascii for F1
        beq   ms_goto_fxn               ; if it is, go to masterstate assignment          
        cmpa  #$F2                      ; compare key to ascii for F2
        beq   ms_goto_fxn               ; if it is, go to masterstate assignment                                

        cmpa  #$08
        beq   ms_goto_bs

        cmpa  #$0A                       ; TODO add check for if a function key is active
        beq   ms_goto_ent

        ldab  #$30                       ; a valid digit will have ascii between $30 and $39
        cba                              ; see if key buffer is more than $30
        bhs   digit_bounds               ;if so go to next check 
                                         ; NOTE documentation is wrong, branches if a > b not b > a
                               
out_of_bounds:        
        jsr   clear_key                ; if none of these keys are accepted, go to ignore routine

        rts

digit_bounds:                            ; already tested that key_buffer > $30
        ldab  #$40                       ; now test if it is less than or equal to $39
        cba
        bhi   out_of_bounds              ; if b is more than $39, we know it is out of bounds
                                         ; if it didn't branch, we have a digit!
        movb  #$03, masterstate          ; go into digit state next pass through MM                                 
        rts
        
ms_goto_fxn:
        movb  #$04, masterstate         ; go into fxn state next pass through MM
        rts        

ms_goto_bs:
        movb  #$05, masterstate         ; go into backspace state next pass through MM
        rts 

ms_goto_ent:
        movb  #$06, masterstate         ; go into enter state next pass through MM
        rts 

ms_goto_digit:
        movb  #$03, masterstate         ; go into digit state next pass through MM
        rts 

ignore:
        clr   KEY_BUFFER                ; remove erroneous key from buffer
        clr   KEY_FLG                   ; no longer have a key we care about
        rts

errorstateset:                          ; TODO: will the specific error determination all be in error state? 
        movb  #$07, masterstate
        rts


masterstate3: ;//  DIGIT KEY STATE  ///////////////////////////////////////////////////////////
        ldaa   #$01                     ; make sure one of the flags is active before storing
        cmpa   FXN_1_FLG                 
        beq    process
        cmpa   FXN_2_FLG
        beq    process              
        bra    dig_ignore               ; ignore digit if fxn button not active
process:
        jsr    buffer_store
                         ; fall through when done
dig_ignore:        
        jsr   clear_key        
        rts
        
        
masterstate4: ;//  FUNCTION KEY STATE  ////////////////////////////////////////////////////////
        ldaa   #$01                     ; ignore the key press if a function is already active
        cmpa   FXN_1_FLG                 
        beq    fxn_exit
        cmpa   FXN_2_FLG
        beq    fxn_exit               ; must check that both flags are inactive before proceeding
        
        ldab   KEY_BUFFER
        cmpb   #$F1
        beq    F1_set                   ; if the pressed key was F1, then go to the F1 routine
        
        cmpb   #$F2
        beq    F2_set                   ; if the pressed key was F2, then go to the F2 routine
        
F1_set:
        clr    LED_1_ON                 ; turn off LED while setting new value
        movb   #$01, FXN_1_FLG          ; set the function 1 flag
        movb   #$01, DMESS_F1          ; set the display function 1 flag
        bra    fxn_exit               ; back for cleanup

F2_set:
        clr    LED_2_ON                 ; turn off LED while setting new value
        movb   #$01, FXN_2_FLG          ; set the function 2 flag
        movb   #$01, DMESS_F2          ; set the display function 2 flag
        bra    fxn_exit               ; back for cleanup
        
fxn_exit:
        jsr    clear_key
        rts

masterstate5: ;//  BACKSPACE KEY STATE  ///////////////////////////////////////////////////////
        tst    KEY_COUNT                ; check that key count isn't at 0
        beq    bs_exit                  ; if there are no digits to backspace, ignore key press      
              ; if there's somethign to bs:
        dec    KEY_COUNT                ; decrement key_count
        movb   #$01, DMESS_BS           ; set the display backspace flag     
        
        bra    bs_exit

bs_exit:
        jsr    clear_key
        rts



masterstate6: ;//  ENTER KEY STATE  ///////////////////////////////////////////////////////////
        tst    KEY_COUNT
        lbeq    null_char_err             ; check for zero key error
        
        jsr    asc_decode                ; translate ascii to BCD
        staa   ERR_FLG                   ; a is error code from ascii -> bcd, 0 if no error
        tsta                            ; result in x and error code in a
        bne    decode_error             ; if there was an error in ascii_decode, go to error routine
        
        ldab   #$01                     
        cmpb   FXN_1_FLG                ; test if enter is on fxn 1 
        beq    fxn1_enter               ; go to ticks1 setter
        cmpb   FXN_2_FLG                ; test if enter is on fxn 2
        beq    fxn2_enter               ; go to ticks2 setter
        
        jsr    clear_key                ; a function wasn't active so should ignore keypress
        rts
        
fxn1_enter:
        stx    TICKS_1                  ; store x in TICKS_1
        movb  #$01, LED_1_ON            ; ensure LEDs are on in case turned off by FXN press
        bra    enter                    ; exit routine

fxn2_enter:        
        stx    TICKS_2                  ; store x in TICKS_2
        movb  #$01, LED_2_ON            ; ensure LEDs are on in case turned off by FXN press
        bra    enter                    ; exit routine
 
        
enter:                                  ; only occurs if completely valid
        movb  #$01, DMESS_ENT           ; set the display enter flag
        clr   KEY_COUNT                 ; reset key_count to 0
        clr   FXN_1_FLG
        clr   FXN_2_FLG
                                        ; now that we are exiting...
        jsr   clear_key                 ; we are done with key
        
        rts

decode_error:
        
        ldab  #$01
        cmpb  ERR_FLG
        beq   EB_error_designate
        ldab  #$02
        cmpb  ERR_FLG
        beq   EZ_error_designate
decode_error_exit:        
        jsr   clear_key
        movb  #$07, masterstate         ; go to error decode state
        
        rts

EB_error_designate:
        ldab   #$01                     
        cmpb   FXN_1_FLG                ; test if enter is on fxn 1 
        beq    EB1_error               ; go to EN1 error
        cmpb   FXN_2_FLG                ; test if enter is on fxn 2
        beq    EB2_error               ; go to EN2 error
        bra    decode_error_exit
        
EB1_error:
        movb   #$01, DMESS_EB1
        bra    decode_error_exit

EB2_error:
        movb   #$01, DMESS_EB2
        bra    decode_error_exit

EZ_error_designate        
        ldab   #$01                     
        cmpb   FXN_1_FLG                ; test if enter is on fxn 1 
        beq    EZ1_error               ; go to EN1 error
        cmpb   FXN_2_FLG                ; test if enter is on fxn 2
        beq    EZ2_error               ; go to EN2 error
        bra    decode_error_exit
        
EZ1_error:
        movb   #$01, DMESS_EZ1
        bra    decode_error_exit

EZ2_error:
        movb   #$01, DMESS_EZ2
        bra    decode_error_exit
        
null_char_err:
        ldab   #$01                     
        cmpb   FXN_1_FLG                ; test if enter is on fxn 1 
        beq    EN1_error               ; go to EN1 error
        cmpb   FXN_2_FLG                ; test if enter is on fxn 2
        beq    EN2_error               ; go to EN2 error
        
null_err_exit:        
        jsr   clear_key
        movb  #$07, masterstate         ; go to error decode state
        
        rts
        
EN1_error:
        movb  #$01, DMESS_EN1
        bra   null_err_exit
        

EN2_error:
        movb  #$01, DMESS_EN2
        bra   null_err_exit
        
masterstate7: ;//  ERROR KEY  /////////////////////////////////////////////////////////////////
        ;too big, zero, null x2 for each fxn

      ; test if it should stay in error state and not allow additional key presses
        ;load errocount1 into x
        ;load errorcount2 into y
        ;subtract them
        ; if 0, they're equal (error decrementing finished) and we want to exit error state
              
        ldx   ERRORCOUNT1
        subx  ERRORCOUNT2
        bne   errorstate_exit
        movb  #$01, masterstate
        clr   ERR_FLG
        jsr   clear_key
        clr   FXN_1_FLG
        clr   FXN_2_FLG
        clr   KEY_COUNT
        
        
errorstate_exit:                            
        rts

;-------------TASK_2 KEYPAD---------------------------------------------------------

KEYPAD_TASK:
        
keyloop:
        ldaa  keystate                 ; get current t1state and branch accordingly 
        beq   keystate0 
        deca 
        beq   keystate1 
        deca 
        beq   keystate2 
        
        bra   keyloop
        

keystate0:                             ;init keypad state
        movb  #$01, keystate           ;go to keystate 1 on next passthrough
        rts

keystate1:
        tst   LKEY_FLG                ;see if key was pressed
        beq   exitkeystate1            ;if no key pressed, rts
        movb  #$01,   KEY_FLG          ;set keyflag if key pressed
        jsr   GETCHAR                  ;get character
        stab   KEY_BUFFER                ;store character in key buffer
        movb  #$02, keystate           ;go to state 2 on next passthrough
        
exitkeystate1:
        rts
        
keystate2:
        tst   KEY_FLG                 
        bne   exitkeystate2            ;if key flag cleared by mastermind
        movb  #$01, keystate           ;go back to state 1

exitkeystate2:
        rts

;-------------TASK_3 DISPLAY---------------------------------------------------------
 
DISPLAY_TASK:
        ldaa   displaystate                   ;Display Task state cycling
        lbeq   displaystateinit0
        deca
        lbeq   displaystateinit1
        deca
        lbeq   displaystateinit2
        deca
        lbeq   displaystatehub
        deca
        lbeq   displaystateECHO
        deca
        lbeq   displaystateBS
        deca
        lbeq   displaystateENT
        deca
        lbeq   displaystateF1
        deca
        lbeq   displaystateF2
        deca
        lbeq   displaystateEB1
        deca 
        lbeq   displaystateEB2
        deca
        lbeq   displaystateEZ1
        deca
        lbeq   displaystateEZ2
        deca
        lbeq   displaystateEN1
        deca
        lbeq   displaystateEN2
        deca
        lbeq   errordelay1
        deca
        lbeq   errordelay2
        deca
        lbeq   displaystatereset1
        deca
        lbeq   displaystatereset2
        rts
        
displaystateinit0:
        movb  #$01, FIRSTCH
        movb  #$01, displaystate
        movw  #$0BB8, ERRORCOUNT1
        movw  #$0BB8, ERRORCOUNT2
        rts        


displaystateinit1:
        jsr   startscreen1                     ;after initialization
        tst   FIRSTCH
        beq   displaystateinitexit
        movb  #$02, displaystate
        movb  #$00, LASTCH
        rts

displaystateinit2:
        jsr   startscreen2
        tst   FIRSTCH
        beq   displaystateinitexit
        movb  #$03, displaystate
        movb  #$00, LASTCH
        rts
        
displaystateinitexit:
        rts
        
displaystatehub:
        
        tst   DMESS_DIGIT
        lbne   displaysetECHO
        tst   DMESS_BS
        lbne   displaysetBS
        tst   DMESS_ENT
        lbne   displaysetENT
        tst   DMESS_F1
        lbne   displaysetF1
        tst   DMESS_F2
        lbne   displaysetF2
        tst   DMESS_EB1
        lbne   displaysetEB1
        tst   DMESS_EB2
        lbne   displaysetEB2
        tst   DMESS_EZ1
        lbne   displaysetEZ1
        tst   DMESS_EZ2
        lbne   displaysetEZ2
        tst   DMESS_EN1
        lbne   displaysetEN1
        tst   DMESS_EN2
        lbne   displaysetEN2   
        rts
        
        
displaysetECHO:
        movb  #$04, displaystate
        rts

displaysetBS:
        movb  #$05, displaystate
        rts   

displaysetENT:
        movb  #$06, displaystate
        rts
        
displaysetF1:
        movb  #$07, displaystate
        rts
        
displaysetF2:
        movb  #$08, displaystate
        rts

displaysetEB1:
        movb  #$09, displaystate
        decw  ERRORCOUNT1
        rts   

displaysetEB2:
        movb  #$0A, displaystate
        decw  ERRORCOUNT2
        rts
        
displaysetEZ1:
        movb  #$0B, displaystate
        decw  ERRORCOUNT1
        rts

displaysetEZ2:
        movb  #$0C, displaystate
        decw  ERRORCOUNT2
        rts   

displaysetEN1:
        movb  #$0D, displaystate
        decw  ERRORCOUNT1
        rts
        
displaysetEN2:
        movb  #$0E, displaystate
        decw  ERRORCOUNT2
        rts
        
errordelay1:                                   ;error line 1 delay loop
        tstw  ERRORCOUNT1                 ;
        beq   errorexit1                       ;if error counter is 0, go to line 1 reset routine
        decw  ERRORCOUNT1                      ;if not, decrement error count
        rts
        
errorexit1:                                    ;error line 1 reset routine
        movw  #$0BB8, ERRORCOUNT1              ;reload error count timer
        movb  #$11, displaystate               ;change display state to line 1 screen reprint
        rts  
        
errordelay2:                                   ;error line 2 delay loop
        tstw  ERRORCOUNT2                 ;
        beq   errorexit2                       ;if error counter is 0, go to line 2 reset routine
        decw  ERRORCOUNT2                      ;if not, decrement error count
        rts
        
errorexit2:                                    ;error line 2 reset routine
        movw  #$0BB8, ERRORCOUNT2              ;reload error count timer
        movb  #$12, displaystate               ;change display state to line 2 screen reprint
        rts    
        
displaystatereset1:                            ;line 1 reprint routine
        jsr   startscreen1                     ;print start screen line 1
        tst   FIRSTCH                          
        beq   displaystateresetexit            ;if done, go to display hub, reset lastch
        movb  #$03, displaystate
        movb  #$00, LASTCH
        ldaa  #$03
        jsr   SETADDR
        rts
        
displaystatereset2:                            ;line 2 reprint routine
        jsr   startscreen2                     ;print start screen line 2
        tst   FIRSTCH
        beq   displaystateresetexit            ;if done, go to display hub, reset lastch
        movb  #$03, displaystate
        movb  #$00, LASTCH
        ldaa  #$03
        jsr   SETADDR
        rts     
        
displaystateresetexit:
        
        rts
        

startscreen1:
        tst   FIRSTCH                    ;test if cursor is in correct position
        lbeq  PUTCHAR                    ;if so start/continue printing
        ldaa  #$00                       ;if not, new cursor address to first line, first pos
        ldx   #DEFAULT_MESSAGE_1         ;load x with default screen message 1
        jsr   PUTCHAR1ST                 ;set cursor to stated cursor address
        rts
        
startscreen2:
        tst   FIRSTCH                    ;test if cursor is in correct position
        lbeq  PUTCHAR                    ;if so start/continue printing
        ldaa  #$40                       ;if not, new cursor address second line, first pos
        ldx   #DEFAULT_MESSAGE_2         ;load x with default screen message 2
        jsr   PUTCHAR1ST                 ;set cursor to stated cursor address
        rts
        
        
displaystateECHO:
        ldy   #BUFFER                    ;get address of first buffer character
        ldaa  KEY_COUNT                  ;get keycount and decrement for proper offset
        deca
        ldx   A, Y                       ;get offset address of key to print
        stx   ECHO                 
        ldab  ECHO                       
        ldaa  CURSOR_ADD
        jsr   OUTCHAR_AT                 ;print ket at cursor address
        ldaa  CURSOR_ADD
        inca
        staa  CURSOR_ADD                 ;change cursor address to next digit location
        jsr   SETADDR                    ;move cursor to stated location
        movb  #$00, LASTCH
        movb  #$01, FIRSTCH                            
        movb  #$00, DMESS_DIGIT          ;reset flags, printing conditions
        movb  #$03, displaystate         ;go back to display hub
        rts

displaystateBS:
        ldaa  CURSOR_ADD                 ;load a with current cursor address
        deca                             ;go back a space
        staa  CURSOR_ADD                 ;save that address
        ldab  #$20
        jsr   OUTCHAR_AT                 ;print a space to previous digit location
        ldaa  CURSOR_ADD
        jsr   SETADDR                    ;move cursor to previous digit location
        movb  #$03, displaystate         ;go back to display hub
        movb  #$00, LASTCH
        movb  #$00, DMESS_BS             ;reset flags, printing conditions
        rts
        
displaystateENT:
        jsr   CURSOR_OFF
        movb  #$03, CURSOR_ADD           ;hide cursor
        ldaa  CURSOR_ADD
        jsr   SETADDR                    ;move cursor to hide address
        movb  #$03, displaystate         ;go back to display hub
        movb  #$00, DMESS_ENT            ;clear enter message flag
        rts
        
displaystateF1:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   F1exit
        ldaa  #$08
        ldx   #MESS_CLR
        jsr   PUTCHAR1ST
        rts
        
F1exit:
        movb  #$03, displaystate
        movb  #$00, LASTCH
        jsr   CURSOR_ON
        ldaa  #$08
        jsr   SETADDR
        movb  #$08, CURSOR_ADD
        movb  #$00, DMESS_F1
        rts
        
displaystateF2:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   F2exit
        ldaa  #$48
        ldx   #MESS_CLR
        jsr   PUTCHAR1ST
        rts
        
F2exit:
        movb  #$03, displaystate
        movb  #$00, LASTCH
        jsr   CURSOR_ON
        ldaa  #$48
        jsr   SETADDR
        movb  #$48, CURSOR_ADD
        movb  #$00, DMESS_F2
        rts

displaystateEB1:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   EB1exit
        ldaa  #$00
        ldx   #MESS_EB
        jsr   PUTCHAR1ST
        rts
        
EB1exit:
        movb  #$00, LASTCH
        movb  #$0F, displaystate
        movb  #$00, DMESS_EB1
        movb  #$01, FIRSTCH
        ldaa  #$43
        jsr   SETADDR
        rts
        
displaystateEB2:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   EB2exit
        ldaa  #$40
        ldx   #MESS_EB
        jsr   PUTCHAR1ST
        rts
        
EB2exit:
        movb  #$00, LASTCH
        movb  #$10, displaystate
        movb  #$00, DMESS_EB2
        movb  #$01, FIRSTCH
        ldaa  #$03
        jsr   SETADDR
        rts
        
displaystateEZ1:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   EZ1exit
        ldaa  #$00
        ldx   #MESS_EZ
        jsr   PUTCHAR1ST
        rts
        
EZ1exit:
        movb  #$00, LASTCH
        movb  #$0F, displaystate
        movb  #$00, DMESS_EZ1
        movb  #$01, FIRSTCH
        ldaa  #$43
        jsr   SETADDR
        rts
        
displaystateEZ2:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   EZ2exit
        ldaa  #$40
        ldx   #MESS_EZ
        jsr   PUTCHAR1ST
        rts
        
EZ2exit:
        movb  #$00, LASTCH
        movb  #$10, displaystate
        movb  #$00, DMESS_EZ2
        movb  #$01, FIRSTCH
        ldaa  #$03
        jsr   SETADDR
        rts

displaystateEN1:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   EN1exit
        ldaa  #$00
        ldx   #MESS_EN
        jsr   PUTCHAR1ST
        rts
        
EN1exit:
        movb  #$00, LASTCH
        movb  #$0F, displaystate
        movb  #$00, DMESS_EN1
        movb  #$01, FIRSTCH
        ldaa  #$43
        jsr   SETADDR
        rts
        
displaystateEN2:
        tst   FIRSTCH
        lbeq  PUTCHAR
        tst   LASTCH
        bne   EN2exit
        ldaa  #$40
        ldx   #MESS_EN
        jsr   PUTCHAR1ST
        rts
        
EN2exit:
        movb  #$00, LASTCH
        movb  #$10, displaystate
        movb  #$00, DMESS_EN2
        movb  #$01, FIRSTCH
        ldaa  #$03
        jsr   SETADDR
        rts
        
PUTCHAR1ST:
        stx   DPTR
        jsr   SETADDR
        clr   FIRSTCH
        
PUTCHAR:           
        ldx   DPTR
        ldab  0,X
        beq   DONE
        inx
        stx   DPTR
        jsr   OUTCHAR
        rts
DONE:
        movb  #$01, FIRSTCH
        movb  #$01, LASTCH
        rts
 
;-------------TASK_4 Pattern_1---------------------------------------------------------
PATTERN_TASK_1:         
        tst   LED_1_ON                 ; tests LED_1_ON to see if LED should be on
        beq   pat1state0
        
        ldaa  pat1state        ; get current t1state and branch accordingly 
        beq   pat1state0 
        deca 
        beq   pat1state1 
        deca 
        beq   pat1state2 
        deca 
        beq   pat1state3 
        deca 
        beq   pat1state4 
        deca 
        beq   pat1state5 
        deca 
        beq   pat1state6 
        rts                            ; undefined state - do nothing but return 
 
pat1state0:                              ; init TASK_1 (not G, not R) 
        bclr  PORTP, LED_MSK_1         ; ensure that LEDs are off when initialized 
        bset  DDRP, LED_MSK_1          ; set LED_MSK_1 pins as PORTS outputs 
        movb  #$01, pat1state            ; set next state 
        rts 
 
pat1state1:                              ; G, not R 
        bset  PORTP, G_LED_1           ; set state1 pattern on LEDs 
        tst   DONE_1                   ; check TASK_1 done flag 
        beq   exit_pat1s1                ; if not done, return 
        movb  #$02, pat1state            ;   otherwise if done, set next state 
exit_pat1s1: 
        rts 
 
pat1state2:                              ; not G, not R 
        bclr  PORTP, G_LED_1           ; set state2 pattern on LEDs 
        tst   DONE_1                   ; check TASK_1 done flag 
        beq   exit_pat1s2                ; if not done, return 
        movb  #$03, pat1state            ;   otherwise if done, set next state 
exit_pat1s2: 
        rts 
 
pat1state3:                              ; not G, R 
        bset  PORTP, R_LED_1           ; set state3 pattern on LEDs 
        tst   DONE_1                   ; check TASK_1 done flag 
        beq   exit_pat1s3                ; if not done, return 
        movb  #$04, pat1state            ;   otherwise if done, set next state 
exit_pat1s3: 
        rts 
 
pat1state4                               ; not G, not R 
        bclr  PORTP, R_LED_1           ; set state4 pattern on LEDs 
        tst   DONE_1                   ; check TASK_1 done flag 
        beq   exit_pat1s4                ; if not done, return 
        movb  #$05, pat1state            ;   otherwise if done, set next state 
exit_pat1s4: 
        rts 
 
pat1state5:                              ; G, R 
        bset  PORTP, LED_MSK_1         ; set state5 pattern on LEDs 
        tst   DONE_1                   ; check TASK_1 done flag 
        beq   exit_pat1s5                ; if not done, return 
        movb  #$06, pat1state            ;   otherwise if done, set next state 
exit_pat1s5: 
        rts 
 
pat1state6:                              ; not G, not R 
        bclr  PORTP, LED_MSK_1         ; set state6 pattern on LEDs 
        tst   DONE_1                   ; check TASK_1 done flag 
        beq   exit_pat1s6                ; if not done, return 
        movb  #$01, pat1state            ;   otherwise if done, set next state 
exit_pat1s6: 
        rts                            ; exit TASK_1 

;-------------TASK_5 Timing_1---------------------------------------------------------
TIMING_TASK_1:                        
        
        ldaa  time1state                  ; get current t2state and branch accordingly 
        beq   time1state0 
        deca 
        beq   time1state1 
        rts                            ; undefined state - do nothing but return 
 
time1state0:                              ; initialization for TASK_2 
        movw  TICKS_1, COUNT_1         ; init COUNT_1 
        clr   DONE_1                   ; init DONE_1 to FALSE 
        movb  #$01, time1state            ; set next state 
        rts 
 
time1state1:                              ; Countdown_1 
        ldaa  DONE_1 
        cmpa  #$01 
        bne   time1s1a                    ; skip reinitialization if DONE_1 is FALSE
        movw  TICKS_1, COUNT_1
        clr   DONE_1
         
time1s1a:  
        decw  COUNT_1
        bne  exit_time1s2
        movb  #$01, DONE_1
                                                                         
exit_time1s2: 
        rts                            ; exit TASK_2 

;-------------TASK_6 Pattern_2---------------------------------------------------------

PATTERN_TASK_2: 
        tst   LED_2_ON                 ; tests LED_1_ON to see if LED should be on
        beq   pat2state0
        
        ldaa  pat2state                  ; get current t4state and branch accordingly 
        beq   pat2state0 
        deca 
        beq   pat2state1 
        deca 
        beq   pat2state2 
        deca 
        beq   pat2state3 
        deca 
        beq   pat2state4 
        deca 
        beq   pat2state5 
        deca 
        beq   pat2state6 
        rts                            ; undefined state - do nothing but return 
 
pat2state0:                              ; init TASK_4 (not G, not R) 
        bclr  PORTP, LED_MSK_2         ; ensure that LEDs are off when initialized 
        bset  DDRP, LED_MSK_2          ; set LED_MSK_2 pins as PORTS outputs 
        movb  #$01, pat2state            ; set next state 
        rts 
 
pat2state1:                              ; G, not R 
        bset  PORTP, G_LED_2           ; set state1 pattern on LEDs 
        tst   DONE_2                   ; check TASK_4 done flag 
        beq   exit_pat2s1                ; if not done, return 
        movb  #$02, pat2state            ;   otherwise if done, set next state 
exit_pat2s1: 
        rts 
 
pat2state2:                              ; not G, not R 
        bclr  PORTP, G_LED_2           ; set state2 pattern on LEDs 
        tst   DONE_2                   ; check TASK_4 done flag 
        beq   exit_pat2s2                ; if not done, return 
        movb  #$03, pat2state            ;   otherwise if done, set next state 
exit_pat2s2: 
        rts 
 
pat2state3:                              ; not G, R 
        bset  PORTP, R_LED_2           ; set state3 pattern on LEDs 
        tst   DONE_2                   ; check TASK_4 done flag 
        beq   exit_pat2s3                ; if not done, return 
        movb  #$04, pat2state            ;   otherwise if done, set next state 
exit_pat2s3: 
        rts 
 
pat2state4                               ; not G, not R 
        bclr  PORTP, R_LED_2           ; set state4 pattern on LEDs 
        tst   DONE_2                   ; check TASK_4 done flag 
        beq   exit_pat2s4                ; if not done, return 
        movb  #$05, pat2state            ;   otherwise if done, set next state 
exit_pat2s4: 
        rts 
 
pat2state5:                              ; G, R 
        bset  PORTP, LED_MSK_2         ; set state5 pattern on LEDs 
        tst   DONE_2                   ; check TASK_4 done flag 
        beq   exit_pat2s5                ; if not done, return 
        movb  #$06, pat2state            ;   otherwise if done, set next state 
exit_pat2s5: 
        rts 
 
pat2state6:                              ; not G, not R 
        bclr  PORTP, LED_MSK_2         ; set state6 pattern on LEDs 
        tst   DONE_2                   ; check TASK_4 done flag 
        beq   exit_pat2s6                ; if not done, return 
        movb  #$01, pat2state            ;   otherwise if done, set next state 
exit_pat2s6: 
        rts                            ; exit TASK_4 
        

;-------------TASK_7 Timing_2---------------------------------------------------------

TIMING_TASK_2: 
        ldaa  time2state                  ; get current t5state and branch accordingly 
        beq   time2state0 
        deca 
        beq   time2state1 
        rts                            ; undefined state - do nothing but return 
 
time2state0:                              ; initialization for TASK_5 
        movw  TICKS_2, COUNT_2         ; init COUNT_2 
        clr   DONE_2                   ; init DONE_2 to FALSE 
        movb  #$01, time2state            ; set next state 
        rts 
 
time2state1:                              ; Countdown_2 
        ldaa  DONE_2 
        cmpa  #$01 
        bne   time2s1a                    ; skip reinitialization if DONE_2 is FALSE
        movw  TICKS_2, COUNT_2
        clr   DONE_2
         
time2s1a:  
        decw  COUNT_2
        bne  exit_time2s2
        movb  #$01, DONE_2
                                                                         
exit_time2s2: 
        rts                            ; exit TASK_5 
 

;-------------TASK_8 Delay---------------------------------------------------------
       
DELAY_TASK: 
        ldaa  delaystate                  ; get current t3state and branch accordingly 
        beq   delaystate0 
        deca 
        beq   delaystate1 
        rts                            ; undefined state - do nothing but return 
 
delaystate0:                              ; initialization for TASK_3 
                                       ; no initialization required 
        movb  #$01, delaystate            ; set next state 
        rts 
 
delaystate1: 
        jsr   DELAY_1ms 
        rts                            ; exit TASK_3 
    

;/------------------------------------------------------------------------------------\
;| Subroutines                                                                        |
;\------------------------------------------------------------------------------------/
; General purpose subroutines go here
;// DELAY 1ms /////
DELAY_1ms: 
        ldy   #$0584 
INNER:                                 ; inside loop 
        cpy   #0 
        beq   EXIT 
        dey 
        bra   INNER 
EXIT: 
        rts                            ; exit DELAY_1ms 
;// BUFFER STORE //        
buffer_store:   
        ldaa  KEY_COUNT
        cmpa  #$05                     ; make sure there aren't 4 or more keys in buffer (would overflow)
        bhs   clear_key
        movb  #$01, DMESS_DIGIT
        ldx   #BUFFER
        
        ldab  KEY_BUFFER               ; store digit
        stab  a, x               ; a should still be key_count
        inc   KEY_COUNT                ; +1 keys in buffer now
        rts                            ; exit, key clearing done in state3 before exit

 ;// CLEAR KEY ////       
clear_key:
        clr   KEY_BUFFER
        clr   KEY_FLG
        movb  #$01, masterstate         ; go back to waiting for key press
        rts

;//  ASCII DECODE //////
asc_decode:
        ; NOTE: most of these variables could be circumvented by using storage that's already defined
        ; this could be implemented later, but the fast solution was used first.
        ; OUTPUTS: x result, a is error code
        ; ERROR CODES: 0 if no error, 1 if overflow error, 2 if zero error
        clr   COUNT                          ; prep intermediate variables
        clr   TEMP
        clrw  RESULT
        
        movb  KEY_COUNT, COUNT              ; move byte to decrementer
        
        ; store the registers and accumulators
        pshc                                 ; push ccr to stack
        pshb                                 ; push b to stack
        pshy                                 ; push y to stack
        
        ldx   #BUFFER                        ; load x for indexed addressing

        
while:                                       ; loop through each digit
        
        ldaa  TEMP                           ; counter for number of digits to index
       
        ldab  a,x                            ; retrieve desired value from buffer
        subb  #$30                           ; get BCD by subtracting 30
        inc   TEMP                           ; increment TEMP
        
        ldy   RESULT                         ; load y with current result
        aby                                  ; add latest digit
        sty   RESULT                         ; then store back in result
        bcs   overflowerror                  ; check that adding didn't create overflow
        
        dec   COUNT                          ; decrement count
        ldab  COUNT                          ; load into b to check if done
        cmpb  #$00                           ; if count is zero, the subroutine is done
        beq   return                         ; if that was last digit, don't mult by 10
        
        ldd   #$000A                         ; for mult by 10, y already loaded
        emul                                 ; y x d, store in y:d
        cpy   #$00                           ; y should be empty or we have overflow
        bne   overflowerror                  ; error routine if error occurred
        std   RESULT                         ; store the result in result
        bra   while                          ; keep looping while count > 0
        
return:
        ldx   RESULT                         ; load x
        cpx   #$0000                           ; check for zero result
        beq   zeroerror                      ; if result was empty, zero error
        ldaa  #$00                           ; if it got here, it didn't hit an error                         ; return result in x register
        bra   restore                        ; exit routine

overflowerror:
        ldaa  #$01                           ; error code for overflow error
        bra   restore                        ; exit routine

zeroerror:
        ldaa  #$02                           ; error code for zero error
        bra   restore                        ; exit routine
        
restore:                                     ; LIFO, restores accumulators, registers, CCR, 
        puly                                 ; restore index register y from stack
        pulb                                 ; restore accumulator b from stack
        pulc                                 ; restore ccr from stack
        rts                                  ; ouput is 

;/------------------------------------------------------------------------------------\
;| ASCII Messages and Constant Data                                                   |
;\------------------------------------------------------------------------------------/
; Any constants can be defined here

DEFAULT_MESSAGE_1:      DC.B    'TIME1 =       <F1> to update LED1 period', $00
DEFAULT_MESSAGE_2:      DC.B    'TIME2 =       <F2> to update LED2 period', $00
MESS_EB:                DC.B    'INVALID VALUE: TOO BIG                  ', $00
MESS_EZ:                DC.B    'INVALID VALUE: ZERO                     ', $00 
MESS_EN:                DC.B    'INVALID VALUE: NO DIGITS ENTERED        ', $00
MESS_CLR:               DC.B    '     ', $00



;/------------------------------------------------------------------------------------\
;| Vectors                                                                            |
;\------------------------------------------------------------------------------------/
; Add interrupt and reset vectors here

        ORG   $FFFE                    ; reset vector address
        DC.W  Entry
        ORG   $FFCE                    ; Key Wakeup interrupt vector address [Port J]
        DC.W  ISR_KEYPAD
