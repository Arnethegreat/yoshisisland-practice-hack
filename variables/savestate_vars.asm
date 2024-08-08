%var_707800(loaded_state, 2) ; needs to be in SRAM for GSU access
%var_1409(savestate_exists, 2)
%var_1409(current_level, 2)
%var_707E7E(full_load_default, 1)
%var_1409(zone_reset_flag, 1)
!zone_reset_flag_l = $7E0000+!zone_reset_flag
%var_1409(load_mode, 1)
%var_1409(dma_channel_0_savestate, 10)
%var_1409(dma_channel_1_savestate, 10)
%var_1409(dma_channel_2_savestate, 10)
%var_1409(dma_channel_3_savestate, 10)
%var_1409(dma_channel_4_savestate, 10)
%var_1409(dma_channel_5_savestate, 10)
%var_1409(dma_channel_6_savestate, 10)
%var_1409(dma_channel_7_savestate, 10)
%var_1409(last_exit_1, 2)
%var_1409(last_exit_2, 2)
%var_1409(last_exit_stars, 2)
%var_1409(last_exit_red_coins, 2)
%var_1409(last_exit_flowers, 2)
%var_1409(last_exit_eggs, 14)
%var_1409(last_level_eggs_size, 2)
%var_1409(last_level_eggs, 12)
%var_1409(last_exit_load_type, 2)
%var_1409(last_exit_item_mem_backup, 128)
%var_1409(load_delay_timer, 1)
%var_707E7E(load_delay_timer_init, 1) ; keep in SRAM for persistence
%var_1409(save_inidisp_mirror, 2)
%var_1409(save_hdma_indirect_table6, 8) ; specifically for prince froggy's stomach
!save_player_form = !sram_block_00_savestate+$AE
%var_1409(save_bg1_tileset, 2)
%var_1409(save_bg1_palette, 2)

; persistent save data (keeps on reset)
; stuff used throughout
%var_707E7E(save_level, 2)
%var_707E7E(save_x_pos, 2)
%var_707E7E(save_y_pos, 2)
%var_707E7E(save_camera_direction_x, 2)
%var_707E7E(save_camera_layer1_x, 2)
%var_707E7E(save_camera_layer1_y, 2)

;=================================

; item memory
; 128 bytes per page
%var_7F0000(save_item_mem_current_page, 2)
%var_7F0000(save_item_mem_page0, !item_mem_page_size)
%var_7F0000(save_item_mem_page1, !item_mem_page_size)
%var_7F0000(save_item_mem_page2, !item_mem_page_size)
%var_7F0000(save_item_mem_page3, !item_mem_page_size)

;=================================

; store changes made to the map16 WRAM table during gameplay
!wram_map16delta_size = $10C0
%var_7E2340(wram_map16delta_savestate, !wram_map16delta_size)
%var_1409(map16delta_index, 2)

;=================================

; SRAM blocks
; Add some kamek timer stuff @ $44F0
;

!sram_block_00_source = $700000 ; to $702200
!sram_block_00_size = $2200
%var_7F0000(sram_block_00_savestate, !sram_block_00_size)

!sram_block_01_source = $702600 ; to $70409E
!sram_block_01_size = $1A9E
%var_7F0000(sram_block_01_savestate, !sram_block_01_size)

; sluggy/froggy wall stuff
!sram_block_02_source = $7049C6 ; to $7049E8
!sram_block_02_size = $0022
%var_7F0000(sram_block_02_savestate, !sram_block_02_size)

; sluggy info
!sram_block_03_source = $704C76 ; to $704CB4
!sram_block_03_size = $003E
%var_7F0000(sram_block_03_savestate, !sram_block_03_size)

; sluggy info
!sram_block_04_source = $70449E ; to $70451E
!sram_block_04_size = $0080
%var_7F0000(sram_block_04_savestate, !sram_block_04_size)

!sram_map16_source = $70409E ; to $70449E
!sram_map16_size = $0400
%var_7E2340(sram_map16_savestate, !sram_map16_size)

!sram_dyntile_source = $705800 ; to $706000
!sram_dyntile_size = $0800
%var_7E2340(sram_dyntile_savestate, !sram_dyntile_size)

; WRAM blocks
;

!wram_block_00_source = $7E0300 ; to $7E03C0
!wram_block_00_size = $00C0
%var_7F0000(wram_block_00_savestate, !wram_block_00_size)

!wram_block_01_source = $7E0948 ; to $7E11B6
!wram_block_01_size = $086E
%var_7F0000(wram_block_01_savestate, !wram_block_01_size)

!wram_block_02_source = $7E0202 ; to $7E0222
!wram_block_02_size = $0020
%var_7F0000(wram_block_02_savestate, !wram_block_02_size)

; avoid sound stuff since we don't save APU state
!wram_block_03_source = $7E0030 ; to $7E004D
!wram_block_03_size = $001D
%var_7F0000(wram_block_03_savestate, !wram_block_03_size)

!wram_block_04_source = $7E0069 ; to $7E015E
!wram_block_04_size = $00F5
%var_7F0000(wram_block_04_savestate, !wram_block_04_size)
