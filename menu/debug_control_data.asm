; data structure for each control as follows:

; [byte] type of control:
; $00: low nibble memory changer
; $02: high nibble memory changer
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
  dw $0040, $0000

; coins
  db $00
  dl $7E037B
  dw $0080, $0000

; red coins
  db $00
  dl $7E03B4
  dw $00C0, $0000

; stars
  db $00
  dl $7E03B6
  dw $0100, $0000

; flowers
  db $00
  dl $7E03B8
  dw $0140, $0000