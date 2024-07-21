lorom

;=================================

org $0080F6
    autoclean JML game_loop

end_frame = $00813A
continue_frame = $008130

freespacebyte $FF
freecode

incsrc "cfg/config.asm" ; include this ASAP so we can use its defines

; 8-bit mode
game_loop:
    PHB : PHK : PLB

; Check if state has been loaded
; Initial value is $02 and does before load preparations
.handle_loadstate
{
    LDA !loaded_state
    BEQ .handle_debug_menu

    DEC A
    STA !loaded_state
    BEQ ..after_load

..before_load
; This part will be run just before entering gamemode 0C
    JMP load_state_before_load

..after_load
; First frame after load complete
    JMP load_state_after_load
}

.handle_debug_menu
{
    LDA !debug_menu
    BEQ .force_hasty
; jump to debug menu processing code
    JMP main_debug_menu
}

.force_hasty ; hacky, just set it every frame
{
    LDA !debug_control_scheme : TSB !s_control_scheme
}

.controller_checks
{
..debug_menu_button
    {
        LDA !controller_data1 : CMP #!controller_data1_L|!controller_data1_R : BNE +
        LDA !controller_data2_press : AND #!controller_data2_start : BEQ +
        JMP init_debug_menu
        +
        LDA !controller_2_data2_press : AND #!controller_data2_start : BEQ +
        JMP init_debug_menu
        +
    }
    JSR check_controllers
    LDA !loaded_state : BNE .skip ; don't run the frame if preparing to load
}

.frame_skip
{
    JMP handle_frame_skip
}

.continue ; game_loop_continue
    PLB
    JML continue_frame
.skip ; game_loop_skip
    PLB
    JML end_frame

; check the custom input bindings:
; loop through the list of bindings we built earlier and stop if we find one that matches the gamepad input
; use the associated control byte as an index into a func pointer table
; repeat for both controllers
check_controllers:
    PHP
    %a16()

.check_controller_1
    LDA !controller_data1 : BEQ .check_controller_2 ; skip if controller 1 has no inputs
    EOR #$FFFF : STA $00 ; else, store the inverted input

    ; loop through the bindings in priority order (right to left)
    LDX #!binding_count
  - {
        LDY !input_bindings_1_offsets,x
        LDA !input_bindings_1+2,y : BEQ + ; if no hold bind, check press
        AND $00 : BNE ++ ; else, if AT LEAST ALL buttons for this bind are held (bind & ~input), check press, else, try next
        +

        LDA !input_bindings_1+4,y : BEQ ++ ; if no press bind, try next
        AND !controller_data1_press : BEQ ++ ; else, if button pressed, run action, else, try next

        LDX !input_bindings_1+0,y ; control byte
        %a8()
        JSR (.pointers,x)
        BRA .ret
    ++
        DEX
        BPL -
    }

.check_controller_2
    LDA !controller_2_data1 : BEQ .ret ; skip if controller 2 has no inputs
    EOR #$FFFF : STA $00 ; else, store the inverted input

    ; loop through the bindings in priority order (right to left)
    LDX #!binding_count
  - {
        LDY !input_bindings_2_offsets,x
        LDA !input_bindings_2+2,y : BEQ + ; if no hold bind, check press
        AND $00 : BNE ++ ; else, if AT LEAST ALL buttons for this bind are held (bind & ~input), check press, else, try next
        +

        LDA !input_bindings_2+4,y : BEQ ++ ; if no press bind, try next
        AND !controller_2_data1_press : BEQ ++ ; else, if button pressed, run action, else, try next

        LDX !input_bindings_2+0,y ; control byte
        %a8()
        JSR (.pointers,x)
        BRA .ret
    ++
        DEX
        BPL -
    }
.ret
    PLP
    RTS
.pointers
    dw save_state
    dw .default_load
    dw .full_load
    dw .room_load
    dw .toggle_music
    dw disable_autoscroll
    dw .toggle_free_movement
    dw .slowdown_dec
    dw .slowdown_inc
.default_load
    STZ !load_mode
    JSR prepare_load
    RTS
.full_load
    LDA #$01 : STA !load_mode
    JSR prepare_load
    RTS
.room_load
    LDA #$02 : STA !load_mode
    JSR prepare_load
    RTS
.toggle_music
    %toggle_byte(!disable_music)
    JSR update_music
    RTS
.toggle_free_movement
    %toggle_byte(!free_movement)
    RTS
.slowdown_dec
    DEC !frame_skip
    BPL +
    STZ !frame_skip
    +
    RTS
.slowdown_inc
    INC !frame_skip
    RTS
