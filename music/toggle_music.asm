toggle_music:
    LDA !disable_music
    BEQ .disable_music

.set_music
    LDA #$01
    STA $4D
    LDA #$00
    STA !disable_music
    BRA .ret

.disable_music
    LDA #$01
    STA !disable_music
.ret
    RTS