boss_room_destinations:
  dw $053D, $0063, $0470, $0078             ; $04F5D0 |
  dw $BB74, $007A, $04CF, $004D             ; $04F5D8 |
  dw $12BF, $0461, $0D7F, $0042             ; $04F5E0 |
  dw $0682, $0064, $0D86, $0078             ; $04F5E8 |
  dw $0A8A, $007A, $03C4, $054B             ; $04F5F0 |
  dw $49CC, $0264, $04DD, $007A             ; $04F5F8 |

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
  LDA boss_room_destinations,x                             ; $04F62A |
  STA $7F7E00                               ; $04F62D |
  LDA boss_room_destinations+2,x                             ; $04F631 |
  STA $7F7E02                               ; $04F634 |
  STZ $038E                                 ; $04F638 |
  LDA #$0001                                ; $04F63B |
  STA $038C                                 ; $04F63E |
  LDA #$000B                                ; $04F641 |
  STA $0118                                 ; $04F644 |
  JSR save_egg_inventory                               ; $04F647 |
  LDA !debug_menu
  BEQ CODE_04F64B
  JSR exit_debug_menu

CODE_04F64B:
  RTS                                      ; $04F64B |

; Stole save egg inventory
;

save_egg_inventory:
  PHP                                       ; $01B2B7 |
  REP #$20                                  ; $01B2B8 |
  SEP #$10                                  ; $01B2BA |
  LDA $7DF6                                 ; $01B2BC |
  STA $7E5D98                               ; $01B2BF |
  BEQ CODE_01B2D4                           ; $01B2C3 |
  TAX                                       ; $01B2C5 |

CODE_01B2C6:
  LDY $7DF6,x                               ; $01B2C6 |
  LDA !s_spr_id,y                           ; $01B2C9 |
  STA $7E5D98,x                             ; $01B2CC |
  DEX                                       ; $01B2D0 |
  DEX                                       ; $01B2D1 |
  BNE CODE_01B2C6                           ; $01B2D2 |

CODE_01B2D4:
  PLP                                       ; $01B2D4 |
  RTS                                       ; $01B2D5 |
