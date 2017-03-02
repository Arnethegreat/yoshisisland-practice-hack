; Control type inits
;

init_highnib_memchanger:
  JSR draw_highnib
.ret
  RTS

init_lownib_memchanger:
  JSR draw_lownib
.ret
  RTS

init_toggle_changer:
  JSR draw_toggle
.ret
  RTS

init_egg_changer:
  JSR egg_inv_to_debug_mirror
  JSR clean_egg_inv_mirror
  JSR draw_egg_changer
.ret
  RTS

init_call_function:
.ret
  RTS

;================================
; Control type main routines

main_highnib_memchanger:
  SEP #$20

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #%10000000
  BEQ .check_decrement

  ; increment only high nibble
  LDA [!dbc_memory]
  STA $0000
  CLC
  ADC #$10
  AND #$F0
  STA $0002

  ; compare to wild card (max)
  LDA $0000
  CMP !dbc_wildcard
  BCC +
  LDA !dbc_wildcard+1
  STA $0002

+
  LDA $0000
  AND #$0F
  ORA $0002
  STA [!dbc_memory]

  ; increase sound effect
  LDA #$10
  STA $0053

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #%01000000
  BEQ .ret

  ; decrement only high nibble
  LDA [!dbc_memory]
  STA $0000
  AND #$F0

  ; compare to wild card (min)
  CMP !dbc_wildcard+1
  BNE .normal_dec
  LDA !dbc_wildcard
  STA $0002
  BRA .wrap

.normal_dec
  LDA $0000
  AND #$F0
  SEC
  SBC #$10
  STA $0002
.wrap
  LDA $0000
  AND #$0F
  ORA $0002
  STA [!dbc_memory]

  ; decrease sound effect
  LDA #$10
  STA $0053

.ret
  JSR draw_highnib
  RTS

;================================

main_lownib_memchanger:
  SEP #$20

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #%10000000
  BEQ .check_decrement

  ; increment only low nibble
  LDA [!dbc_memory]
  STA $0000
  INC A
  AND #$0F
  STA $0002

  ; compare to wild card (max)
  LDA $0000
  CMP !dbc_wildcard
  BCC +
  LDA !dbc_wildcard+1
  STA $0002
+
  LDA $0000
  AND #$F0
  ORA $0002
  STA [!dbc_memory]

  ; increase sound effect
  LDA #$11
  STA $0053


; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #%01000000
  BEQ .ret

  ; decrement only low nibble
  LDA [!dbc_memory]
  STA $0000
  AND #$0F

  ; compare to wild card (min)
  CMP !dbc_wildcard+1
  BNE .normal_dec
  LDA !dbc_wildcard
  STA $0002
  BRA .wrap

.normal_dec
  DEC A
  STA $0002
.wrap
  LDA $0000
  AND #$F0
  ORA $0002
  STA [!dbc_memory]

  ; decrease sound effect
  LDA #$10
  STA $0053

.ret
  JSR draw_lownib
; hacky because don't feel like doing a seperate egg count type
  JSR clean_egg_inv_mirror
  JSR debug_inv_to_egg_inv
  JSR draw_all_egg_changer
  RTS

;================================

main_toggle_changer:
  SEP #$30

  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #%11000000
  BEQ .ret

  LDA [!dbc_memory]
  BEQ .set
  LDA #$00
  BRA .reset
.set
  AND !dbc_wildcard
  EOR !dbc_wildcard
.reset
  STA [!dbc_memory]

; Chink sound
  LDA #$1E
  STA $0053

.ret
  JSR draw_toggle
  RTS

;================================

main_egg_changer:
  SEP #$20
  ; egg inventory number
  LDA !dbc_wildcard
  ASL A
  TAX

; pressing A?
.check_increment
  LDA !controller_data1_press
  AND #%10000000
  BEQ .check_decrement

; wrap from 1-9
  LDA !debug_egg_inv_mirror,x
  INC A
  CMP #$0A
  BCC .inc
  LDA #$01

.inc
  STA !debug_egg_inv_mirror,x
; sound
  LDA #$03
  STA $0053
  BRA .ret

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #%01000000
  BEQ .ret

  LDA !debug_egg_inv_mirror,x
  DEC A
  BNE .dec
  LDA #$09

.dec
  STA !debug_egg_inv_mirror,x
; sound
  LDA #$03
  STA $0053
  BRA .ret

.ret
  JSR clean_egg_inv_mirror
  JSR debug_inv_to_egg_inv
  JSR draw_all_egg_changer
  RTS

;================================

main_call_function:
  SEP #$30
  LDA !controller_data1_press
  ORA !controller_data2_press
; B/Y/X/A buttons
  AND #%11000000
  BEQ .ret

  LDA !dbc_wildcard
  ASL A
  TAX
  JSR (control_function_calls,x)
; Midway tape sound
  REP #$30
  LDA #$0019
  STA $0053

.ret
  RTS
;================================
; Loop through egg inventory
; Mark eggs as empty if after
clean_egg_inv_mirror:
  REP #$20
  SEP #$10
  LDY #$05
  .loop
  TYA
  CMP !debug_egg_count_mirror
  BCC +
  ASL A
  TAX
  STZ !debug_egg_inv_mirror,x
  BRA .end
  +
  ASL A
  TAX
  LDA !debug_egg_inv_mirror,x
  BNE .end
  LDA #$0005
  STA !debug_egg_inv_mirror,x
  .end
  DEY
  BPL .loop
.ret
  RTS

;================================
; Read inventory and translate sprite ID to 
; proper index for debug egg inv
;
; TODO: Always use current egg inventory
;       If we're inside a level
egg_inv_to_debug_mirror:
  REP #$30
  LDA !egg_inv_size
  LSR A
  STA !debug_egg_count_mirror
  LDX #$000A
  .loop
    LDA !egg_inv_items,x
    LDY #$0024
    .translate_loop
      CMP egg_inv_tilemap,y
      BEQ .match
      DEY
      DEY
      DEY
      DEY
      BNE .translate_loop
  ; no match, set as unknown sprite
    LDY #$0028
  .match
    TYA
    LSR A
    LSR A
    STA !debug_egg_inv_mirror,x
    DEX
    DEX
    BPL .loop

.ret
  RTS

;================================
; Read debug inventory and transfer to real inventory
;

debug_inv_to_egg_inv:
  REP #$30

  LDA !debug_egg_count_mirror
  ASL A
  STA !egg_inv_size
  TAY
  .loop
    LDA !debug_egg_inv_mirror,y
    ; if null egg/unknown index, don't set
    CMP #$0009
    BCS +
    ASL A
    ASL A
    TAX
    LDA egg_inv_tilemap,x
    TYX
    STA !egg_inv_items,x
    +
    DEY
    DEY
    BPL .loop


.ret
  RTS