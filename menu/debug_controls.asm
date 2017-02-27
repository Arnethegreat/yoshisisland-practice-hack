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
  ; set up base ROM address for control
  TYA
  CLC
  ADC #debug_menu_controls
  STA !debug_base

  ; set up DP as base RAM address
  LDA #!debug_base
  PHA
  PLD

  ; set up long memory address into dp range
  LDY #$0001
  LDA (!debug_base_dp),y
  STA $02
  LDY #$0002
  LDA (!debug_base_dp),y
  STA $03

  ; fetch type and call init
  LDA (!debug_base_dp)
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

.process_focused
  
  ; clear indicator from previous frame
  ; before setting new debug_base
  JSR clear_position_indicator

  ; set up base ROM address for control
  LDA !debug_index
  ASL
  ASL
  ASL
  CLC
  ADC #debug_menu_controls
  STA !debug_base

  ; set up DP as base RAM address
  PHD
  LDA #!debug_base
  PHA
  PLD

  ; set new indicator with new debug_base
  JSR set_position_indicator

  ; set up long memory address into dp range
  LDY !dbc_memory
  LDA (!debug_base_dp),y
  STA $02
  LDY !dbc_memory+1
  LDA (!debug_base_dp),y
  STA $03

  ; fetch type and call main
  LDA (!debug_base_dp)
  AND #$00FF
  TAX
  JSR (debug_control_mains,x)

.ret
  PLD
  RTS


draw_lownib:
  REP #$30

  ; read tilemap address
  LDY #$0004
  LDA (!debug_base_dp),y
  TAX

  ; read memory address
  LDA [!debug_memoryaddr_dp]
  AND #$000F
  STA !menu_tilemap_mirror,x
  RTS


draw_highnib:
  REP #$30

  ; read tilemap address
  LDY #$0004
  LDA (!debug_base_dp),y
  TAX

  ; read memory address
  LDA [!debug_memoryaddr_dp]
  AND #$00F0
  LSR
  LSR
  LSR
  LSR
  STA !menu_tilemap_mirror,x
  RTS

draw_toggle:
  REP #$30

  LDY #$0004
  LDA (!debug_base_dp),y
  TAX

  LDA [!debug_memoryaddr_dp]
  STA !menu_tilemap_mirror,x

.ret
  RTS


clear_position_indicator:
  PHD
  LDA #!debug_base
  TCD

  REP #$10

  LDY #$0004
  LDA (!debug_base_dp),y
  SEC
  SBC #$0040
  TAX
  LDA #$003F
  STA !menu_tilemap_mirror,x

  SEP #$10
.ret
  PLD
  RTS

set_position_indicator:
  REP #$10

  LDY #$0004
  LDA (!debug_base_dp),y
  SEC
  SBC #$0040
  TAX
  LDA #$0031
  STA !menu_tilemap_mirror,x

  SEP #$10
.ret
  RTS