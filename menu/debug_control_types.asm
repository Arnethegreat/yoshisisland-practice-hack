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

  LDY !dbc_wildcard

  ; increment only high nibble
  LDA [!debug_memoryaddr_dp]
  STA $0000
  CLC
  ADC #$10
  AND #$F0
  STA $0002

  ; compare to wild card (max)
  LDA $0000
  CMP (!debug_base_dp),y
  BCC +
  LDY !dbc_wildcard+1
  LDA (!debug_base_dp),y
  STA $0002

+
  LDA $0000
  AND #$0F
  ORA $0002
  STA [!debug_memoryaddr_dp]

; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #%01000000
  BEQ .ret

  LDY !dbc_wildcard+1
  ; decrement only high nibble
  LDA [!debug_memoryaddr_dp]
  STA $0000
  AND #$F0

  ; compare to wild card (min)
  CMP (!debug_base_dp),y
  BNE .normal_dec
  LDY !dbc_wildcard
  LDA (!debug_base_dp),y
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
  STA [!debug_memoryaddr_dp]

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

  LDY !dbc_wildcard
  ; increment only low nibble
  LDA [!debug_memoryaddr_dp]
  STA $0000
  INC A
  AND #$0F
  STA $0002

  ; compare to wild card (max)
  LDA $0000
  CMP (!debug_base_dp),y
  BCC +
  LDY !dbc_wildcard+1
  LDA (!debug_base_dp),y
  STA $0002
+
  LDA $0000
  AND #$F0
  ORA $0002
  STA [!debug_memoryaddr_dp]

  ; increase sound effect
  LDA #$11
  STA $0053


; pressing Y?
.check_decrement
  LDA !controller_data2_press
  AND #%01000000
  BEQ .ret

  LDY !dbc_wildcard+1
  ; decrement only low nibble
  LDA [!debug_memoryaddr_dp]
  STA $0000
  AND #$0F

  ; compare to wild card (min)
  CMP (!debug_base_dp),y
  BNE .normal_dec
  LDY !dbc_wildcard
  LDA (!debug_base_dp),y
  STA $0002
  BRA .wrap

.normal_dec
  DEC A
  STA $0002
.wrap
  LDA $0000
  AND #$F0
  ORA $0002
  STA [!debug_memoryaddr_dp]

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

  LDY !dbc_wildcard

  LDA [!debug_memoryaddr_dp]
  AND (!debug_base_dp),y
  EOR (!debug_base_dp),y
  STA [!debug_memoryaddr_dp]

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
