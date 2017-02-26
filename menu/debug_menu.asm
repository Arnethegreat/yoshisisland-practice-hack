!bg1_backup = $D0
!bg2_backup = $D2
!hmda_backup = $D4
!irq_mode_1_backup = $D6
!irq_mode_2_backup = $D7
!bg_color_backup = $D8
!bg1_tilemap_backup = $DA
!bg1_char_backup = $DB
!bgmode_backup = $DC


; 32 bytes
!palette_backup = $7EB8E2

menu_palette:
.text
dw $0000, $FFFF, $0000, $789F
.green_egg
dw $0000, $FFFF, $0000, $05E0
.yellow
dw $0000, $FFFF, $0000, $1F9F
.red
dw $0000, $FFFF, $0000, $001F

; 28 rows
; 1792 bytes
!menu_tilemap_mirror = $7EB902
!menu_tilemap_mirror_bank = #$7E7E
!menu_tilemap_mirror_addr = #$B902
!menu_tilemap_size = #$06FE

; handle initialization of debug menu
init_debug_menu:
    SEP #$30
    PHK
    PLB

    ; turn screen off
    LDA #$8F
    STA !reg_inidisp
    STA $0200

.back_up
    REP #$30

    LDA $39
    STA !bg1_backup
    LDA $3B
    STA !bg2_backup
    LDA $0948
    STA !bg_color_backup

    LDA $095F
    STA !bg1_tilemap_backup
    LDA $0962
    STA !bg1_char_backup

; save palette
    LDX #$0020
    ..loop
        LDA $702000-2,x
        STA !palette_backup-2,x
        DEX
        DEX
        BNE ..loop

    SEP #$30

    LDA $095E
    STA !bgmode_backup

    LDA $095F
    STA !bg1_tilemap_backup
    LDA $0962
    STA !bg1_char_backup

    LDA $094A
    STA !hmda_backup
    LDA $011C
    STA !irq_mode_1_backup
    LDA $0126
    STA !irq_mode_2_backup


.init_settings
    ; turn HDMA off
    STZ $094A
    STZ !reg_hdmaen

    ; mode 0, 8x8
    STZ !reg_bgmode

    ; scroll 0 (write twice)
    STZ !reg_bg1hofs
    STZ !reg_bg1hofs
    STZ !reg_bg1vofs
    STZ !reg_bg1vofs
    STZ $39
    STZ $3A
    STZ $3B
    STZ $3C

    ; BG1 tilemap 6400
    LDA #$64
    STA !reg_bg1sc
    STA $095F

    ; BG1 character 6000
    LDA #$06
    STA !reg_bg12nba
    STA $0962

    ; turn on BG1, everything else off
    LDA #$01
    STA !reg_tm
    STZ !reg_ts

    ; NMI & IRQ modes: Nintendo Presents
    STZ $011C
    STZ $0126

    REP #$30

    ; background color
    LDA #$30C5
    STA $0948

    ; palettes
    LDX #$0020
    -
        LDA menu_palette-2,x
        STA $702000-2,x
        DEX
        DEX
        BNE -

    ; flag on
    INC !debug_menu

    ; DMA font into VRAM 6000
    LDA #.font_gfx>>8
    STA $00
    LDX #.font_gfx
    LDY #$6000
    LDA #$0600
    JSL $00BEA6

   ; initialize tilemap with blanktiles
    LDX !menu_tilemap_size
    .test
        LDA #$003F
        STA !menu_tilemap_mirror-2,x
        DEX
        DEX
        BNE .test

    ; initialize controls
    JSR init_controls

    SEP #$30

    PLB
    PLB
    RTL

.font_gfx
incbin "../gfx/font.bin":0-600

;================

main_debug_menu:
    LDA #$0F
    STA $0200

    JSR main_controls

    JSR draw_menu

    LDA !controller_2_data2_press
    AND #$10
    BEQ .ret
    JSR exit_debug_menu

.ret
    SEP #$30
    PLB
    PLB
    RTL

;================

draw_menu:
    REP #$30
    LDA !menu_tilemap_mirror_bank
    STA $00
    LDX !menu_tilemap_mirror_addr
    LDY #$6400
    LDA !menu_tilemap_size
    JSL $00BEA6
.ret
    SEP #$30
    RTS

;================

exit_debug_menu:
.restore
    STZ !debug_menu

    LDA !irq_mode_1_backup
    STA $011C
    LDA !irq_mode_2_backup
    STA $0126
    LDA !hmda_backup
    STA $094A

    LDA !bg1_tilemap_backup
    STA $095F
    LDA !bg1_char_backup
    STA $0962
    LDA !bgmode_backup
    STA $095E


    REP #$30

    LDA !bg_color_backup
    STA $0948
    LDA !bg1_backup
    STA $39
    LDA !bg2_backup
    STA $3B
; palettes
    LDX #$0020
    ..loop
        LDA !palette_backup-2,x
        STA $702000-2,x
        DEX
        DEX
        BNE ..loop

; world map test
    ; LDA #$17
    ; STA $212C
    ; LDA #$01
    ; STA $2105
    ; LDA #$22
    ; STA $210B

    ; back out of gamemode completely
.ret
    RTS