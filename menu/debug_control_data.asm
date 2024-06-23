; data structure for each control as follows:

; [byte] type of control:
!dbc_type = $00
!ct_lonib = $00 ; low nibble memory changer (wildcard $xxyy xx = min, yy = max)
!ct_hinib = $02 ; high nibble memory changer (wildcard $xxyy xx = min, yy = max)
!ct_toggle = $04 ; toggle (wildcard as value for enable)
!ct_egg = $06 ; egg inventory editor (wildcard as egg number)
!ct_func = $08 ; call function (wildcard as what function)
!ct_warps = $0A ; warp navigation (wildcard as index)

; [long] memory address to read / write from - currently only used for [lownib, highnib, toggle]
!dbc_memory = $01

; [word] relative tilemap address (offset from start of tilemap mirror)
!dbc_tilemap = $04

; [word] wildcard
!dbc_wildcard = $06

macro define_menu_entry(type, addr, xpos, ypos, wildcard)
  db <type>
  dl <addr>
  dw <ypos>*!tilemap_line_width+<xpos>*2+$40
  dw <wildcard>
endmacro

; the control data is row-major and 8-byte-aligned
; to retrieve specific control data, simply do (cumulative row offset + column offset) * 8
; returns the offset into debug_menu_controls in A
get_main_menu_control_offset:
  PHX
  PHD
  PHP
  %ai16()
  LDX !dbc_index_row
  LDA debug_menu_controls_row_offsets,x
  AND #$00FF
  CLC
  ADC !dbc_index_col
  ASL #3
.ret
  PLP
  PLD
  PLX
  RTS

; returns the column count for the current row in A
get_main_menu_control_col_count:
  PHX
  LDX !dbc_index_row
  LDA debug_menu_controls_row_column_counts,x
  AND #$00FF
.ret
  PLX
  RTS

debug_menu_controls:
  %define_menu_entry(!ct_func, $7E0000, 1, 1, $0000) ; disable autoscroll
  %define_menu_entry(!ct_warps, $7E0000, 1, 2, $0001) ; warp menu
  %define_menu_entry(!ct_toggle, !disable_music, 1, 3, $0001) ; disable music
  %define_menu_entry(!ct_toggle, $7E0000+!free_movement, 1, 4, $0001) ; free movement
  %define_menu_entry(!ct_lonib, $7E0000+!debug_egg_count_mirror, 1, 5, $0006) ; egg count
  %define_menu_entry(!ct_egg, $7E0000, 3, 5, $0000) ; egg 1
  %define_menu_entry(!ct_egg, $7E0000, 4, 5, $0001) ; egg 2
  %define_menu_entry(!ct_egg, $7E0000, 5, 5, $0002) ; egg 3
  %define_menu_entry(!ct_egg, $7E0000, 6, 5, $0003) ; egg 4
  %define_menu_entry(!ct_egg, $7E0000, 7, 5, $0004) ; egg 5
  %define_menu_entry(!ct_egg, $7E0000, 8, 5, $0005) ; egg 6
  %define_menu_entry(!ct_hinib, $7E012F, 1, 6, $00F0) ; slowdown amount high
  %define_menu_entry(!ct_lonib, $7E012F, 2, 6, $000F) ; slowdown amount low
  %define_menu_entry(!ct_toggle, !full_load_default, 1, 7, $0021) ; full load as default
  %define_menu_entry(!ct_toggle, $7E0372, 1, 8, $00E0) ; set tutorial flags
  %define_menu_entry(!ct_toggle, !skip_kamek, 1, 9, $0001) ; disable kamek at boss
  %define_menu_entry(!ct_toggle, $7E0000+!hud_enabled, 1, 10, $0001) ; HUD
  %define_menu_entry(!ct_hinib, !load_delay_timer_init, 1, 11, $00F0) ; load delay amount high
  %define_menu_entry(!ct_lonib, !load_delay_timer_init, 2, 11, $000F) ; load delay amount low
.row_column_counts
  db $01, $01, $01, $01, $07, $02, $01, $01, $01, $01, $02
.row_offsets
  db $00, $01, $02, $03, $04, $0B, $0D, $0E, $0F, $10, $11


; each control is the same, so just store a count for each page (max = $0B)
!debug_menu_controls_warps_worlds_count = #$0007
!debug_menu_controls_warps_levels_count = #$000A
debug_menu_controls_warps_room_counts:
  db $02, $03, $05, $06, $01, $08, $03, $06, $01 ; world 1
  db $05, $03, $03, $0A, $06, $06, $08, $0B, $02 ; world 2
  db $04, $03, $06, $0B, $04, $04, $06, $05, $02 ; world 3
  db $05, $06, $03, $0B, $03, $06, $03, $08, $09 ; world 4
  db $05, $04, $08, $08, $04, $03, $04, $07, $05 ; world 5
  db $04, $03, $03, $06, $03, $06, $05, $09, $07 ; world 6


;======================================

; indexed by wilcard for control type !ct_func
control_function_calls:
  dw disable_autoscroll

;======================================

; word 1: sprite ID
; word 2: tilemap ID
egg_inv_tilemap:
; no egg
dw $0000, $0039
; huffin puffin
dw $0028, $083C
; flashing egg
dw $0022, $003A
; red egg
dw $0023, $0C3A
; yellow egg
dw $0024, $083A
; green egg
dw $0025, $043A
; Skull Mouser
dw $01A3, $1843
; See-saw Log
dw $007F, $0844
; Boss Explosion
dw $0013, $0845
; boss key
dw $0014, $C03D
; key
dw $0027, $083D
; Red Giant Egg
dw $002A, $0C3B
; Green Giant Egg
dw $002B, $043B
; Unknown
dw $000D, $0026

!egg_inv_tilemap_count = datasize(egg_inv_tilemap)/4 ; bytes -> index
