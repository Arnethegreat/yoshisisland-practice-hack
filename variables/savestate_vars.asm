!loaded_state = $140A
!savestate_exists = $140C

!disable_music = $140E

!current_level = $1410
; persistent save data (keeps on reset)
; stuff used throughout
    !save_level = $707F0A
    !save_x_pos = $707F0C
    !save_y_pos = $707F0E

    !save_camera_layer1_x = $707F10
    !save_camera_layer1_y = $707F12

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
;

; $0000 -> $2200 
!sram_block_00_source = $700000
!sram_block_00_savestate = $7F0300
!sram_block_00_size = #$2200

; $2600 -> $449E 
!sram_block_01_source = $702600
!sram_block_01_savestate = $7F2500
!sram_block_01_size = #$1A9E

; Not used
!sram_block_02_source = $700B0F
!sram_block_02_savestate = $7F439E
!sram_block_02_size = #$0000

; Not used
!sram_block_03_source = $70409E
!sram_block_03_savestate = $7F3E96
!sram_block_03_savestate = $7F3E96
!sram_block_03_size = #$0000

; WRAM blocks
;

; $0306 -> $03BE
!wram_block_00_source = $7E0306
!wram_block_00_savestate = $7F0000
!wram_block_00_size = #$01BE

; $0B0F -> $11B7 
!wram_block_01_source = $7E0B0F
!wram_block_01_savestate = $7F439E
!wram_block_01_size = #$06A8

; Register mirrors test
!wram_block_02_source = $7E094A
!wram_block_02_savestate = $7F4A46
!wram_block_02_size = #$0024

; Not used
!wram_block_03_source = $70409E
!wram_block_03_savestate = $7F3E96
!wram_block_03_size = #$0000



