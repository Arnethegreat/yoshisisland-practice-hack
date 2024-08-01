org $0080F6
    autoclean JML game_loop

end_frame = $00813A
continue_frame = $008130

freespacebyte $FF
freecode

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
        LDA !controller_data2_press : CMP #!controller_data2_start : BNE +
        JMP init_debug_menu
        +
        LDA !controller_2_data2_press : AND #!controller_data2_start : BEQ +
        JMP init_debug_menu
        +
    }
    JSR check_bindings
    LDA !loaded_state : BNE .skip ; don't run the frame if preparing to load
}

.frame_skip
{
    ; only run the frameskip code if slowdown/frame advanc/load delay is active and we're in-level
    LDA !slowdown_mag : ORA !frame_skip_pause : ORA !load_delay_timer : BEQ .continue
    LDA !gamemode : CMP #!gm_level : BNE .continue
    JMP handle_frame_skip
}

.continue ; game_loop_continue
    PLB
    JML continue_frame
.skip ; game_loop_skip
    PLB
    JML end_frame
