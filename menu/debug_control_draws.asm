draw_lownib:
  REP #$10
  SEP #$20

  ; read tilemap address
  LDX !dbc_tilemap

  ; read memory address
  LDA [!dbc_memory]
  AND #$0F
  STA !menu_tilemap_mirror,x
  RTS


draw_highnib:
  REP #$10
  SEP #$20

  ; read tilemap address
  LDX !dbc_tilemap

  ; read memory address
  LDA [!dbc_memory]
  AND #$F0
  LSR #4
  STA !menu_tilemap_mirror,x
  RTS

draw_toggle:
  REP #$30

  LDX !dbc_tilemap
  LDA [!dbc_memory]
  AND #$00FF
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
  PHP
  %ai16()

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
  CMP.w #!ct_egg
  BNE .no_draw
  JSR draw_egg_changer

.no_draw
  PLY
  DEY #8
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
  PLP
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
  JSR reset_selected_option_palette
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
  JSR set_selected_option_palette
.ret
  RTS


set_selected_option_palette: ; set palette for selected option tilemap row
  PHP
  REP #$30
  LDA !dbc_tilemap
  AND #$FFC0 ; set to start of line, which start at 00, 40, 80, or C0
  TAX
  SEP #$20
  LDY #!tilemap_line_width
-
  LDA !menu_tilemap_mirror+1,x
  BNE +
  LDA #%00111100 ; $3C = palette index 7 (from menu_palette.highlight_text) with priority bit set
  STA !menu_tilemap_mirror+1,x
+
  INX
  INX
  DEY
  DEY
  BNE -
  PLP
  RTS

reset_selected_option_palette: ; reset palette for prev selected option tilemap
  PHP
  REP #$30
  LDA !debug_base+!dbc_tilemap
  AND #$FFC0
  TAX
  SEP #$20
  LDY #!tilemap_line_width
-
  LDA !menu_tilemap_mirror+1,x
  CMP #$3C
  BNE +
  LDA #$00
  STA !menu_tilemap_mirror+1,x
+
  INX
  INX
  DEY
  DEY
  BNE -
  PLP
  RTS
