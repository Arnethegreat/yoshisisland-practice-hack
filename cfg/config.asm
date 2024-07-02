; ===========================
; Input configuration allows the player to assign arbitrary button combinations for a selection of practice hack features.
; There are some caveats that complicate the implementation:
; 1. How do we avoid collisions? e.g. action 1 bound to A and action 2 bound to A+X; user holds X then presses A - what happens?
;   Action 2 should trigger because it involves more buttons - it's more specific.
;   We dynamically assign priority to bindings based on the number of buttons they use, a.k.a. their complexity.

; 2. We must check every frame for an input in order to trigger an action. Say the action is to toggle some flag, and it's bound to A+X.
;       If we poll the controller_press registers, the user would have to press both A and X on the same frame for it to trigger.
;       If we poll the normal "held" controller registers, the action would trigger every single frame that the buttons are held.
;   Neither of these work particularly well.
;   To circumvent these issues, we store both a "held" and a "press" binding per controller.
;   If an action is bound to multiple buttons, the rightmost button will be the "press" binding, and the rest will be "held".
; 	This means that a binding of L+R+X will require the user to hold L and R and finally press X to activate the action.
; ===========================

; SRAM vars, each binding set is 8 bytes, 4 per gamepad:
; |             pad 1             |             pad 2             |
; |      held     |     press     |      held     |     press     |
; | data1 | data2 | data1 | data2 | data1 | data2 | data1 | data2 |
%var_707E7E(bind_evenalign, 1) ; take an extra byte here because the superfx is dumb and needs word addrs to be even
%var_707E7E(bind_savestate_1, 4)
%var_707E7E(bind_savestate_2, 4)
%var_707E7E(bind_loadstate_1, 4)
%var_707E7E(bind_loadstate_2, 4)
%var_707E7E(bind_loadstatefull_1, 4)
%var_707E7E(bind_loadstatefull_2, 4)
%var_707E7E(bind_loadstateroom_1, 4)
%var_707E7E(bind_loadstateroom_2, 4)
%var_707E7E(bind_musictoggle_1, 4)
%var_707E7E(bind_musictoggle_2, 4)
%var_707E7E(bind_freemovement_1, 4)
%var_707E7E(bind_freemovement_2, 4)
%var_707E7E(bind_slowdowndecrease_1, 4)
%var_707E7E(bind_slowdowndecrease_2, 4)
%var_707E7E(bind_slowdownincrease_1, 4)
%var_707E7E(bind_slowdownincrease_2, 4)
%var_707E7E(bind_disableautoscroll_1, 4)
%var_707E7E(bind_disableautoscroll_2, 4)
!binding_startaddr_sram = !bind_savestate_1
!binding_size_sram = 18*2 ; size in words
%var_707E7E(bind_checksum, 2)

; helper table for copying the bindings and assigning the control bytes
action_binding_table:
    dw $0000, !bind_savestate_1, !bind_savestate_2
    dw $0002, !bind_loadstate_1, !bind_loadstate_2
    dw $0004, !bind_loadstatefull_1, !bind_loadstatefull_2
    dw $0006, !bind_loadstateroom_1, !bind_loadstateroom_2
    dw $0008, !bind_musictoggle_1, !bind_musictoggle_2
    dw $000A, !bind_disableautoscroll_1, !bind_disableautoscroll_2
    dw $000C, !bind_freemovement_1, !bind_freemovement_2
    dw $000E, !bind_slowdowndecrease_1, !bind_slowdowndecrease_2
    dw $0010, !bind_slowdownincrease_1, !bind_slowdownincrease_2

!binding_count = $08 ; number of elements in the table minus 1
!binding_last_el = $30 ; index of the last element in the table

; WRAM vars
%var_1409(input_bindings_1, (!binding_count+1)*6) ; 6 bytes per binding (control byte + complexity + held binding + press binding)
%var_1409(input_bindings_1_offsets, !binding_count+1) ; 1 byte per binding, stores offsets into input_bindings_1 ordered by priority
%var_1409(input_bindings_2, (!binding_count+1)*6) ; same for gamepad 2
%var_1409(input_bindings_2_offsets, !binding_count+1)


