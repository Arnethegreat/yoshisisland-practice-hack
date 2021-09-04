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

; 28 rows
; 1792 bytes
!menu_tilemap_mirror = $7EB8E2
!menu_tilemap_mirror_bank = #$7E7E
!menu_tilemap_mirror_addr = #$B8E2
!menu_tilemap_size = #$0700


!warps_page_depth_index = $00DF   ; current page depth --  0: main menu,   1: world select,   2: level select,   3: room warp select

!warps_current_world_index = $00E1
!warps_current_level_index = $00E3
!warps_current_world_level_index = $00E5

!debug_controls_count_current = $00E7
!debug_controls_count = #$0011

; handle initialization of debug menu
init_debug_menu:
    SEP #$30
    PHK
    PLB

    ; turn screen off
    LDA #$8F
    STA !reg_inidisp
    STA $0200

    ; save egg inventory if in a level
    LDA $011C ; IRQ mode - could possibly use game mode, but it's way more granular and this seems to work
    CMP #$02 ; normal level
    BEQ .save_eggs
    CMP #$04 ; tile-offset level
    BEQ .save_eggs
    CMP #$0A ; mode7 boss level
    BNE .back_up
.save_eggs
    REP #$30
    JSL save_eggs_to_wram ; in a level, save eggs SRAM -> WRAM

    ; despawn current egg sprites when opening the debug menu so that a different set can be loaded when resuming gameplay
    LDY !egg_inv_size_cur
    BEQ .back_up
    -
        LDX !egg_inv_items_cur-2,y ; grab the sprite slot from egg memory and store it in x
        PHY
        JSL despawn_sprite_free_slot
        PLY
        DEY
        DEY
        BNE -
    STZ !egg_inv_size_cur

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
    LDX !palette_backup_size
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
; screen is one pixel off otherwise?
    LDA #$FF
    STA $3B
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
    STA $0948

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

    ; DMA font into VRAM 6000
    LDA #.font_gfx>>8
    STA $00
    LDX #.font_gfx
    LDY #$6000
    LDA #$0600
    JSL vram_dma_01

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

.font_gfx
incbin "../gfx/font.bin":0-600

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
    ; if in-level, load eggs
    SEP #$20
    LDA !irq_mode_1_backup
    CMP #$02 ; normal level
    BEQ .load_eggs
    CMP #$04 ; tile-offset level
    BEQ .load_eggs
    CMP #$0A ; mode7 boss level
    BNE .restore
.load_eggs
    JSL load_eggs_from_wram ; spawn egg sprites WRAM -> SRAM
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
    RTS