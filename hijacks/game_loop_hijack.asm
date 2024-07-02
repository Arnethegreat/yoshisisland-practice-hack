lorom

;=================================

org $00815F
    autoclean JML game_loop_hijack

freespacebyte $FF
freecode

incsrc "cfg/config.asm" ; include this ASAP so we can use its defines

game_loop_hijack:
; 8-bit mode
; Hijacked right before jumping into game mode
; Current gamemode index is in X, rest of registers are free

; Check if state has been loaded
; Initial value is $02 and does before load preparations
handle_loadstate:
    LDA !loaded_state
    BEQ .next

    DEC A
    STA !loaded_state
    BEQ .after_load

.before_load
; This part will be run just before entering gamemode 0C
    JMP load_state_before_load

.after_load
; First frame after load complete
    JMP load_state_after_load
.next

handle_debug_menu:
    LDA !debug_menu
    BEQ .next
; jump to debug menu processing code
    JMP main_debug_menu
.next

controller_checks:
.debug_menu_button
; Pressing start while holding L & R
    LDA !controller_data1
    AND #$30
    CMP #$30
    BNE ..controller_2
    LDA !controller_data2_press
    AND #$10
    BEQ ..controller_2
    JMP init_debug_menu

    ..controller_2
        LDA !controller_2_data2_press
    ; controller 2 data 2 on press
    ; start
        AND #$10
        BEQ +
        JMP init_debug_menu
    +
    JSR check_controllers

game_mode_return:
; Setting up gamemode pointer to stack as per original routine
    LDA $00816B,x
    PHA
    LDA $00816A,x
    PHA
    RTL

; check the custom input bindings:
; loop through the list of bindings we built earlier and stop if we find one that matches the gamepad input
; use the associated control byte as an index into a func pointer table
; repeat for both controllers
check_controllers:
    PHX
    PHP
    %a16()
    %i8()

.check_controller_1
    LDA !controller_data1 : BEQ .check_controller_2 ; skip if controller 1 has no inputs

    ; loop through the bindings in priority order (right to left)
    LDX #!binding_count
  - {
        LDY !input_bindings_1_offsets,x
        LDA !input_bindings_1+2,y : BEQ + ; if no hold bind, check press
        ORA !input_bindings_1+4,y : CMP !controller_data1 : BNE ++ ; else, if ALL buttons held, check press, else, try next
        +

        LDA !input_bindings_1+4,y : BEQ ++ ; if no press bind, try next
        AND !controller_data1_press : BEQ ++ ; else, if button pressed, run action, else, try next

        LDX !input_bindings_1+0,y ; control byte
        JSR (.pointers,x)
        BRA .ret

    ++
        DEX
        BPL -
    }

.check_controller_2
    LDA !controller_2_data1 : BEQ .ret ; skip if controller 2 has no inputs

    ; loop through the bindings in priority order (right to left)
    LDX #!binding_count
  - {
        LDY !input_bindings_2_offsets,x
        LDA !input_bindings_2+2,y : BEQ + ; if no hold bind, check press
        ORA !input_bindings_2+4,y : CMP !controller_2_data1 : BNE ++ ; else, if ALL buttons held, check press, else, try next
        +

        LDA !input_bindings_2+4,y : BEQ ++ ; if no press bind, try next
        AND !controller_2_data1_press : BEQ ++ ; else, if button pressed, run action, else, try next

        LDX !input_bindings_2+0,y ; control byte
        JSR (.pointers,x)
        BRA .ret

    ++
        DEX
        BPL -
    }
.ret
    PLP
    PLX
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
    %a8()
    STZ !load_mode
    JSR prepare_load
    RTS
.full_load
    %a8()
    LDA #$01 : STA !load_mode
    JSR prepare_load
    RTS
.room_load
    %a8()
    LDA #$02 : STA !load_mode
    JSR prepare_load
    RTS
.toggle_music
    %a8()
    %toggle_byte(!disable_music)
    JSR toggle_music
    RTS
.toggle_free_movement
    %a8()
    %toggle_byte(!free_movement)
    RTS
.slowdown_dec
    %a8()
    DEC !frame_skip
    BPL +
    STZ !frame_skip
    +
    RTS
.slowdown_inc
    %a8()
    INC !frame_skip
    RTS
