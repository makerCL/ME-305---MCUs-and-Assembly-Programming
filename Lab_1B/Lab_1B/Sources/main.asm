;**************************************************************************************
;* 1B Project Main [includes LibV2.2]                                                 *
;**************************************************************************************
;* Summary:                                                                           *
;*   -                                                                                *
;*                                                                                    *
;* Author: BENJAMIN FIELDS AND MILES ALDERMAN                                         *                         *
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

PORTT         EQU   $0240              ; input port for DELAY_CNT 
DDRT          EQU   $0242 
PORTP         EQU   $0258              ; output port for driving LEDs 
DDRP          EQU   $025A 
LED_MSK       EQU   %00110000          ; LED output pins 
G_LED         EQU   %00010000          ; green LED output pin 
R_LED         EQU   %00100000          ; red LED output pin 

;/------------------------------------------------------------------------------------\
;| Variables in RAM                                                                   |
;\------------------------------------------------------------------------------------/
; The following variables are located in unpaged ram

DEFAULT_RAM:  SECTION

DELAY_CNT     DS.B  1 

;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; This code implements Lab_1A for ME 305

MyCode:       SECTION

main:   jsr   SETUP                  ; jump to SETUP subroutine  
proc:   bset  PORTP, G_LED           ; turn green LED on
        jsr   DELAY
        bclr  PORTP, LED_MSK         ; turn both LEDs off
        jsr   DELAY
        bset  PORTP, R_LED           ; turn red LED on
        jsr   DELAY
        bclr  PORTP, LED_MSK         ; turn both LEDs off
        jsr   DELAY
        bset  PORTP, LED_MSK         ; turn both LEDs on
        jsr   DELAY
        bclr  PORTP, LED_MSK         ; turn both LEDs off    
        jsr   DELAY                  ; delay
        bra   proc
        
         

spin:   bra   spin 


;/------------------------------------------------------------------------------------\
;| Subroutines                                                                        |
;\------------------------------------------------------------------------------------/
; General purpose subroutines go here

;-----------Delay----------------------------------------------------------------- 
DELAY:       
        ldaa  PORTT                    ; (3) load 8-bit DELAY_CNT from PORTT 
        staa  DELAY_CNT                ; (3) 
OUTER:                                 ; outer loop 
        ldaa  DELAY_CNT                ; (3) 
        cmpa  #0                       ; (1) 
        beq   EXIT                     ; (1) 
        dec   DELAY_CNT                ; (4) 
        ldx   #$0005                   ; (2) 
MIDDLE:                                ; middle loop 
        cpx   #0                       ; (2) 
        beq   OUTER                    ; (1) 
        dex                            ; (1) 
        ldy   #$7710                   ; (2) 
INNER:                                 ; inner loop 
        cpy   #0                       ; (2) 
        beq   MIDDLE                   ; (1) 
        dey                            ; (1) 
        bra   INNER                    ; (3) 
EXIT: 
        rts                            ; (5) exit DELAY 

SETUP: 
; setup IO ports 
 
        clr   DDRT                     ; set PORTT to input 
        bclr  PORTP, LED_MSK           ; initialize LEDs to off 
        bset  DDRP,LED_MSK             ; set LED pins to output 
        rts                            ; exit SETUP 
 
; end subroutine SETUP 

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
