draw_eggcount:
  REP #$10
  SEP #$20

  ; read tilemap address
  LDX !dbc_tilemap

  ; read memory address
  LDA [!dbc_memory]
  AND #$0F
  STA !menu_tilemap_mirror,x
  RTS

draw_nib:
  %a8()
  %i16()

  LDX !dbc_tilemap

  ; map stored value to char
  LDA [!dbc_memory] : AND !dbc_wildcard
  LDY !dbc_wildcard : CPY #$000F : BEQ +
  LSR #4
  +
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

draw_config_changer:
  %ai16()

  LDX !dbc_tilemap

  ; clear any existing tile data
  LDA #$003F
  STA !menu_tilemap_mirror+2,x : STA !menu_tilemap_mirror+4,x
  STA !menu_tilemap_mirror+6,x : STA !menu_tilemap_mirror+8,x : STA !menu_tilemap_mirror+10,x

  LDA !recording_bind_state : AND #$00FF : BNE .is_recording

  LDA [!dbc_memory] : BEQ +
  JSR translate_combined_input_code ; held
- {
    LDA $0010,y : STA !menu_tilemap_mirror,x
    INX #2
    DEY #2
    BPL -
  }

  LDA #$0046 : STA !menu_tilemap_mirror,x ; +
  INX #2
  +

  LDY #$0002
  LDA [!dbc_memory],y
  JSR translate_single_input_code : STA !menu_tilemap_mirror,x ; press
  BRA .ret
.is_recording ; draw an ellipsis while recording
  LDA #$0048 : STA !menu_tilemap_mirror,x
.ret
  RTS

; slower than the single bit translator but works for the general case combined codes
; INPUT: A = a 2-byte input code e.g. $00A0 (A+L, $0080 (A) + $0020 (L))
; RETURNS: Y = out array length
; RETURNS: $0010 (!out) = array of 2-byte tilemap entries for font.bin
translate_combined_input_code:
!out = $0010
  PHX
  PHP
  %a16()
  %i8()
  STZ !out
  LDY #$3F : STY !out
  LDY #$00
  CMP #$0000 : BEQ .ret
  LDX #$00
- {
    INX #2
    ASL
    BCC -
    ; carry bit set -> lookup the char and push it to the array, and incr array counter
    PHA
    LDA input_lookup_tbl,x : STA !out,y
    PLA
    BEQ .ret ; jesus wept, for there were no more bits left to conquer
    INY #2
    BRA -
  }
.ret
  PLP
  PLX
  RTS
undef "out"

; INPUT: A = a 2-byte power of 2 input code e.g. $0040 (X)
; RETURNS: A = a 2-byte tilemap entry for a font.bin char e.g. $0021 (X)
translate_single_input_code:
  PHX
  PHP
  %a16()
  %i8()
  ; get position of the set bit, essentially log base2
  ; except we shift left because the rightmost 4 bits of the code are unused
  LDX #$00
- {
    CMP #$0000 : BEQ +
    ASL
    INX #2
    BRA -
  }
  +
  LDA input_lookup_tbl,x
.ret
  PLP
  PLX
  RTS

input_lookup_tbl:
incsrc "../resources/string_font_map.asm"
  db "-", $00
  db "B", $0C, "Y", $08, "s", $00, "S", $00, "^", $00, "v", $00
  db "<", $00, ">", $00, "A", $04, "X", $10, "L", $00, "R", $00

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

; display prev/next eggs to be selected above this egg
draw_egg_selection_helpers:
  PHX
  PHP
  %ai16()

  LDA !dbc_wildcard : ASL : TAX
  LDA !debug_egg_inv_mirror,x
  BEQ .ret ; if it's an empty egg slot, don't show anything

  PHA

  ; if type=1 (chicken), prev slot wraps around to giant green egg
  CMP #$0001
  BNE +
  {
    LDA egg_inv_tilemap_green_giant_egg+2
    BRA ++
+ } 
  { ; else, normal
    ASL #2
    TAY
    LDA egg_inv_tilemap-2,y
++ }
  LDX !dbc_tilemap
  STA !menu_tilemap_mirror-!tilemap_line_width_single-2,x

  ; if type=12 (big green egg), next slot wraps around to chicken
  PLA
  CMP #$000C
  BNE +
  {
    LDA egg_inv_tilemap_huffin_puffin+2
    BRA ++
+ }
  { ; else
      ASL #2
      TAY
      LDA egg_inv_tilemap+6,y
++ }
  LDX !dbc_tilemap
  STA !menu_tilemap_mirror-!tilemap_line_width_single+2,x
.ret
  PLP
  PLX
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
