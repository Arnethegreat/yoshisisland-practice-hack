; data structure for each control as follows:

; [byte] type of control:
; $00: low nibble memory changer
; $02: high nibble memory changer
; $04: toggle
; $06: egg inventory editor (wildcard as egg number)
!dbc_type = #$00

; [long] memory address to read / write from
!dbc_memory = #$01

; [word] relative tilemap address (offset from start of tilemap mirror)
!dbc_tilemap = #$04

; [word] wildcard
!dbc_wildcard = #$06

!debug_controls_count = #$0005
debug_menu_controls:
; lives
  db $00
  dl $7E0379
  dw $008E, $0000

; coins
  db $02
  dl $7E037B
  dw $010E, $0000

; red coins
  db $04
  dl $7E03B4
  dw $018E, $0000

; stars
  db $00
  dl $7E03B6
  dw $020E, $0000

; flowers
  db $00
  dl $7E03B8
  dw $028E, $0000


; word 1: sprite ID
; word 2: tilemap ID
egg_inv_tilemap:
; no egg
dw $0000, $0039
; boss key
dw $0014, $C03D
; flashing egg
dw $0022, $003A
; red egg
dw $0023, $0C3A
; yellow egg
dw $0024, $083A
; green egg
dw $0025, $043A
; key
dw $0027, $083D
; huffin puffin
dw $0028, $083C
; Red Giant Egg
dw $002A, $0C3B
; Green Giant Egg
dw $002B, $043B