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
  AND !dbc_wildcard
  EOR !dbc_wildcard
  STA [!dbc_memory]

; midtape sound
  LDA #$19
  STA $0053

.ret
  JSR draw_toggle
  RTS

;================================

main_egg_changer:

.ret
  RTS
