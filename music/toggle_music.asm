update_music:
    PHP
    SEP #$20
    LDA !disable_music
    BNE .disable_music

.set_music
    LDA !current_music_track
    STA !r_apu_io_0_mirror
    BRA .ret

.disable_music
    LDA !reg_apu_port0 : STA !current_music_track ; save currently playing music in case we want to re-enable
!disable_music_sentinel = $B5 ; this is an unused (hopefully) track value so that we can signal to prevent_music_change
    LDA #!disable_music_sentinel
    STA !r_apu_io_0_mirror
.ret
    PLP
    RTS
