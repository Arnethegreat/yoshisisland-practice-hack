; IRQ
org $00C412
    JMP irq

; vcount for new IRQs
org $00C452
    JMP load_irq2_vcount

; defer BG3 x/y scroll updates in NMI if hud enabled until after the hud has rendered, in irq_2b
org $00C567
    LDA !hud_enabled
    AND !hud_displayed
    BNE +
    JSR restore_bg3_xy
+
    JMP $C57B

; no updates of things to override (commented lines), also hijack
org $00C584
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

org $00C48D
    JSR check_lag

org $00C5FE
    JSR check_lag

org $00C641
    JSR check_lag

org $00C87A
    JSR check_lag
