; 32 bytes
!palette_anim_timer = $026E
!palette_backup = $0270
!palette_backup_size = #$0030
menu_palette:
.flashing
dw $0000, $FFFF, $0000, $789F
.green_egg
dw $0000, $FFFF, $0000, $05E0
.yellow
dw $0000, $FFFF, $0000, $033F
.red
dw $0000, $FFFF, $0000, $001F
.red_text
dw $0000, $001F, $0000, $001F
.green_text
dw $0000, $05E0, $0000, $001F

; handle initialization of debug menu
init_debug_menu:
    SEP #$30
    PHK
    PLB

    ; disable hud
    LDA !hud_displayed : STA !hud_displayed_backup
    STZ !hud_displayed

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
    LDA !r_reg_coldata_mirror
    STA !bg_color_backup

; save palette
    LDX !palette_backup_size
    ..loop
        LDA $702000-2,x
        STA !palette_backup-2,x
        DEX
        DEX
        BNE ..loop

    SEP #$30

    LDA !r_reg_bgmode_mirror
    STA !bgmode_backup

    LDA !r_reg_bg1sc_mirror
    STA !bg1_tilemap_backup
    LDA !r_reg_bg12nba_mirror
    STA !bg1_char_backup

    LDA !r_reg_hdmaen_mirror
    STA !hdma_backup
    LDA $011C
    STA !irq_mode_1_backup
    LDA $0126
    STA !irq_mode_2_backup

    ; save egg inventory if in a level
    JSR is_in_level
    CMP #$01
    BNE .init_settings
    JSR store_eggs

.init_settings
    ; turn HDMA off
    STZ !r_reg_hdmaen_mirror
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
; screen is one pixel off otherwise?
    LDA #$FF
    STA $3B
    STZ $3C


    ; BG1 tilemap 6400
    LDA #$64
    STA !reg_bg1sc
    STA !r_reg_bg1sc_mirror

    ; BG1 character 6000
    LDA #$06
    STA !reg_bg12nba
    STA !r_reg_bg12nba_mirror

    ; turn on BG1, everything else off
    LDA #$01
    STA !reg_tm
    STZ !reg_ts

    ; NMI & IRQ modes: Nintendo Presents
    STZ $011C
    STZ $0126

    ; background color register
    ; LDA #$25
    ; STA $0990
    ; LDA #$46
    ; STA $0992 
    ; LDA #$8C
    ; STA $0994

    ; disable window clipping
    STZ $2130
    ; enable backdrop color
    LDA #$20
    STA $2131

    REP #$30
    ; background color mirror
    LDA #$30C5
    STA !r_reg_coldata_mirror

    ; palettes
    LDA #$0003
    STA !palette_anim_timer
    LDX !palette_backup_size
    -
        LDA menu_palette-2,x
        STA $702000-2,x
        DEX
        DEX
        BNE -

    ; flag on
    INC !debug_menu

    JSR load_font

    ; set the page index and the controls count for the main page
    STZ !warps_page_depth_index
    LDA !debug_controls_count : STA !debug_controls_count_current

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

    JSR init_option_tilemaps

    SEP #$30

    PLB
    PLB
    RTL

;================================

store_eggs:
    PHP
    REP #$30
    JSL save_eggs_to_wram ; in a level, save eggs SRAM -> WRAM

    ; despawn current egg sprites when opening the debug menu so that a different set can be loaded when resuming gameplay
    LDY !egg_inv_size_cur
    BEQ .ret
    -
        LDX !egg_inv_items_cur-2,y ; grab the sprite slot from egg memory and store it in x
        PHY
        JSL despawn_sprite_free_slot
        PLY
        DEY
        DEY
        BNE -
    STZ !egg_inv_size_cur
.ret
    PLP
    RTS

;================================