; initialise the bindings for use in the main game loop
prepare_input_bindings:
    JSR copy_bindings_to_wram ; SRAM -> WRAM

    %ai8()
    ; init priority offsets e.g. each element 6 bytes wide, 3 elements total would give [$00, $06, $0C]
    LDA #!binding_last_el
    LDX #!binding_count
  - {
        STA !input_bindings_1_offsets,x
        STA !input_bindings_2_offsets,x
        SEC : SBC #$06
        DEX
        BPL -
    }

    ; sort the priority offsets
    %a16()
    LDA #!input_bindings_1+1 : STA $00 ; 1st complexity
    LDA #!input_bindings_1+7 : STA $02 ; 2nd complexity
    LDA #!input_bindings_1_offsets : STA $04 ; 1st offset
    LDA #!input_bindings_1_offsets+1 : STA $06 ; 2nd offset
    JSR sort_bindings
    LDA #!input_bindings_2+1 : STA $00 ; 1st complexity
    LDA #!input_bindings_2+7 : STA $02 ; 2nd complexity
    LDA #!input_bindings_2_offsets : STA $04 ; 1st offset
    LDA #!input_bindings_2_offsets+1 : STA $06 ; 2nd offset
    JSR sort_bindings
.ret
    RTS

copy_bindings_to_wram:
    %a16()
    %i8()
    LDY #!binding_last_el
  - {
        ; store the pointers in temp vars
        LDX #$70 : STX $02 : STX $05 : STX $08 : STX $0B ; setting SRAM bank
        LDA action_binding_table+2,y : STA $00 ; pad 1 held
        INC #2 ; advance the ptr by two bytes
        STA $03  ; press
        LDA action_binding_table+4,y : STA $06 ; pad 2 held
        INC #2 ; advance the ptr by two bytes
        STA $09 ; press

        ; copy the bindings into WRAM along with control byte and complexity
        LDA [$03] : STA !input_bindings_1+4,y ; press
        LDA [$00] : STA !input_bindings_1+2,y ; held
        JSR calc_complexity ; press will always have 1 set bit, so ignore it and just calc complexity for held
        TXA ; combine complexity and control byte and store together using 16-bit A
        XBA
        ORA action_binding_table+0,y ; A is zeroed after calc_complexity, so we can just OR
        STA !input_bindings_1+0,y ; control byte, complexity

        LDA [$09] : STA !input_bindings_2+4,y ; press
        LDA [$06] : STA !input_bindings_2+2,y ; held
        JSR calc_complexity
        TXA
        XBA
        ORA action_binding_table+0,y
        STA !input_bindings_2+0,y ; control byte, complexity

        DEY #6
        BPL -
    }
.ret
    RTS

; count number of set bits in a word by repeatedly clearing the rightmost set bit and returning when the value is zero
; e.g. 1011 count=0, 1010 count=1, 1000 count=2, 0000 -> return count=3
; INPUT PARAM: A = some 2-byte integer n
; RETURNS: X = number of set bits in the integer n, A = 0
calc_complexity:
!temp = $00
    PHP
    %a16()
    %i8()
    LDX #$00 ; count = 0
  - {
        CMP #$0000 : BEQ .ret ; if n == 0, we're done
        STA !temp : DEC : AND !temp ; else, n = n & (n-1)
        INX ; increment count
        BRA -
    }
.ret
    PLP
    RTS
undef "temp"

; michael buble sort, highest on the right
!table_1 = $00
!table_2 = $02
!offsets_1 = $04
!offsets_2 = $06
sort_bindings:
!array = $30
!flag = $32
    PHP
    %ai8()
.start_of_list
    LDY #!binding_last_el
    STZ !flag ; turn off flag at the start of each loop
    LDX #!binding_count
.next_element
    LDA (!table_1),y ; get complexity
    DEY #6
    CMP (!table_1),y ; compare against previous (leftward) element's complexity
    BCS + ; is right >= left? if true, order is correct - no need to do anything
    {
        ; else, we perform two swaps: the separate offsets AND the complexities
        ; we don't need to exchange the entire 6-byte blocks because the separate offsets will hold the order
        PHA
        LDA (!table_1),y : STA (!table_2),y
        PLA : STA (!table_1),y

        PHY : TXY ; move X into Y since there is no (),x addressing mode
        DEY ; but X is 1 higher than we need for leftwards comparison
        LDA (!offsets_1),y : PHA
        LDA (!offsets_2),y : STA (!offsets_1),y
        PLA : STA (!offsets_2),y
        PLY

        LDA #$FF : STA !flag ; turn flag on
    }
