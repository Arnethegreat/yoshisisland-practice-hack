; handle initialization of debug menu
init_debug_menu:
    SEP #$30

    ; don't draw hud while in menu - it will be reactivated on exit if we're in-level or warping
    STZ !hud_displayed

    ; turn screen off
    LDA #$8F
    STA !reg_inidisp
    STA !r_reg_inidisp_mirror

.back_up
    REP #$30

    LDA.b !r_camera_layer1_x : STA !camera_layer1_x_backup
    LDA.b !r_camera_layer1_y : STA !camera_layer1_y_backup
    LDA !r_reg_coldata_mirror
    STA !bg_color_backup

; save palette
    LDX #!palette_backup_size
    ..loop
        LDA !s_cgram_mirror-2,x
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
    LDA !r_interrupt_mode
    STA !irq_mode_1_backup
    LDA $0126
    STA !irq_mode_2_backup

    LDA !r_reg_w12sel_mirror : STA !w12sel_backup

    ; save egg inventory if in a level
    JSR is_in_level
    CMP #$01
    BNE .init_settings
    JSL save_eggs_to_wram
    JSR despawn_egg_sprites

.init_settings
    ; copy egg inventory from WRAM to our debug mirror
    JSR egg_inv_wram_to_debug

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


    ; BG1 tilemap
    LDA #!debug_bg1_tilemap_dest
    STA !reg_bg1sc
    STA !r_reg_bg1sc_mirror

    ; BG1 character
    LDA #!debug_bg1_tile_dest
    STA !reg_bg12nba
    STA !r_reg_bg12nba_mirror

    ; turn on BG1, everything else off
    LDA #$01
    STA !reg_tm
    STZ !reg_ts

    ; NMI & IRQ modes: Nintendo Presents
    STZ !r_interrupt_mode
    STZ $0126

    ; disable window clipping
    STZ $2130
    STZ !reg_w12sel
    STZ !r_reg_w12sel_mirror
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

    ; flag on
    INC !debug_menu

    JSR load_font

    ; set the page index and the controls count for the main page
    LDA !current_menu_data_ptr
    BNE + ; first time opening the menu, just load the main menu
    LDA #mainmenu_ctrl : STA !current_menu_data_ptr
    +
    JSR init_current_menu

    ; if a warps page was open previously, reopen it
    LDA !warps_page_depth_index : BEQ +
    JSR warp_menu_direct_load
    +

    SEP #$30
    JMP game_loop_skip

;================================

; set !current_menu_data_ptr to the address of the menu to load before calling
init_current_menu:
    JSR store_current_menu_metadata
    JSR blank_tilemap
    JSR init_current_menu_tilemap
    JSR init_current_menu_palette
    JSR init_controls
    RTS

;================================

main_debug_menu:
    PHP
    LDA !warping : BNE .exit_menu
    LDA !recording_bind_state : BNE .process_menu ; don't exit menu in the middle of recording a bind

    LDA !controller_2_data2_press
    ORA !controller_data2_press
    AND #!controller_data2_start
    BEQ .process_menu

.exit_menu
    JSR exit_debug_menu
    BRA .ret

.process_menu
    LDA #$0F : STA !r_reg_inidisp_mirror

    JSR main_controls
    JSR animate_palette
    JSR draw_menu

.ret
    %a16()
    INC !frame_counter
    PLP
    JMP game_loop_skip ; don't execute any other code while in the menu

;================================

draw_menu:
    PHP
    SEP #$20
    LDA.b #!menu_tilemap_mirror>>16 : STA $01
    REP #$30
    LDX.w #!menu_tilemap_mirror
    LDY.w #!debug_bg1_tilemap_dest_full
    LDA #!menu_tilemap_size
    JSL vram_dma_01
.ret
    PLP
    RTS

;================================
anim_palette_data:
dw $035F, $001F, $03E0, $5C1F
dw $035F, $001F, $03E0, $5C1F

anim_palette_data_selection:
dw $498A, $498A, $498A, $498A
dw $4567, $4567, $4567, $4567

animate_palette:
    REP #$20
    DEC !palette_anim_timer
    LDA !palette_anim_timer
    BPL .change_color
.reset
    ; reset timer
    LDA #$0007
    STA !palette_anim_timer
.change_color
    ASL A 
    TAX
    LDA anim_palette_data,x
    STA !s_cgram_mirror+6
    LDA anim_palette_data_selection,x
    STA !s_cgram_mirror+60
.ret
    SEP #$20
    RTS

;================================

exit_debug_menu:
    JSR egg_inv_debug_to_wram
    SEP #$20

    LDA !warping : BNE +
    {
        ; exiting menu, but not warping
        JSR is_in_level : CMP #$01 : BNE +
        JSL load_eggs_from_wram ; spawn egg sprites WRAM -> SRAM
        LDA !s_player_form : CMP #!pfrm_super : BNE +
        ; Infinite super baby mario bug: if in baby mario mode, egg inv will contain the big yoshi egg
        ; load_eggs_from_wram ignores this sprite ID, so do it manually here
        JSR spawn_big_yoshi_egg
  + }

    STZ !debug_menu

    LDA !irq_mode_1_backup
    STA !r_interrupt_mode
    LDA !irq_mode_2_backup
    STA !r_irq_setting
    LDA !hdma_backup
    STA !r_reg_hdmaen_mirror

    LDA !bg1_tilemap_backup
    STA !r_reg_bg1sc_mirror
    LDA !bg1_char_backup
    STA !r_reg_bg12nba_mirror
    LDA !bgmode_backup
    STA !r_reg_bgmode_mirror
    LDA !w12sel_backup : STA !r_reg_w12sel_mirror
    LDA !slowdown_mag : STA !frame_skip_timer ; so we don't need to wait for the timer to run out before it updates

    REP #$30

    LDA !bg_color_backup
    STA !r_reg_coldata_mirror
    LDA !camera_layer1_x_backup : STA.b !r_camera_layer1_x
    LDA !camera_layer1_y_backup : STA.b !r_camera_layer1_y

; palettes
    LDX #!palette_backup_size
    -
        LDA !palette_backup-2,x
        STA !s_cgram_mirror-2,x
        DEX
        DEX
        BNE -
; gamemode tests
    SEP #$30
    LDA !gamemode
    CMP #!gm_overworld
    BNE +
; if world map, go to prepare world map mode since we have to overwrite some VRAM when loading the menu
    LDA #!gm_overworldloading
    STA !gamemode
    BRA .ret
+
    CMP #!gm_title
    BNE .ret
    LDA #!gm_cutscenefadeout
    STA !gamemode
    LDA #$00
    STA !r_reg_inidisp_mirror

.ret
    JSR handle_flags
    JSR hud_sub
    STZ !warping
    RTS

; change some HUD related settings when exiting the menu, since it may have been toggled on/off
hud_sub:
    ; disable whichever hdma channel is being used by the hud - it'll be re-enabled if the hud is on
    LDA !hud_hdma_channel : TRB !r_reg_hdmaen_mirror

    ; possibly need to reset the hdma table for hookbill/bowser
    LDA !special_boss_flag : CMP #$02 : BNE +
    JSL hookbill_mode7_hdma
    BRA ++
+
    CMP #$07 : BNE ++
    JSL bowser_mode7_hdma
++

    ; if hud enabled AND in-level AND we aren't warping, init hud
    LDA !warping : BNE .ret ; warping will load a room, so the init sub will be called there instead
    JSR is_in_level : AND !hud_enabled : BEQ .ret
    JSR init_hud
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
