; indexed by control type
debug_control_inits:
  dw init_lownib_memchanger
  dw init_highnib_memchanger
  dw init_toggle_changer
  dw init_egg_changer
  dw init_call_function
  dw init_warps_function
  dw init_submenu_loader
  dw init_config_changer

; indexed by control type
debug_control_mains:
  dw main_lownib_memchanger
  dw main_highnib_memchanger
  dw main_toggle_changer
  dw main_egg_changer
  dw main_call_function
  dw main_warps_function
  dw main_submenu_loader
  dw main_config_changer

debug_control_cleanups:
  dw cleanup_lownib_memchanger
  dw cleanup_highnib_memchanger
  dw cleanup_toggle_changer
  dw cleanup_egg_changer
  dw cleanup_call_function
  dw cleanup_warps_function
  dw cleanup_submenu_loader
  dw cleanup_config_changer

init_controls:
  PHP
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
  PLP
  RTS

; triggers repeat inputs after initial input + delay if the input is held
; arg0 [word] in $7E0000: input code for controller_data (byetUDLRaxlr----)
; returns zero in $7E0000 if an input should trigger
held_input_repeater:
  PHP
  %a16()

  LDA !controller_data1_press ; pressed for the 1st time? do the initial single move and exit
  AND $0000
  BNE .single_input

  LDA !controller_data1 ; is any button held? if not, reset the delay timer and exit
  BNE +
  LDA !input_repeat_delay_amount : STA !input_repeat_delay_timer
  BRA .ret
+

  LDA !controller_data1 ; is this specific button held? if not, exit
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
  %a16()
  %i8()

  LDX !recording_bind_state : BEQ .check_up
  JMP .process_focused ; if recording input, don't allow moving the cursor

.check_up
  LDA #!controller_up : STA $00
  JSR held_input_repeater
  LDA $00
  BNE .check_down
  ; cycle up and handle wrapping
  LDA !dbc_index_row
  DEC A
  BPL .store_index_row
  LDA !dbc_row_count_current
  DEC A
  BRA .store_index_row
.check_down
  LDA #!controller_down : STA $00
  JSR held_input_repeater
  LDA $00
  BNE .check_left
  ; cycle down and handle wrapping
  LDA !dbc_index_row
  INC A
  CMP !dbc_row_count_current
  BCC .store_index_row
  LDA #$0000
.store_index_row
  STA !dbc_index_row
  JSR get_current_menu_control_col_count ; fetch the col count for the new row
  CMP !dbc_index_col : BCS + ; clamp the colindex to the new colcount
  STA !dbc_index_col
  +
  BRA .index_updated

.check_left
  LDA #!controller_left : STA $00
  JSR held_input_repeater
  LDA $00
  BNE .check_right
  ; cycle left and handle wrapping
  LDA !dbc_index_col
  DEC A
  BPL .store_index_col
  LDA !dbc_col_count_current
  BRA .store_index_col
.check_right
  LDA #!controller_right : STA $00
  JSR held_input_repeater
  LDA $00
  BNE .process_focused
  ; cycle right and handle wrapping
  LDA !dbc_index_col
  INC A
  CMP !dbc_col_count_current
  BCC .store_index_col : BEQ .store_index_col
  LDA #$0000
.store_index_col
  STA !dbc_index_col

.index_updated
  LDA.w #!sfx_move_cursor : STA !sound_immediate
  LDA !debug_base+!dbc_type : AND #$00FF : TAX
  JSR (debug_control_cleanups,x)

.process_focused

  ; clear indicator from previous frame
  ; before copying new data
  JSR clear_position_indicator

  ; set up DP and copy data into DP range
  PHD

  LDA !warps_page_depth_index ; warps page data is handled differently than normal
  BNE +
  {
    JSR get_current_menu_control_offset
    TAY
    JSR get_current_menu_control_col_count
    STA !dbc_col_count_current
+ }

  JSR copy_control_data_dp

  ; set new indicator with new debug_base
  JSR set_position_indicator

  ; if pressing B, try going back instead of running the control func
  LDA !controller_data1_press : AND #!controller_B
  BEQ +
  {
    LDX !recording_bind_state : BNE + ; ignore B when recording
    JSR submenu_go_back
    BRA .ret
+ }

  ; fetch type and call main
  LDX !dbc_type
  JSR (debug_control_mains,x)

.ret
  PLD
  RTS

submenu_go_back:
  PHP
  %a16()

  LDA !warps_page_depth_index
  BEQ +
  { ; if in a warps page, the warps function handles going back
    JSR main_warps_function
    BRA .ret
  + }

  LDA !parent_menu_data_ptr
  BEQ .ret ; if prev menu == zero, we're on top-level main menu
  {
    STA !current_menu_data_ptr
    STZ !dbc_index_row
    STZ !dbc_index_col
    LDA.w #!sfx_move_cursor : STA !sound_immediate
    JSR init_current_menu
  }
.ret
  PLP
  RTS

; returns the offset into the current menu data block for the currently selected option in A
; _not_ adjusted for the metadata block so that we can loop over all controls easily
; and only add the size of the metadata block as the last step
get_current_menu_control_offset:
  PHX
  PHD
  PHP
  %ai16()
  LDX !current_menu_data_ptr
  LDA.w !dbc_meta_colcounts_offset,x ; get the start of the column counts segment
  CLC : ADC !dbc_index_row : ADC !dbc_index_row ; get the specific column count offset
  ADC !current_menu_data_ptr
  TAX
  LDA $0000,x
  AND #$FF00 ; cumulative index is in the high byte
  XBA
  ADC !dbc_index_col ; now offset by which column we're on
  ASL #3 ; each control is 8 bytes wide
.ret
  PLP
  PLD
  PLX
  RTS

; returns the column count for the current row in the current menu in A
get_current_menu_control_col_count:
  PHX
  PHD
  PHP
  %ai16()
  LDX !current_menu_data_ptr
  LDA.w !dbc_meta_colcounts_offset,x ; get the offset of the column count data
  AND #$00FF
  CLC : ADC !dbc_index_row : ADC !dbc_index_row ; add (rowindex*2) to get offset for the specific row
  ADC !current_menu_data_ptr
  TAX
  LDA $0000,x
  AND #$00FF ; column count is in the low byte
.ret
  PLP
  PLD
  PLX
  RTS

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
; y = offset into current menu data for current row (not adjusted for metadata)
copy_control_data_dp:
  REP #$30

  ; set DP
  LDA #!debug_base
  TCD

  LDA !warps_page_depth_index
  BNE .warps_page

.main_page
  TYA
  CLC : ADC !current_menu_data_ptr : ADC #!dbc_meta_size
  TAX
  LDA $0000,x : STA $00
  LDA $0002,x : STA $02
  LDA $0004,x : STA $04
  LDA $0006,x : STA $06
  BRA .ret
.warps_page
  %copy_warpmenu_data()

.ret
  RTS
