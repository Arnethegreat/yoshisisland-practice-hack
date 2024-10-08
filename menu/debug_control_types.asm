; Control type inits
;

init_nib_changer:
  JSR draw_nib
.ret
  RTS

init_eggcount_changer:
  JSR draw_eggcount
.ret
  RTS

init_toggle_changer:
  PHP
  %a8()
  ; reset corrupt toggle values, mostly useful for SRAM
  LDA [!dbc_memory] : BEQ .ret
  CMP !dbc_wildcard : BEQ .ret
  LDA #$00 : STA [!dbc_memory]
.ret
  JSR draw_toggle
  PLP
  RTS

init_egg_changer:
  JSR clean_egg_inv_mirror
  JSR draw_egg_changer
.ret
  RTS

init_call_function:
.ret
  RTS

init_warps_function:
.ret
  RTS

init_submenu_loader:
.ret
  RTS

init_config_changer:
  JSR draw_config_changer
.ret
  RTS

;================================
; Control type cleanups

cleanup_nib_changer:
.ret
  RTS

cleanup_eggcount_changer:
.ret
  RTS

cleanup_toggle_changer:
.ret
  RTS

cleanup_egg_changer:
  PHP
  %ai16()
  ; remove old egg helper tiles
  LDX !debug_base+!dbc_tilemap
  LDA #$003F
  STA !menu_tilemap_mirror-!tilemap_line_width_single-2,x
  STA !menu_tilemap_mirror-!tilemap_line_width_single+2,x
.ret
  PLP
  RTS

cleanup_call_function:
.ret
  RTS

cleanup_warps_function:
.ret
  RTS

cleanup_submenu_loader:
.ret
  RTS

cleanup_config_changer:
.ret
  RTS

;================================
; Control type main routines

main_nib_changer:
!active_nib = $0000
!inactive_nib = $0002
  PHP
  %a8()
  %i16()

; pressing A?
.check_increment
  LDX #!controller_A : STX $0000
  JSR held_input_repeater
  LDX $0000 : BNE .check_decrement

  ; split the nibbles
  LDA !dbc_wildcard : AND [!dbc_memory] : STA !active_nib
  LDA !dbc_wildcard : EOR #$FF : AND [!dbc_memory] : STA !inactive_nib

  ; if the original nibble was at the max (F- or -F) then set it to zero
  LDA !active_nib : CMP !dbc_wildcard : BNE +
  STZ !active_nib
  BRA ++
+
  ; else, increment nibble
  LDA #$11 : AND !dbc_wildcard ; 01 or 10
  CLC : ADC !active_nib
  STA !active_nib
++

  ; combine the nibbles back together and store
  LDA !active_nib : ORA !inactive_nib : STA [!dbc_memory]
  LDA #!sfx_shell_07
  BRA .update_draw

; pressing Y?
.check_decrement
  LDX #!controller_Y : STX $0000
  JSR held_input_repeater
  LDX $0000 : BNE .ret

  ; split the nibbles
  LDA !dbc_wildcard : AND [!dbc_memory] : STA !active_nib
  LDA !dbc_wildcard : EOR #$FF : AND [!dbc_memory] : STA !inactive_nib

  ; if the original nibble was at zero then set it to the wildcard (max)
  LDA !active_nib : AND !dbc_wildcard : BNE +
  ORA !dbc_wildcard : STA !active_nib
  BRA ++
+
  ; else, decrement nibble (by adding a negative)
  LDA #$FF : AND !dbc_wildcard ; 0F or F0
  CLC : ADC !active_nib
  AND !dbc_wildcard ; if it's the lower nib, need to mask anything that overflowed to the high nib
  STA !active_nib
++

  ; combine the nibbles back together and store
  LDA !active_nib : ORA !inactive_nib : STA [!dbc_memory]
  LDA #!sfx_shell_06

.update_draw
  STA !sound_immediate
  JSR draw_nib

.ret
  PLP
  RTS
undef "active_nib"
undef "inactive_nib"

;================================

main_eggcount_changer:
  PHP
  %a8()
  %i16()

