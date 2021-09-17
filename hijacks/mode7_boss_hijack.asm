; bowser mode7 hdma hijack
org baby_bowser_hijack+$0FA2
    JSR bowser_mode7_hdma_hook

; hijack the entire loop so it can be called manually from our code
org hookbill_mode7_hdma_hijack
    JSL hookbill_mode7_hdma
    NOP #3
    JMP hookbill_mode7_hdma_hijack+$14

org $00C699
    JSL tm_hdma
    NOP #3


; freespace in bank 0D in J1.0 (70 bytes), middle of a larger block in U1.0
org $0DFFBA

bowser_mode7_hdma_hook:
    JSL bowser_mode7_hdma
    RTS
