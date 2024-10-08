; loop through the list of bindings we built earlier and stop if we find one that matches the gamepad input
; use the associated control byte as an index into a func pointer table
; repeat for both controllers
check_bindings:
    PHP
    %a16()

.check_controller_1
    LDA !controller_data1_press : BEQ .check_controller_2 ; skip if controller 1 has no inputs
    LDA !controller_data1 : EOR #$FFFF : STA $00 ; else, store the inverted input

    ; loop through the bindings in priority order (right to left)
    LDX #!binding_count
  - {
        LDY !input_bindings_1_offsets,x

        LDA !input_bindings_1+4,y : BEQ ++ ; if no press bind, try next
        AND !controller_data1_press : BEQ ++ ; else, if no button pressed, try next, else, check hold

        LDA !input_bindings_1+2,y : BEQ + ; if no hold bind, run action
        AND $00 : BNE ++ ; else, if AT LEAST ALL buttons for this bind are held (bind & ~input), run action, else, try next
        +

        LDX !input_bindings_1+0,y ; control byte
        %a8()
        JSR (.pointers,x)
        BRA .ret
    ++
        DEX
        BPL -
    }

.check_controller_2
    LDA !controller_2_data1_press : BEQ .ret ; skip if controller 2 has no inputs
    LDA !controller_2_data1 : EOR #$FFFF : STA $00 ; else, store the inverted input

    ; loop through the bindings in priority order (right to left)
    LDX #!binding_count
  - {
        LDY !input_bindings_2_offsets,x

        LDA !input_bindings_2+4,y : BEQ ++ ; if no press bind, try next
        AND !controller_2_data1_press : BEQ ++ ; else, if no button pressed, try next, else, check hold

        LDA !input_bindings_2+2,y : BEQ + ; if no hold bind, run action
        AND $00 : BNE ++ ; else, if AT LEAST ALL buttons for this bind are held (bind & ~input), run action, else, try next
        +

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
    JMP game_loop_controller_checks_bindings+3
.pointers
    dw save_state
    dw .default_load
    dw .full_load
    dw rezone
    dw disable_autoscroll
    dw .toggle_free_movement
    dw slowdown_dec
    dw slowdown_inc
    dw frame_advance
.default_load
    STZ !load_mode
    JSR prepare_load
    RTS
.full_load
    LDA #$01 : STA !load_mode
    JSR prepare_load
    RTS
.toggle_free_movement
    %toggle_byte(!free_movement)
    RTS
