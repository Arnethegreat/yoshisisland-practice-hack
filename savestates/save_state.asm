save_state:
    PHX
    PHY
    PHP
    REP #$30

; Only save if we're in gamemode 0F
    LDA !gamemode
    CMP #$000F
    BNE .ret
; Check pause flag too (don't wanna save at start-select)
    LDA $0B0F
    BNE .ret

.prepare_save
;
    LDA #$0001
    STA !savestate_exists

; play 1-up sound for cue that you saved
    LDA #$008F
    STA $0053

.save_memory_blocks
    JSR save_item_memory

    JSR save_sram_block_00
    JSR save_sram_block_01
    JSR save_sram_block_02
    JSR save_sram_block_03

    JSR save_wram_block_00
    JSR save_wram_block_01
    JSR save_wram_block_02
    JSR save_wram_block_03

    JSR save_dma_channel_settings

.save_position
    LDA !current_level
    STA !save_level

    LDA !yoshi_x_pos
    STA !save_x_pos

    LDA !yoshi_y_pos
    STA !save_y_pos

    LDA !s_camera_layer1_x
    STA !save_camera_layer1_x

    LDA !s_camera_layer1_y
    STA !save_camera_layer1_y


.ret
    PLP
    PLY
    PLX
    JMP game_mode_return