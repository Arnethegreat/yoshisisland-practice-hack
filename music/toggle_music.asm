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

; game is trying to change music track
prevent_music_change:
    TAX
    LDA !disable_music : BEQ +
    ; if we're preventing a music change, store the track it was trying to play
    ; unless the change was triggered by us, in which case we've already stored the track
    CPX #!disable_music_sentinel : BEQ ++
    STX !current_music_track
    ++
    LDX #$F1 ; silent track
    +
    TXA

    ; hijacked code
    STA !reg_apu_port0
    STA.b !r_apu_io_0_mirror_prev
    STZ.b !r_apu_io_0_mirror
.ret
    RTL
