;**************************************************************************************
;* Blank Project Main [includes LibV2.2]                                              *
;**************************************************************************************
;* Summary:                                                                           *
;*   -                                                                                *
;*                                                                                    *
;* Author: YOUR NAME                                                                  *
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

INTERVAL      EQU   $03E0        ;number of clock pulses that equal 0.1ms from 10.2MHz clock

TIOS          EQU   $0040        ; addr of tios register
Chan0         EQU   %00000001    ;offset for channel 0

TCTL2         EQU   $0049        ; TCTL2 register that contains OL0 and OM0
OL0           EQU   %00000001    ; mask for 0L0 in TCTL2

TFLG1         EQU   $004E        ; Main timer interupt flag 1
C0F           EQU   %00000001    ; mask for C0F in TFLG1

TMSK1         EQU   $004C        ; Timer interupt mask
C0I           EQU   %00000001    ; mask for C0I

TSCR          EQU   $0046        ; Timer system control
TSCR_msk      EQU   %10100000    ; mask for timer system control

TCNT          EQU   $0044        ; first byte of timer count register

TC0           EQU   $0050        ; Timer channel 0 first (high) byte



;/------------------------------------------------------------------------------------\
;| Variables in RAM                                                                   |
;\------------------------------------------------------------------------------------/
; The following variables are located in unpaged ram

DEFAULT_RAM:  SECTION



;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode:       SECTION
main:   
        bgnd
setup:                                 ; step 2
        bset  TIOS, Chan0              ; set timer chan 0 for output compare
        bset  TCTL2, OL0               ; toggle tc0 for successful compare, OM0:OL0 should be 01
        bset  TFLG1, C0F               ; clear timer output compare flag by writing a 1 to it
        cli                            ; clear I bit to enable maskable interupts
        bset  TMSK1, C0I               ; enable timer overflow flag to trigger input

first_interrupt:                        ; step 3
        bset  TSCR, TSCR_msk           ; freeze mode when debugger stops executing
        ldd   TCNT                     ; load $0044:$0045 into d
        addd  #INTERVAL                ; add interval to timer count
        std   TC0                      ; store in timer channel 0

spin:   bra   spin                     ; endless horizontal loop
        
ISR:                                   ; step 4
        ldd   TCNT                     ; load $0044:$0045 into d
        addd  #INTERVAL                ; add interval to timer count
        std   TC0                      ; store in timer channel 0
        bset  TFLG1, C0F               ; clear timer output compare flag by writing a 1 to it
        rti
           



;/------------------------------------------------------------------------------------\
;| Subroutines                                                                        |
;\------------------------------------------------------------------------------------/
; General purpose subroutines go here


;/------------------------------------------------------------------------------------\
;| ASCII Messages and Constant Data                                                   |
;\------------------------------------------------------------------------------------/
; Any constants can be defined here


;/------------------------------------------------------------------------------------\
;| Vectors                                                                            |
;\------------------------------------------------------------------------------------/
; Add interrupt and reset vectors here

        ORG   $FFEE                    ; timer ch0 vector address
        DC.W  ISR
        ORG   $FFFE                    ; reset vector address
        DC.W  Entry
        ORG   $FFCE                    ; Key Wakeup interrupt vector address [Port J]
        DC.W  ISR_KEYPAD
