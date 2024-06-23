; indexed by control type
debug_control_inits:
  dw init_lownib_memchanger
  dw init_highnib_memchanger
  dw init_toggle_changer
  dw init_egg_changer
  dw init_call_function
  dw init_warps_function

; indexed by control type
debug_control_mains:
  dw main_lownib_memchanger
  dw main_highnib_memchanger
  dw main_toggle_changer
  dw main_egg_changer
  dw main_call_function
  dw main_warps_function

init_controls:
  REP #$30
  PHD
  ; loop through all controls
  LDA !dbc_count_current
  ASL #3
  SEC
  SBC #$0008
  TAY
.loop
  PHY
  ; set up DP and copy data into DP
  JSR copy_control_data_dp

  ; fetch type and call init
  LDA !dbc_type
  AND #$00FF
  TAX
  JSR (debug_control_inits,x)

  PLY
  DEY #8
  BPL .loop

  PLD
  RTS

; triggers repeat inputs after initial input + delay if the input is held
; arg0 [word] in $7E0000: input code for controller_data2 (byetUDLR)
; returns zero in $7E0000 if an input should trigger
held_input_repeater:
  PHP
  REP #$20

  LDA !controller_data2_press ; pressed for the 1st time? do the initial single move and exit
  AND $0000
  BNE .single_input

  LDA !controller_data2 ; is any button held? if not, reset the delay timer and exit
  BNE +
  LDA !input_repeat_delay_amount : STA !input_repeat_delay_timer
  BRA .ret
+

  LDA !controller_data2 ; is this specific button held? if not, exit
  AND $0000
  BEQ .ret
  LDA !input_repeat_delay_timer ; has the delay timer expired? if yes, do repeat inputs
  BEQ .repeat_input
  DEC !input_repeat_delay_timer ; else, decrement the delay timer and exit
  BRA .ret

.repeat_input
  LDA !frame_counter
  AND #$0003 ; repeat every 4 frames
  BNE .ret

.single_input
  STZ $0000
.ret
  PLP
  RTS

; handles control processing & focus changes
main_controls:
  PHK
  PLB
  REP #$20

.check_up
  LDA #%0000000000001000 : STA $0000
  JSR held_input_repeater
  LDA $0000
  BNE .check_down
  ; cycle up and handle wrapping
  LDA !dbc_index_row
  DEC A
  BPL .store_index_row
  LDA !dbc_row_count_current
  DEC A
  BRA .store_index_row
.check_down
  LDA #%0000000000000100 : STA $0000
  JSR held_input_repeater
  LDA $0000
  BNE .check_left
  ; cycle down and handle wrapping
  LDA !dbc_index_row
  INC A
  CMP !dbc_row_count_current
  BCC .store_index_row
  LDA #$0000
.store_index_row
  STA !dbc_index_row
  STZ !dbc_index_col ; reset the column when moving up/down
  BRA .play_sound

.check_left
  LDA #%0000000000000010 : STA $0000
  JSR held_input_repeater
  LDA $0000
  BNE .check_right
  ; cycle left and handle wrapping
  LDA !dbc_index_col
  DEC A
  BPL .store_index_col
  LDA !dbc_col_count_current
  DEC A
  BRA .store_index_col
.check_right
  LDA #%0000000000000001 : STA $0000
  JSR held_input_repeater
  LDA $0000
  BNE .process_focused
  ; cycle right and handle wrapping
  LDA !dbc_index_col
  INC A
  CMP !dbc_col_count_current
  BCC .store_index_col
  LDA #$0000
.store_index_col
  STA !dbc_index_col

.play_sound
  LDA #$005C
  STA $0053

.process_focused

  ; clear indicator from previous frame
  ; before copying new data
  JSR clear_position_indicator

  ; set up DP and copy data into DP range
  PHD

  LDA !warps_page_depth_index ; warps page data is handled differently than normal
  BNE +
  JSR get_main_menu_control_offset
  TAY
  JSR get_main_menu_control_col_count
  STA !dbc_col_count_current
  +

  JSR copy_control_data_dp

  ; set new indicator with new debug_base
  JSR set_position_indicator

  ; fetch type and call main
  LDA !dbc_type
  AND #$00FF
  TAX
  JSR (debug_control_mains,x)

.ret
  PLD
  RTS

macro copy_data(controls)
  ; just do 4 LDA/STA's
  LDA <controls>+0,y : STA $00
  LDA <controls>+2,y : STA $02
  LDA <controls>+4,y : STA $04
  LDA <controls>+6,y : STA $06
endmacro

; loads the currently selected warp option data
; the wildcard and tilemap offset are the only things that matter
macro copy_warpmenu_data()
  LDA.w #!ct_warps : STA !dbc_type
  
  ; store the current selection index in the wildcard
  LDA !dbc_index_row
  TAX
  STX !dbc_wildcard

  ; adjust the tilemap offset based on index
  LDA #!first_option_tilemap_dest
  -
    CPX #$0000
    BEQ .break
    CLC
    ADC #!tilemap_line_width
    DEX
    BRA -

.break
  STA !dbc_tilemap
endmacro

; sets DP and copies control data bytes into
; this DP range to access these bytes easily
; needs 16-bit m
; parameters:
; y = entry index into debug_menu_controls
copy_control_data_dp:
  REP #$30

  ; set DP
  LDA #!debug_base
  TCD

  LDA !warps_page_depth_index
  BNE .warps_page

.main_page
  %copy_data(debug_menu_controls)
  BRA .ret
.warps_page
  %copy_warpmenu_data()

.ret
  RTS
