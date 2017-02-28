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
  BEQ .red_color
  ORA #$1400
  BRA .ret
.red_color
  ORA #$1000

.ret
  STA !menu_tilemap_mirror,x
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