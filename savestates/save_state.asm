save_state:
    PHX
    PHY
    PHP
    REP #$30

; Only save if we're in gamemode 0F
    LDA !gamemode : CMP.w #!gm_level : BNE .ret

; Check pause flag too (don't wanna save at start-select)
    LDA $0B0F
    BNE .ret

.prepare_save
    LDA #$0001
    STA !savestate_exists
    STZ !map16delta_index


.save_memory_blocks
    JSR save_hud_timers ; save these first before savelag
    JSR save_item_memory
    JSR save_ram
    JSR save_dyntile_buffer
; for experimental load
    JSR save_sram_map16
    JSR save_dma_channel_settings

; play 1-up sound for cue that you saved
    LDA.w #!sfx_correct : STA !sound_immediate

    JSR save_additional
    JSR load_hud_timers
    INC !skip_frame_flag ; skip next frame to prevent an extra lag frame incrementing the lag counter
.ret
    PLP
    PLY
    PLX
    RTS

save_additional:
    LDA !r_reg_inidisp_mirror : STA !save_inidisp_mirror
    LDA !r_hdma_indirect_table6+0 : STA !save_hdma_indirect_table6+0
    LDA !r_hdma_indirect_table6+2 : STA !save_hdma_indirect_table6+2
    LDA !r_hdma_indirect_table6+4 : STA !save_hdma_indirect_table6+4
    LDA !r_hdma_indirect_table6+6 : STA !save_hdma_indirect_table6+6

    LDA !current_level
    STA !save_level

    LDA !world_num : STA !save_world_num
    LDA !level_num : STA !save_level_num

    LDA !yoshi_x_pos
    STA !save_x_pos

    LDA !yoshi_y_pos
    STA !save_y_pos

    LDA !r_camera_direction_x : STA !save_camera_direction_x

    LDA !s_camera_layer1_x
    STA !save_camera_layer1_x

    LDA !s_camera_layer1_y
    STA !save_camera_layer1_y

    LDA !r_header_bg1_tileset : STA !save_bg1_tileset
    LDA !r_header_bg1_palette : STA !save_bg1_palette
.ret
    RTS
