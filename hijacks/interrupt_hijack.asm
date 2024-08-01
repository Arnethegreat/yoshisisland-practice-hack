org nmi_hijack
    JMP test_soft_reset

; IRQ
org irq_2_start
    JMP irq_2

; vcount for new IRQs
org irq_1_set_vcount
    JMP load_irq2_vcount

; defer BG3 x/y scroll updates in NMI if hud enabled until after the hud has rendered, in irq_2b
org irqmode_02_regupd_bg3
    LDA !hud_displayed : BNE +
    JSR restore_bg3_xy
+
    JMP $C57B

; no updates of things to override (commented lines), also hijack
org irqmode_02_regupd_general
;   LDA !r_reg_tm_mirror : STA $2C
    LDA !r_reg_tmw_mirror : STA $2E
    LDA !r_reg_bg12nba_mirror : STA $0B
    LDA !r_reg_bg1sc_mirror : STA $07
    LDA !r_reg_w12sel_mirror : STA $23
    LDA !r_reg_cgwsel_mirror : STA $30
    LDA !r_reg_wbglog_mirror : STA $2A
    SEP #$20
;   LDA !r_reg_bg3sc_mirror : STA $09
;   LDA !r_reg_bgmode_mirror : STA $05
    JSR nmi
    BRA +
    NOP #15
+

org irqmode_02 ; normal level
    JSR check_lag

org irqmode_04 ; offset-per-tile level
    JSR check_lag

org irqmode_0A ; mode7 bosses
    JSR check_lag

org irqmode_08 ; story cutscene/credits
    JSR check_lag

;=================================
; Hijack music routine so we can disable if needed
; $7EC019 runs every frame; if music track to be played (r_apu_io_0_mirror != 0) then go here
; contents of !r_apu_io_0_mirror in A, 8-bit AI
org play_music_track
    JMP prevent_music_change
    NOP #3
