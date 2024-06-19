toggle_music:
    PHP
    SEP #$20
    LDA !disable_music
    BNE .disable_music

.set_music
    LDA #$01
    STA !r_apu_io_0_mirror
    BRA .ret

.disable_music
    LDA #$F1
    STA !r_apu_io_0_mirror
.ret
    PLP
    RTS
