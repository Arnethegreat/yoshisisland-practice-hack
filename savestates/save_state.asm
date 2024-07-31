save_state:
    PHX
    PHY
    PHP
    REP #$30

; Only save if we're in gamemode 0F
    LDA !gamemode
    CMP.w #!gm_level
    BNE .ret
; Check pause flag too (don't wanna save at start-select)
    LDA $0B0F
    BNE .ret

.prepare_save
    LDA #$0001
    STA !savestate_exists
    STZ !map16delta_index

.save_memory_blocks
    JSR save_item_memory
    JSR save_ram
    JSR save_dyntile_buffer
; for experimental load
    JSR save_sram_map16
    JSR save_dma_channel_settings

; play 1-up sound for cue that you saved
    LDA.w #!sfx_correct : STA !sound_immediate

.save_additional
    LDA !r_reg_inidisp_mirror : STA !save_inidisp_mirror

    LDA !current_level
    STA !save_level

    LDA !yoshi_x_pos
    STA !save_x_pos

    LDA !yoshi_y_pos
    STA !save_y_pos

    LDA !r_camera_direction_x : STA !save_camera_direction_x

    LDA !s_camera_layer1_x
    STA !save_camera_layer1_x

    LDA !s_camera_layer1_y
    STA !save_camera_layer1_y

    BRA .save_timers

.ret
    PLP
    PLY
    PLX
    RTS
.save_timers
    SEP #$20
    LDA !level_frames : STA !save_level_frames
    LDA !level_seconds : STA !save_level_seconds
    LDA !level_minutes : STA !save_level_minutes
    LDA !room_frames : STA !save_room_frames
    LDA !room_seconds : STA !save_room_seconds
    LDA !room_minutes : STA !save_room_minutes
    REP #20
    LDA !lag_counter : STA !save_lag_counter
    BRA .ret
