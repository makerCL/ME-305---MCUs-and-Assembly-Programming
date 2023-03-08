;**************************************************************************************
;* Homework 5 Main [includes LibV2.2]                                              *
;**************************************************************************************
;* Summary: 2 byte addition with checks for saturation                                                                          *
;*   -                                                                                *
;*                                                                                    *
;* Author: MILES ALDERMAN                                                                  *
;*   Cal Poly University                                                              *
;*   Spring 2022                                                                      *
;*   ME305-03                                                                                 *
;*                                                                 *
;*                                                                                *
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

        
        ; NEGATIVE OVERFLOW     ; nzVC
        ldd   #$8AD0    ; -30000
        ldy   #$8AD0    ; -30000
        bgnd
        jsr   adddy     ; -8000 
        bgnd
        
        ; POSITIVE OVERFLOW     ; NzVc
        ldd   #$4E20    ; 20000
        ldy   #$4E20    ; 20000
        bgnd
        jsr   adddy     ; 40000/ 9C40
        bgnd  
        
        ; VALID POS + POS       ; nzvc
        ldd   #$1F11
        ldy   #$12FE
        bgnd
        jsr   adddy
        bgnd
        
        ; VALID NEG + NEG         ; NzvC
        ldd   #$BD98    ; -17000 
        ldy   #$D120    ; -12000
        bgnd
        jsr   adddy     ; 320F
        bgnd    
        
        ; VALID NEG + NEG         ; NzvC
        ldd   #$FFFB    ; -5 
        ldy   #$FFB0    ; -80
        bgnd
        jsr   adddy     ; FFAB
        bgnd        
            
        
        ; POS and NEG             ; nzvC
        ldd   #$7198    ; 31000
        ldy   #$D120    ; -12000
        bgnd
        jsr   adddy     ; $8EB8
        bgnd        
        
        ; POS and NEG             ; Nzvc
        ldd   #$1F4    ; 500
        ldy   #$8000    ; -32768
        bgnd
        jsr   adddy     ; $81F4
        bgnd       
               
        
        ; NON-SAT EDGE CASE HIGH END
        ldd   #$1F4     ; 500
        ldy   #$7FFF    ; 32767
        bgnd
        jsr   adddy     ; $81F4
        bgnd            
        
        ; NON-SAT EDGE CASE LOW END
        ldd   #$FFFB    ; -5 
        ldy   #$8000    ; -32768
        bgnd
        jsr   adddy     ; $81F4
        bgnd 
        
spin:   bra   spin                     ; endless horizontal loop


;/------------------------------------------------------------------------------------\
;| Subroutines                                                                        |
;\------------------------------------------------------------------------------------/
; General purpose subroutines go here

adddy:
        pshc                                 ; push ccr to stack
        pshx                                 ; push b to stack
        pshy                                 ; push y to stack
                        
        sty   TEMP                           ; store y for addition
        addd  TEMP                           ; add d + y
        
        bvs   overflow                       ; if V flag is set, the result overflowed
        
restore:                                     ; LIFO, restores accumulators, registers, CCR, 
        puly                                 ; restore index register y from stack
        pulx                                 ; restore accumulator b from stack
        pulc                                 ; restore ccr from stack        
        rts

overflow:
        cpy   #00
        bgt   pos_overflow                   ; if the value still in y is positive, there was pos overflow 
                                             ; else there was negative overflow
        ldd   #$8000                          ; negative saturation value
        bra   restore
        
pos_overflow:
        ldd   #$7FFF                         ; positive saturation value
        bra   restore

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