; pressing A?
.check_increment
  LDX #!controller_A : STX $0000
  JSR held_input_repeater
  LDX $0000 : BNE .check_decrement

  ; if at max, no increment
  LDA [!dbc_memory] : CMP #$06 : BCS .ret
  INC : STA [!dbc_memory]
  LDA #!sfx_shell_07
  BRA .update_draw

; pressing Y?
.check_decrement
  LDX #!controller_Y : STX $0000
  JSR held_input_repeater
  LDX $0000 : BNE .ret

  ; if at zero, no decrement
  LDA [!dbc_memory] : BEQ .ret
  DEC : STA [!dbc_memory]
  LDA #!sfx_shell_06

.update_draw
  STA !sound_immediate
  JSR draw_eggcount
  JSR clean_egg_inv_mirror
  JSR draw_all_egg_changer
.ret
  PLP
  RTS

;================================

main_toggle_changer:
  SEP #$30

  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret

  LDA [!dbc_memory]
  BEQ .set
  LDA #$00
  BRA .reset
.set
  AND !dbc_wildcard
  EOR !dbc_wildcard
.reset
  STA [!dbc_memory]
  LDA #!sfx_key_chink : STA !sound_immediate
  JSR draw_toggle
  LDA !dbc_memory : CMP #!disable_music : BNE +
  JSR update_music ; if toggling disable music through the menu, send an update
  +

.ret
  RTS

;================================

main_egg_changer:
  SEP #$20

  JSR draw_egg_selection_helpers ; this runs every frame in order to trigger on initial select, not ideal

  ; egg inventory number
  LDA !dbc_wildcard
  ASL A
  TAX

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #!controller_data1_A
  BEQ .check_decrement

; wrap from 1-12
  LDA !debug_egg_inv_mirror,x
  INC A
  CMP #$0D
  BCC .inc
  LDA #$01

.inc
  STA !debug_egg_inv_mirror,x
  LDA #!sfx_collect_egg
  BRA .update_draw

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #!controller_data2_Y
  BEQ .ret

  LDA !debug_egg_inv_mirror,x
  DEC A
  BNE .dec
  LDA #$0C

.dec
  STA !debug_egg_inv_mirror,x
  LDA #!sfx_collect_egg

.update_draw
  STA !sound_immediate
  JSR clean_egg_inv_mirror
  JSR draw_egg_changer

.ret
  RTS

;================================

main_call_function:
  SEP #$30
  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret

  LDA !dbc_wildcard
  ASL A
  TAX
  JSR (control_function_calls,x)
  LDA #!sfx_midway_tape : STA !sound_immediate

.ret
  RTS

;================================

main_warps_function:
  SEP #$30
  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret
  LDA !controller_data2_press ; if just B, go back
  AND #!controller_data2_B
  BEQ +
  LDX #$00 ; set X to zero to indicate that we want to go back
  BRA ++
+
  LDA !dbc_wildcard
  TAX
++
  JSR warp_menu
.ret
  RTS

;================================

main_submenu_loader:
  %ai8()
  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #!controller_data1_A|!controller_data1_X
  BEQ .ret
  { ; load submenu
    %a16()
    LDA.w #!sfx_move_cursor : STA !sound_immediate
    LDA !dbc_wildcard
    BNE +
    { ; wildcard == zero means back
      JSR pop_cursor_stack
      LDA !parent_menu_data_ptr
      BRA ++
  + }
    { ; else, loading a child submenu
      JSR push_cursor_stack
    }
    ++
    STA !current_menu_data_ptr
    JSR init_current_menu
  }
.ret
  RTS

;================================

!temp_sound = $002E
main_config_changer:
  %a16()
  %i8()
  LDX !recording_bind_state : BNE .is_recording