main_debug_menu:
    LDA #$0F
    STA $0200

    JSR main_controls
    JSR animate_palette
    JSR draw_menu

    LDA !controller_2_data2_press
    ORA !controller_data2_press
    AND #$10
    BEQ .ret
    JSR exit_debug_menu

.ret
    ; back out of game mode completely, leaving frame
    SEP #$30
    PLB
    PLB
    RTL

;================================

draw_menu:
    REP #$30
    LDA !menu_tilemap_mirror_bank
    STA $00
    LDX !menu_tilemap_mirror_addr
    LDY #$6400
    LDA !menu_tilemap_size
    JSL vram_dma_01
.ret
    SEP #$30
    RTS

;================================
anim_palette_data:
dw $035F, $001F, $03E0, $5C1F

animate_palette:
    REP #$20
    DEC !palette_anim_timer
    LDA !palette_anim_timer
    BPL .change_color
.reset
    ; reset timer
    LDA #$0003
    STA !palette_anim_timer
.change_color
    ASL A 
    TAX
    LDA anim_palette_data,x
    STA $702000+6
.ret
    SEP #$20
    RTS

;================================

exit_debug_menu:
    SEP #$20
    JSR is_in_level
    CMP #$01
    BNE .restore
    JSL load_eggs_from_wram ; spawn egg sprites WRAM -> SRAM
.restore
    STZ !debug_menu

    LDA !irq_mode_1_backup
    STA $011C
    LDA !irq_mode_2_backup
    STA $0126
    LDA !hdma_backup
    STA !r_reg_hdmaen_mirror

    LDA !bg1_tilemap_backup
    STA !r_reg_bg1sc_mirror
    LDA !bg1_char_backup
    STA !r_reg_bg12nba_mirror
    LDA !bgmode_backup
    STA !r_reg_bgmode_mirror


    REP #$30

    LDA !bg_color_backup
    STA !r_reg_coldata_mirror
    LDA !bg1_backup
    STA $39
    LDA !bg2_backup
    STA $3B
; palettes
    LDX !palette_backup_size
    ..loop
        LDA !palette_backup-2,x
        STA $702000-2,x
        DEX
        DEX
        BNE ..loop
; gamemode tests
    SEP #$30
    LDA !gamemode
    CMP #$22
    BNE +
; if world map, go to prepare world map mode
    LDA #$20
    STA !gamemode
    BRA .ret
+
    CMP #$0A
    BNE .ret
    LDA #$08
    STA !gamemode
    LDA #$00
    STA $0200

.ret
    JSR handle_flags
    JSR hud_sub
    RTS

; change some HUD related settings when exiting the menu, since it may have been toggled on/off
hud_sub:
    ; disable whichever hdma channels are being used by the hud - they'll be re-enabled if the hud is on
    LDA !hud_hdma_channels : TRB !r_reg_hdmaen_mirror

    ; possibly need to reset the hdma table for hookbill/bowser
    LDA !last_exit_1
    CMP #$86
    BNE +
    JSL hookbill_mode7_hdma
+
    LDA !last_exit_1
    CMP #$DD
    BNE +
    JSL bowser_mode7_hdma
+

    ; if (hud was active before OR in-level) AND it's enabled, init hud, else proceed
    LDA !hud_displayed_backup : STA !hud_displayed
    JSR is_in_level
    ORA !hud_displayed
    AND !hud_enabled
    BEQ .ret
    JSR level_room_init_common
.ret
    RTS

; on return: A=1 if in-level, 0 otherwise
is_in_level:
    PHP
    SEP #$20
    LDA !irq_mode_1_backup ; IRQ mode - could possibly use game mode, but it's way more granular and this seems to work
    CMP #$02 ; normal level
    BEQ .in_level
    CMP #$04 ; tile-offset level
    BEQ .in_level
    CMP #$0A ; mode7 boss level
    BEQ .in_level
    LDA #$00
    BRA .ret
.in_level
    LDA #$01
.ret
    PLP
    RTS
