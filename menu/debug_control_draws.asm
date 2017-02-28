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
  ORA #$1400
  BRA .ret
.red_color
  ORA #$1000

.ret
  STA !menu_tilemap_mirror,x
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