.not_recording
  LDA !controller_data1_press : CMP #!controller_X : BNE + ; press X to clear a binding
  LDY #$02
  LDA #$0000 : STA [!dbc_memory] : STA [!dbc_memory],y
  JSR get_input_bindings_checksum : STA !bind_checksum
  LDY #$00 : STY !prep_binds_flag
  JSR draw_config_changer
  LDA.w #!sfx_poof : STA !temp_sound
  BRA .play_sound
  +

  AND #!controller_A|!controller_Y : BEQ .ret ; press A/Y to start recording
  INC !recording_bind_state
  STZ !recording_held_value
  STZ !recording_pressed_value
  LDY #$00 : STY !recording_btn_count
  JSR draw_config_changer
  LDA.w #!sfx_correct : STA !temp_sound
  BRA .play_sound

.is_recording
  LDA !recording_bind_state : DEC : ASL : TAX
  JSR (.recording_ptrs,x) : BNE .ret ; if Y=0, we're done
  JSR init_controls ; re-draw all controls in case a dupe was overwritten, kinda hacky, sorry :\

.play_sound
  LDA !temp_sound : STA !sound_immediate
.ret
  RTS
.recording_ptrs
  dw handle_recording_start
  dw handle_recording_preloop
  dw handle_recording_mainloop
  dw handle_recording_done

; wait for an input to begin on controller 1
; record each new press sequentially until the input stops (becomes zero)
; RETURNS: Y = state
handle_recording_start:
  LDA !controller_data1 : BNE .ret ; wait for inputs to stop
  INC !recording_bind_state ; advance state
.ret
  LDY !recording_bind_state
  RTS

handle_recording_preloop:
  LDA !controller_data1 : BEQ .ret ; wait for inputs to start
  STA !recording_pressed_value ; store the first input
  INC !recording_bind_state ; advance state
.ret
  LDY !recording_bind_state
  RTS

handle_recording_mainloop:
  LDA !controller_data1 : BNE + ; wait for inputs to stop
  INC !recording_bind_state : BRA .ret ; advance state
  +
  LDA !controller_data1_press : BEQ .ret ; wait for a new input

  ; this routine requires inputs to be sequential, it breaks if the user presses multiple buttons on the same frame
  ; so if we detect a multi-button press, stop recording and let them try again
  DEC : AND !controller_data1_press : BEQ + ; check by unsetting the leftmost bit (x & (x-1))
  LDY #$00 : STY !recording_bind_state
  LDA.w #!sfx_incorrect : STA !temp_sound
  BRA .ret
  +

  ; merge previous press into held and then store the new input in press
  ; this means pressed will always hold the latest input, and everything else is in held
  LDA !recording_pressed_value : ORA !recording_held_value : STA !recording_held_value
  LDA !controller_data1_press : STA !recording_pressed_value

  ; limit number of buttons to something sensible
  INC !recording_btn_count
  LDY !recording_btn_count : CPY #$03 : BCC .ret
  INC !recording_bind_state
.ret
  LDY !recording_bind_state
  RTS

handle_recording_done:
  ; if an identical bind for this controller already exists, remove it to avoid collisions
  LDA !dbc_wildcard ; controller number in wildcard
  ASL #2
  CLC : ADC.w #!binding_size_sram-8
  TAX ; X=index into SRAM block
- {
    LDA !binding_startaddr_sram+2,x : CMP !recording_pressed_value : BNE +
    ; press bind match found, check the corresponding hold bind
    LDA !binding_startaddr_sram+0,x : CMP !recording_held_value : BNE +
    ; hold bind also matches, clear them both and break out of the loop
    LDA #$0000 : STA !binding_startaddr_sram+0,x : STA !binding_startaddr_sram+2,x
    BRA ++
    +
    TXA : SEC : SBC #$0008 : TAX
    BPL -
  }
++
  ; store SRAM, calculate a new checksum, reset recording state, and set the prep flag
  LDA !recording_held_value : STA [!dbc_memory]
  LDY #$02
  LDA !recording_pressed_value : STA [!dbc_memory],y
  JSR get_input_bindings_checksum : STA !bind_checksum
  LDY #$00 : STY !prep_binds_flag : STY !recording_bind_state
  LDA.w #!sfx_correct : STA !temp_sound
.ret
  LDY !recording_bind_state
  RTS
undef "temp_sound"

set_default_input_bindings_and_draw:
    JSR default_input_bindings
    STZ !prep_binds_flag
    JSR init_controls ; re-draw
    RTS
