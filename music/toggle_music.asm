toggle_music:
    ; SEP #20
    LDA !disable_music
    BEQ .disable_music

.set_music
    LDA #$01
    STA $004D
    LDA #$00
    STA !disable_music
    BRA .ret

.disable_music
    LDA #$F1
    STA $004D
    LDA #$01
    STA !disable_music
.ret
    RTS