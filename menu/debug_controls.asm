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
  LDA !debug_controls_count_current
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
; arg0 [word] in $7E0000: input code for controller_data2
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
  LDA !debug_index
  DEC A
  BPL .store_index
  LDA !debug_controls_count_current
  DEC A
  BRA .store_index

.check_down
  LDA #%0000000000000100 : STA $0000
  JSR held_input_repeater
  LDA $0000
  BNE .process_focused
  ; cycle down and handle wrapping
  LDA !debug_index
  INC A
  CMP !debug_controls_count_current
  BCC .store_index
  LDA #$0000

.store_index
  STA !debug_index
  ; play cursor sound
  LDA #$005C
  STA $0053

.process_focused

  ; clear indicator from previous frame
  ; before copying new data
  JSR clear_position_indicator

  ; set up DP and copy data into DP range
  PHD
  LDA !debug_index
  ASL
  ASL
  ASL
  TAY
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

; loads the currently selected option data
; the wildcard and tilemap address are the only things we need to adjust based on y
macro copy_warpmenu_data()
  LDA #$A00A : STA $00 ; CONTROL TYPE (lo byte)
  LDA #$7E14 : STA $02 ; ADDRESS FOR R/W (top 2 bytes of the long?)
  
  ; adjust the tilemap address based on index in y
  TYA
  LSR #3
  TAX
  STX $06 ; WILDCARD (yeehaw)
  
  LDA #!first_option_tilemap_dest
  -
    CPX #$0000
    BEQ .break
    CLC
    ADC #!tilemap_line_width
    DEX
    BRA -

.break
  STA $04 ; RELATIVE TILEMAP ADDRESS
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
