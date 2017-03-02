; Stole go to boss room code
; 
boss_room_warp:
  REP #$30
  LDA $021A                                 ; $04F608 | Level number

CODE_04F60B:
  CMP #$000C                                ; $04F60B |\
  BCC CODE_04F615                           ; $04F60E | | 
  SBC #$000C                                ; $04F610 | | effectively removing world from level number
  BRA CODE_04F60B                           ; $04F613 |/

CODE_04F615:
  CMP #$0003                                ; $04F615 |\
  BEQ CODE_04F61F                           ; $04F618 | | return if we're not in fortress or castle
  CMP #$0007                                ; $04F61A | | 
  BNE CODE_04F64B                           ; $04F61D |/

CODE_04F61F:
  AND #$0004                                ; $04F61F |
  LSR A                                     ; $04F622 |
  LSR A                                     ; $04F623 |
  ORA $0218                                 ; $04F624 | add world number
  ASL A                                     ; $04F627 |
  ASL A                                     ; $04F628 |
  TAX                                       ; $04F629 |
  LDA $04F5D0,x                             ; $04F62A |
  STA $7F7E00                               ; $04F62D |
  LDA $04F5D2,x                             ; $04F631 |
  STA $7F7E02                               ; $04F634 |
  STZ $038E                                 ; $04F638 |
  LDA #$0001                                ; $04F63B |
  STA $038C                                 ; $04F63E |
  LDA #$000B                                ; $04F641 |
  STA $0118                                 ; $04F644 |
  JSL $01B2B7                               ; $04F647 |
  LDA !debug_menu
  BEQ CODE_04F64B
  JSR exit_debug_menu

CODE_04F64B:
  RTS                                      ; $04F64B |