; indexed by control type
debug_control_inits:
  dw init_lownib_memchanger
  dw init_highnib_memchanger
  dw init_toggle_changer
  dw init_egg_changer

; indexed by control type
debug_control_mains:
  dw main_lownib_memchanger
  dw main_highnib_memchanger
  dw main_toggle_changer
  dw main_egg_changer

init_controls:
  REP #$30
  PHD
  ; loop through all controls
  LDY !debug_controls_count*8-8
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
  DEY
  DEY
  DEY
  DEY
  DEY
  DEY
  DEY
  DEY
  BPL .loop

  PLD
  RTS

; handles control processing & focus changes
main_controls:
  PHK
  PLB
  REP #$20
  ; pressing up?
  LDA !controller_data2_press
  AND #%0000000000001000
  BEQ .check_down

  ; cycle up and handle wrapping
  LDA !debug_index
  DEC A
  BPL .store_index_up
  LDA !debug_controls_count-1
.store_index_up
  STA !debug_index
  ; play cursor sound
  LDA #$005C
  STA $0053

.check_down
  LDA !controller_data2_press
  AND #%0000000000000100
  BEQ .process_focused

  ; cycle down and handle wrapping
  LDA !debug_index
  INC A
  CMP !debug_controls_count
  BCC .store_index_down
  LDA #$0000
.store_index_down
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

; sets DP and copies control data bytes into
; this DP range to access these bytes easily
; needs 16-bit m
; parameters:
; y = entry index into debug_menu_controls
copy_control_data_dp:
  ; set DP
  LDA #!debug_base
  TCD

  ; just do 4 LDA/STA's
  LDA debug_menu_controls,y
  STA $00
  LDA debug_menu_controls+2,y
  STA $02
  LDA debug_menu_controls+4,y
  STA $04
  LDA debug_menu_controls+6,y
  STA $06

  RTS