+
    DEX
    BNE .next_element
    BIT !flag ; end of list, if flag is on we need to loop again
    BMI .start_of_list
.ret
    PLP
    RTS
undef "table_1"
undef "table_2"
undef "offsets_1"
undef "offsets_2"
undef "array"
undef "flag"

default_input_bindings:
    PHP
    %a16()
    ; first word = held, second word = pressed
    ; zero = no binding
    LDA #$0000 : STA !bind_savestate_1 : LDA #!controller_select : STA !bind_savestate_1+2
    LDA #$0000 : STA !bind_savestate_2 : STA !bind_savestate_2+2
    LDA #$0000 : STA !bind_loadstate_1 : LDA #!controller_X : STA !bind_loadstate_1+2
    LDA #$0000 : STA !bind_loadstate_2 : STA !bind_loadstate_2+2
    LDA #!controller_L : STA !bind_loadstatefull_1 : LDA #!controller_X : STA !bind_loadstatefull_1+2
    LDA #$0000 : STA !bind_loadstatefull_2 : STA !bind_loadstatefull_2+2
    LDA #!controller_R : STA !bind_loadstateroom_1 : LDA #!controller_X : STA !bind_loadstateroom_1+2
    LDA #$0000 : STA !bind_loadstateroom_2 : STA !bind_loadstateroom_2+2
    LDA #$0000 : STA !bind_musictoggle_1 : STA !bind_musictoggle_1+2
    LDA #$0000 : STA !bind_musictoggle_2 : LDA #!controller_select : STA !bind_musictoggle_2+2
    LDA #$0000 : STA !bind_freemovement_1 : STA !bind_freemovement_1+2
    LDA #$0000 : STA !bind_freemovement_2 : LDA #!controller_B : STA !bind_freemovement_2+2
    LDA #$0000 : STA !bind_slowdowndecrease_1 : STA !bind_slowdowndecrease_1+2
    LDA #$0000 : STA !bind_slowdowndecrease_2 : LDA #!controller_L : STA !bind_slowdowndecrease_2+2
    LDA #$0000 : STA !bind_slowdownincrease_1 : STA !bind_slowdownincrease_1+2
    LDA #$0000 : STA !bind_slowdownincrease_2 : LDA #!controller_R : STA !bind_slowdownincrease_2+2
    LDA #$0000 : STA !bind_disableautoscroll_1 : STA !bind_disableautoscroll_1+2
    LDA #$0000 : STA !bind_disableautoscroll_2 : LDA #!controller_Y : STA !bind_disableautoscroll_2+2

    JSR get_input_bindings_checksum
    STA !bind_checksum
.ret
    PLP
    RTS

; calculate checksum and compare against stored checksum to detect corrupt SRAM
bindings_boot_check:
    PHP
    %a16()
    JSR get_input_bindings_checksum
    CMP !bind_checksum
    BEQ .ret
    JSR default_input_bindings ; don't match? must be corrupt, reset to the defaults
    ; note that we can't copy the bindings into WRAM yet since the freespace gets cleared immediately after this
.ret
    PLP
    RTL

; RETURNS: A = checksum of data
get_input_bindings_checksum:
    PHP
    %a16()
    %i8()
assert (!binding_startaddr_sram)%2 == 0, "The bindings block must start on an even address"
    LDA #!binding_startaddr_sram : STA !gsu_r10 ; input: r10 = starting address. MUST be even - if address is odd, the high byte will be located at address-1
    LDA.w #!binding_size_sram : STA !gsu_r12 ; input: r12 = size of data in words (bytes/2)
    LDX.b #<:generic_checksum ; PBR address
    LDA #generic_checksum ; PC address
    JSL r_gsu_init_1
    LDA !gsu_r1 ; outputs: r1 = checksum of data, r0 = $7777 - checksum
.ret
    PLP
    RTS

arch superfx

generic_checksum:
    cache
    iwt r13,#.loop ; start of the loop
    ibt r1,#0
.loop ; loop through and sum each value, improve this if possible
    {
        ldw (r10)
        to r1
        add r1
        inc r10
        loop
    }
    inc r10
    iwt r0,#$7777
    sub r1 ; also store $7777 - checksum in r0
    stop
    nop

arch 65816
