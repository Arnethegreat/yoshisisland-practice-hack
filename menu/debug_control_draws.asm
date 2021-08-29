draw_lownib:
  REP #$30

  ; read tilemap address
  LDX !dbc_tilemap

  ; read memory address
  LDA [!dbc_memory]
  AND #$000F
  STA !menu_tilemap_mirror,x
  RTS


draw_highnib:
  REP #$30

  ; read tilemap address
  LDX !dbc_tilemap

  ; read memory address
  LDA [!dbc_memory]
  AND #$00F0
  LSR
  LSR
  LSR
  LSR
  STA !menu_tilemap_mirror,x
  RTS

draw_toggle:
  REP #$30

  LDX !dbc_tilemap
  LDA [!dbc_memory]
  BEQ .red_color
  LDA #$1428
  BRA .ret
.red_color
  LDA #$1026

.ret
  STA !menu_tilemap_mirror,x
  RTS


draw_egg_changer:
; which egg in inventory
  REP #$30
  LDA !dbc_wildcard
  ASL A
  TAX
  LDA !debug_egg_inv_mirror,x
  ASL A
  ASL A
  TAX
  LDA egg_inv_tilemap+2,x

.ret
  LDX !dbc_tilemap
  STA !menu_tilemap_mirror,x
  RTS


draw_all_egg_changer:
  REP #$30

; Push copy 
  PHD
  LDA $00
  PHA
  LDA $02
  PHA
  LDA $04
  PHA
  LDA $06
  PHA
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
  CMP #$0006
  BNE .no_draw
  JSR draw_egg_changer

.no_draw
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


.ret
; Pull copy
  PLA
  STA $06
  PLA
  STA $04
  PLA
  STA $02
  PLA
  STA $00
  PLD

  RTS


clear_position_indicator:
  REP #$10

  ; load old tilemap
  LDA !debug_base+!dbc_tilemap
  SEC
  SBC #$0040
  TAX
  LDA #$003F
  STA !menu_tilemap_mirror,x

  SEP #$10
.ret
  RTS

set_position_indicator:
  REP #$10

  LDA !dbc_tilemap
  SEC
  SBC #$0040
  TAX
  LDA #$0031
  STA !menu_tilemap_mirror,x

  SEP #$10
.ret
  RTS
