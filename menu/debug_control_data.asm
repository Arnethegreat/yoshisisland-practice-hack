; data structure for each control as follows:

; [byte] type of control:
; $00: low nibble memory changer (wildcard $xxyy xx = min, yy = max)
; $02: high nibble memory changer (wildcard $xxyy xx = min, yy = max)
; $04: toggle (wildcard as value for enable)
; $06: egg inventory editor (wildcard as egg number)
; $08: call function (wildcard as what function)
; $0A: warp navigation (wildcard as index)
!dbc_type = $00

; [long] memory address to read / write from - currently only used for [lownib, highnib, toggle]
!dbc_memory = $01

; [word] relative tilemap address (offset from start of tilemap mirror)
!dbc_tilemap = $04

; [word] wildcard
!dbc_wildcard = $06

debug_menu_controls:
; DISABLE AUTOSCROLL
  db $08
  dl $7E14A0
  dw $00C2, $0000

; WARP MENU
  db $0A
  dl $7E14A0
  dw $0142, $0001

; MUSIC DISABLE
  db $08
  dl $7E14A0
  dw $01C2, $0001

; FREE MOVEMENT
  db $04
  dl $7E10DA
  dw $0242, $0001

; Egg count
  db $00
  dl $7E0000+!debug_egg_count_mirror
  dw $02C2, $0006

; egg 1
  db $06
  dl $7E0379
  dw $02C6, $0000

; egg 2
  db $06
  dl $7E037B
  dw $02C8, $0001

; egg 3
  db $06
  dl $7E03B4
  dw $02CA, $0002

; egg 4 
  db $06
  dl $7E03B6
  dw $02CC, $0003

; egg 5
  db $06
  dl $7E03B8
  dw $02CE, $0004

; egg 6
  db $06
  dl $7E03B8
  dw $02D0, $0005

; SLOW DOWN AMOUNT high
  db $02
  dl $7E012F
  dw $0342, $00F0

; SLOW DOWN AMOUNT low
  db $00
  dl $7E012F
  dw $0344, $000F

; FULL LOAD AS DEFAULT
  db $04
  dl !full_load_default
  dw $03C2, $0021

; SET TUTORIAL FLAGS
  db $04
  dl $7E0372
  dw $0442, $00E0

; DISABLE KAMEK AT BOSS
  db $04
  dl !skip_kamek
  dw $04C2, $0001

; HUD
  db $04
  dl $7E0000+!hud_enabled
  dw $0542, $0001

; LOAD DELAY AMOUNT high
  db $02
  dl !load_delay_timer_init
  dw $05C2, $00F0

; LOAD DELAY AMOUNT low
  db $00
  dl !load_delay_timer_init
  dw $05C4, $000F

!first_option_tilemap_dest = $00C2
!tilemap_line_width = $0080


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

; indexed by wilcard for control type $08
control_function_calls:
  dw disable_autoscroll
  dw toggle_music

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
