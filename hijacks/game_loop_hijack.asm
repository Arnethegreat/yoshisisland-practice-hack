lorom

;=================================

org $00815F
    autoclean JML game_loop_hijack

freecode $FF

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


handle_music_toggle:
    LDA !disable_music
    BEQ controller_checks
; send music off command each frame (ugly)
    LDA #$F0
    STA $4D

controller_checks:
.load_button
    LDA !controller_data1_press
; X-button
    AND #$40
    BEQ .save_button
    JMP prepare_load

.save_button
    LDA !controller_data2_press
; select
    AND #$20
    BEQ .disable_music
    JMP save_state

.disable_music
; controller 2 data 2 on press
    LDA $0943
    AND #$20
    BEQ game_mode_return
; toggle music
    JSR toggle_music


game_mode_return:
; Setting up gamemode pointer to stack as per original routine
    LDA $00816B,x                             
    PHA                                       
    LDA $00816A,x                             
    PHA   
    RTL
