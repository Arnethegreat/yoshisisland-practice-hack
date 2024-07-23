; game is trying to change music track
prevent_music_change:
    TAX ; save track ID in X

    ; it's possible for the interrupt to occur during a GSU (superfx) routine
    ; in which case the GSU will have sole access to ROM/SRAM, and CPU reads will return garbage
    ; this is why interrupt code is always executed in WRAM
    ; our !disable_music var is SRAM, so we may need to pause the superfx to access it
    LDA !disable_music : TAY
    LDA !gsu_sfr : BIT !gsu_go_bit : BEQ +
    ; GSU is running, tell it to wait
    ; `--hO Ahcc`: O = RON (ROM enable), A = RAN (RAM enable)
    LDA #$18 : TRB !gsu_scmr ; clear RON/RAN flags to put GSU in WAIT mode
    LDA !disable_music : TAY ; now the CPU can access SRAM
    LDA #$18 : TSB !gsu_scmr ; set RON/RAN to give access back to GSU and it will resume
    +

    TYA : BEQ .send_track ; is disable music active?

    ; if music disable is always on from boot, the first level transition will hang the SPC:
    ; the SPC tempo ($53) gets updated to whatever the stored tempo ($03CF) is during music changes (level transitions etc.)
    ; $03CF is initially zero, which gets written to $53, causing an infinite loop ($04A6)
    ; we force $03CF to be initialised by writing a value to port0 once on boot
    LDA !gamemode : CMP #!gm_npresentsload : BNE +
    LDX #$01
    BRA .send_track
    +

    ; if we're preventing a music change, store the track it was trying to play
    ; unless the change was triggered by us, in which case we've already stored the track
    CPX #!disable_music_sentinel : BEQ +
    STX !current_music_track
    +
    LDX #$F1 ; silent track

.send_track
    TXA

    ; hijacked code
    STA !reg_apu_port0
    STA.b !r_apu_io_0_mirror_prev
    STZ.b !r_apu_io_0_mirror
.ret
    JMP play_music_track+$07
