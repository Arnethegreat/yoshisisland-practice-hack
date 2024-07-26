%var_1409(loaded_state, 2)
%var_1409(savestate_exists, 2)
%var_1409(current_level, 2)
%var_707E7E(full_load_default, 1)
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
%var_1409(last_exit_item_page, 2)
%var_1409(last_exit_stars, 2)
%var_1409(last_exit_red_coins, 2)
%var_1409(last_exit_flowers, 2)
%var_1409(last_exit_eggs, 14)
%var_1409(last_exit_load_type, 2)
%var_1409(last_exit_loading_flag, 2)
%var_1409(last_exit_item_mem_backup, 128)
%var_1409(load_delay_timer, 1)
%var_707E7E(load_delay_timer_init, 1) ; keep in SRAM for persistence

; persistent save data (keeps on reset)
; stuff used throughout
%var_707E7E(save_level, 2)
%var_707E7E(save_x_pos, 2)
%var_707E7E(save_y_pos, 2)
%var_707E7E(save_camera_layer1_x, 2)
%var_707E7E(save_camera_layer1_y, 2)

;=================================

; item memory
; 128 bytes per page
!save_item_mem_current_page = $7F00FE
!save_item_mem_page0 = $7F0100
!save_item_mem_page1 = $7F0180
!save_item_mem_page2 = $7F0200
!save_item_mem_page3 = $7F0280

;=================================

; SRAM blocks
; Add some kamek timer stuff @ $44F0
;

; $0000 -> $2200 
!sram_block_00_source = $700000
!sram_block_00_savestate = $7F0300
!sram_block_00_size = $2200

; $2600 -> $409E 
!sram_block_01_source = $702600
!sram_block_01_savestate = $7F2500
!sram_block_01_size = $1A9E

; $49C6 -> $49E8
; sluggy/froggy wall stuff
!sram_block_02_source = $7049C6
!sram_block_02_savestate = $7F3F9E
!sram_block_02_size = $0022

; $4C76 -> $4CB4
; sluggy info
!sram_block_03_source = $704C76
!sram_block_03_savestate = $7F3FC0
!sram_block_03_size = $003E

; $4C76 -> $4CB4
; sluggy info
!sram_block_04_source = $70449E
!sram_block_04_savestate = $7F4B2C
!sram_block_04_size = $0080

!sram_map16_source = $70409E
!sram_map16_savestate = $7E2340
!sram_map16_size = $0400

!sram_dyntile_source = $705800
!sram_dyntile_savestate = $7E2740
!sram_dyntile_size = $0800

; WRAM blocks
;

; $0300 -> $03C0
!wram_block_00_source = $7E0300
!wram_block_00_savestate = $7F3FFE
!wram_block_00_size = $00C0

; $0948 -> $11B6 
!wram_block_01_source = $7E0948
!wram_block_01_savestate = $7F40BE
!wram_block_01_size = $086E

; $0202 -> $0222
!wram_block_02_source = $7E0202
!wram_block_02_savestate = $7F492C
!wram_block_02_size = $0020

; $0030 -> $004D (avoid sound stuff since we don't save APU state)
!wram_block_03_source = $7E0030
!wram_block_03_savestate = $7F494E
!wram_block_03_size = $001D

; $0069 -> $015E
!wram_block_04_source = $7E0069
!wram_block_04_savestate = $7F496B
!wram_block_04_size = $00F5


