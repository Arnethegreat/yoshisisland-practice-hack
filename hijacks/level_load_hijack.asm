; hijack at level load after it sets camera
; checks if we're loading a savestate and override camera if we are

org level_load_camera
    autoclean JSL fix_camera
    NOP

org level_room_preinit_hijack ; start of game mode 0C before checking !level_load_type flag
    JSR level_room_preinit_hook

org level_init_hijack
    JSR level_init_hook

org room_init_hijack ; end of game mode 0C when !level_load_type flag is set
    JSR room_init_hook

org level_main_hijack
    autoclean JSL level_tick
    NOP

org level_header_hijack
    JSR level_header

org underwater_room_hijack
    JSR fix_hud_underwater

org score_screen_init_hijack
    autoclean JSL score_screen_hud_fix
    NOP

; hijack at level load where it actually has the current save_current_area
; saving value because game never saves it while in level
org save_current_area
    JSR save_current_area_hook

; freespace in bank 01 - starts here in J, in the middle of a large block in U
org $01FED2

level_room_preinit_hook:
    autoclean JSL level_room_preinit
    LDA !level_load_type
    RTS

level_init_hook:
    INC !gamemode
    autoclean JSL level_init
    RTS

room_init_hook:
    STZ !level_load_type
    autoclean JSL room_init
    RTS

level_header:
    ; if loading savestate, set the bg1 graphics in case they were changed in-level
    LDA !loaded_state : BEQ .ret
    {
        LDA !save_bg1_tileset : STA !r_header_bg1_tileset
        LDA !save_bg1_palette : STA !r_header_bg1_palette
    }
.ret
    LDA #$07B0
    RTS

fix_hud_underwater:
    ; N.B. this just grabs the first table entry (scanline 0). If another entry runs before the HUD region ends, then this may be incorrect
    LDA !r_hdma_table3+1 : STA !irq_bg3_cam_x_backup
    LDA !r_hdma_table3+3 : STA !irq_bg3_cam_y_backup
.ret
    LDA !r_header_bg3_tileset ; hijacked code
    RTS

save_current_area_hook:
    autoclean JSL set_level
    RTS
