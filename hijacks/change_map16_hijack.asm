org change_map16_hijack
    JMP record_map16_changes

org $10FFA3 ; freespace in bank $10

; 16-bit AI, DP zero
; $02 = map16 table index for tile being updated
; $8F = collision type (0-7)
; each time the game is about to update the WRAM map16 table, save the original value so that it can be restored when loading a savestate
; ~~~ performance critical ~~~
record_map16_changes:
    ; don't need to record unless a savestate is in the current room
    LDA !current_level : CMP !save_level : BNE .ret

    LDX $02 : TXY
    LDA !r_map16_table,x ; get original value
    
    ; if the index is greater than the max size, we've used all of the freespace
    ; commenting out to save cycles since it's unlikely that 1000 tiles change in one room
    LDX !map16delta_index ; : CPX #!wram_map16delta_size-4 : BCS .ret

    ; store original value
    STA !wram_map16delta_savestate,x
    INX #2

    ; store position in the next 2 bytes
    TYA : STA !wram_map16delta_savestate,x
    INX #2

    STX !map16delta_index ; update the index
.ret
    ; hijacked code
    LDA $8F : ASL
    JMP change_map16_hijack+$03
