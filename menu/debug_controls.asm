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

!debug_controls_count = #$0002
debug_menu_controls:
; lives
  db $00
  dl $7E0379
  dw $0050, $0000

; coins
  db $00
  dl $7E037B
  dw $0090, $0000

; indexed by control type
debug_control_inits:
  dw init_lownib_memchanger
  dw init_highnib_memchanger

; indexed by control type
debug_control_mains:
  dw main_lownib_memchanger
  dw main_highnib_memchanger

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
  INC A
  CMP !debug_controls_count
  BCC .store_index_up
  LDA #$0000
.store_index_up
  STA !debug_index

.check_down
  LDA !controller_data2_press
  AND #%0000000000000100
  BEQ .process_focused

  ; cycle down and handle wrapping
  LDA !debug_index
  DEC A
  BPL .store_index_down
  LDA !debug_controls_count-1
.store_index_down
  STA !debug_index

.process_focused
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

  ; fetch type and call main
  LDA ($00)
  AND #$00FF
  TAX
  JSR (debug_control_mains,x)

.ret
  PLD
  RTS

init_lownib_memchanger:
  RTS

main_lownib_memchanger:
  SEP #$20

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #%10000000
  BEQ .check_decrement

  ; set up memory address to read from
  REP #$20
  LDY !dbc_memory
  LDA ($00),y
  STA $02
  LDY !dbc_memory+1
  LDA ($00),y
  STA $03
  SEP #$20

  ; increment only low nibble
  LDA [$02]
  STA $0000
  INC A
  AND #$0F
  STA $0002
  LDA $0000
  AND #$F0
  ORA $0002
  STA [$02]

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #%01000000
  BEQ .ret

  ; set up memory address to read from
  REP #$20
  LDY !dbc_memory
  LDA ($00),y
  STA $02
  LDY !dbc_memory+1
  LDA ($00),y
  STA $03
  SEP #$20

  ; decrement only low nibble
  LDA [$02]
  STA $0000
  DEC A
  AND #$0F
  STA $0002
  LDA $0000
  AND #$F0
  ORA $0002
  STA [$02]

.ret
  JSR draw_lownib
  RTS

draw_lownib:
  REP #$30

  ; read tilemap address
  LDY #$0004
  LDA ($00),y
  TAX

  ; read memory address
  LDY #$0001
  LDA ($00),y
  STA $02
  LDY #$0002
  LDA ($00),y
  STA $03
  LDA [$02]
  AND #$000F
  STA !menu_tilemap_mirror,x
  RTS

init_highnib_memchanger:
  RTS

main_highnib_memchanger:
  RTS

draw_highnib:
  REP #$30

  ; read tilemap address
  LDY #$0004
  LDA ($00),y
  TAX

  ; read memory address
  LDY #$0001
  LDA ($00),y
  STA $02
  LDY #$0002
  LDA ($00),y
  STA $03
  LDA [$02]
  AND #$00F0
  LSR
  LSR
  LSR
  LSR
  STA !menu_tilemap_mirror,x
  RTS