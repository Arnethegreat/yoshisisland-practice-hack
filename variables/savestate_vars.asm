!loaded_state = $140A
!savestate_exists = $140C

!disable_music = $140E

!current_level = $1410

!full_load_default = $1412

!last_exit_1 = $1414
!last_exit_2 = $1416

!last_exit_item_page = $1418

!last_exit_stars = $141A
!last_exit_red_coins = $141C
!last_exit_flowers = $141E

; 14 bytes
!last_exit_eggs = $150C
; not useful?
!last_exit_load_type = $151A

!last_exit_loading_flag = $151C
; 128 bytes
!last_exit_item_mem_backup = $151E

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
; Add some kamek timer stuff @ $44F0
;

; $0000 -> $2200 
!sram_block_00_source = $700000
!sram_block_00_savestate = $7F0300
!sram_block_00_size = #$2200

; $2600 -> $409E 
!sram_block_01_source = $702600
!sram_block_01_savestate = $7F2500
!sram_block_01_size = #$1A9E

; $49C6 -> $49E8
; sluggy/froggy wall stuff
!sram_block_02_source = $7049C6
!sram_block_02_savestate = $7F3F9E
!sram_block_02_size = #$0022

; $4C76 -> $4CB4
; sluggy info
!sram_block_03_source = $704C76
!sram_block_03_savestate = $7F3FC0
!sram_block_03_size = #$003E

; $4C76 -> $4CB4
; sluggy info
!sram_block_04_source = $70449E
!sram_block_04_savestate = $7F4B2C
!sram_block_04_size = #$0080

; WRAM blocks
;

; $0300 -> $03C0
!wram_block_00_source = $7E0300
!wram_block_00_savestate = $7F3FFE
!wram_block_00_size = #$00C0

; $0948 -> $11B6 
!wram_block_01_source = $7E0948
!wram_block_01_savestate = $7F40BE
!wram_block_01_size = #$086E

; $0200 -> $0222
!wram_block_02_source = $7E0200
!wram_block_02_savestate = $7F492C
!wram_block_02_size = #$0022

; $0030 -> $015E
!wram_block_03_source = $7E0030
!wram_block_03_savestate = $7F494E
!wram_block_03_size = #$012E



