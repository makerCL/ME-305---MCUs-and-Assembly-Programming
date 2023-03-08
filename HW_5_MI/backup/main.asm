;**************************************************************************************
;* Blank Project Main [includes LibV2.2]                                              *
;**************************************************************************************
;* Summary: 2 byte addition with checks for saturation                                                                          *
;*   -                                                                                *
;*                                                                                    *
;* Author: MILES ALDERMAN                                                                  *
;*   Cal Poly University                                                              *
;*   Spring 2022                                                                      *
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



;/------------------------------------------------------------------------------------\
;| Variables in RAM                                                                   |
;\------------------------------------------------------------------------------------/
; The following variables are located in unpaged ram

DEFAULT_RAM:  SECTION
TEMP:         DS.B         2


;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode:       SECTION
main:   bgnd
        clrw   TEMP
                                ; syntax: n - low N-flag; N - high N-flag
        ; VALID POS + POS       ; nzvc
        ldd   #$1F11
        ldy   #$12FE
        jsr   adddy
        bgnd
        
        ; VALID NEG + NEG         ; NzvC
        ldd   #$BD98    ; -17000 
        ldy   #$D120    ; -12000
        jsr   adddy     ; 320F
        bgnd    
        
        ; VALID NEG + NEG         ; NzvC
        ldd   #$FFFB    ; -5 
        ldy   #$FFB0    ; -80
        jsr   adddy     ; FFAB
        bgnd        
            
        
        ; POS and NEG             ; nzVC
        ldd   #$88B8    ; 31000
        ldy   #$D120    ; -12000
        jsr   adddy     ; $8EB8
        bgnd        
        
        ; POS and NEG             ; Nzvc
        ldd   #$1F4    ; 500
        ldy   #$8000    ; -32768
        jsr   adddy     ; $81F4
        bgnd       
        
        ; POSITIVE OVERFLOW     ; NzVc
        ldd   #$4E20    ; 20000
        ldy   #$4E20    ; 20000
        jsr   adddy     ; 40000/ 9C40
        bgnd        
        
        ; NEGATIVE OVERFLOW     ; nzVC
        ldd   #$8AD0    ; -30000
        ldy   #$8AD0    ; -30000
        jsr   adddy     ; -8000 
        bgnd
        
                
        
        ; NON-SAT EDGE CASE HIGH END
        
        
        ; NON-SAT EDGE CASE LOW END
        
        
spin:   bra   spin                     ; endless horizontal loop


;/------------------------------------------------------------------------------------\
;| Subroutines                                                                        |
;\------------------------------------------------------------------------------------/
; General purpose subroutines go here

adddy:
        pshc                                 ; push ccr to stack
        pshx                                 ; push b to stack
        pshy                                 ; push y to stack
        ldaa  #$00
        
        cpd   #00
        bhs   skip_add_d                     ; branch if more than 0
        inca 
        
 skip_add_d:       
        cpy   #00
        bhs   skip_add_y 
        inca
        
 skip_add_y:                                  ; zeros go in as positive
        sty   TEMP
        addd  TEMP
        
        tsta
        beq   pos_overflow_test               ; if both numbers positive, test pos overflow
        
        cmpa  #02
        beq   neg_overflow_test               ; if both numbers negative, test neg overflow
        
        cmpa  #01
        beq   restore
        
        ; else something went wrong w a
        rts
        
neg_overflow_test:
        ; test if d < 0 (no error)
        ; if so, break to finish
        ; if not, assign saturated value
        ldd   #$8000
        bra   restore

pos_overflow_test:
        ; test if d > 0 (no error)              ; if a = 0, d < 0 would be an error
        ; if so, break to finish
        ; if not, assign saturated value
        
        ldd   #$7FFF
        bra   restore
        
        ; check d, if positive add 0, if negative add 1 to a
        ; check y, if positive add 0, if negative add 1 to a
        ; if a = 2, two negative. if a = 0, two positive, if a = 1, opposite sign we know we gucci
        
restore:                                     ; LIFO, restores accumulators, registers, CCR, 
        puly                                 ; restore index register y from stack
        pulx                                 ; restore accumulator b from stack
        pulc                                 ; restore ccr from stack        
        ;bgnd
        rts



;/------------------------------------------------------------------------------------\
;| ASCII Messages and Constant Data                                                   |
;\------------------------------------------------------------------------------------/
; Any constants can be defined here


;/------------------------------------------------------------------------------------\
;| Vectors                                                                            |
;\------------------------------------------------------------------------------------/
; Add interrupt and reset vectors here

        ORG   $FFFE                    ; reset vector address
        DC.W  Entry
        ORG   $FFCE                    ; Key Wakeup interrupt vector address [Port J]
        DC.W  ISR_KEYPAD
