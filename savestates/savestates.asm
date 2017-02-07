lorom

incsrc savestate_vars.asm

;----------------------

incsrc save_level.asm
incsrc level_load_hijack.asm

;----------------------

org $00815F
    autoclean JML game_loop_hijack

freecode $FF

game_loop_hijack:
; 8-bit mode
; Hijacked right before jumping into game mode
; Current gamemode index is in X, rest of registers are free

    LDA !loaded_state
    BEQ controller_checks

    DEC A
    STA !loaded_state
    BEQ .after_load

.before_load
; This part will be run just before entering gamemode 0C
    JMP load_state_before_load

.after_load
; First frame after load complete
    JMP load_state_after_load

controller_checks:
.load_button
    LDA !controller_data1_press
    AND #$40
    BEQ .save_button
    JMP prepare_load
.save_button
    LDA !controller_data2_press
    AND #$20
    BEQ game_mode_return
    JMP save_state


game_mode_return:
; Setting up gamemode pointer to stack as per original routine
    LDA $00816B,x                             
    PHA                                       
    LDA $00816A,x                             
    PHA   
    RTL



incsrc save_state.asm

incsrc load_state.asm

incsrc routines.asm