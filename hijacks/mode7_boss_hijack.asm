; start of main bowser routine
org baby_bowser_hijack
    JSR baby_bowser_hook
    NOP

; bowser mode7 hdma hijack
org baby_bowser_hijack+$0FA0
    JSR bowser_mode7_hdma_hook
    NOP #2
    JMP baby_bowser_hijack+$0FB3

; hijack the entire loop so it can be called manually from our code
org hookbill_mode7_hdma_hijack
    JSL hookbill_mode7_hdma
    NOP #3
    JMP hookbill_mode7_hdma_hijack+$14

org raphael_hijack
    autoclean JSL raphael_hud_fix
    NOP #2

org $00C699
    autoclean JSL tm_hdma
    NOP #3


; freespace in bank 0D in J1.0 (70 bytes), middle of a larger block in U1.0
org $0DFFBA

baby_bowser_hook:
    JSL main_bowser
    CPY #$24
    RTS

bowser_mode7_hdma_hook:
    JSL bowser_mode7_hdma
    RTS
