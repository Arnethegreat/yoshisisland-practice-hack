; General Variables

!frame_counter = $0030
!gamemode = $0118
!r_interrupt_mode = $011C
!r_game_loop_complete = $011B
!level_load_type = $038C
!skip_kamek_flag_1 = $03AE
!skip_kamek_flag_2 = $03B0
!free_movement = $10DA
!free_movement_l = $7E10DA
!s_control_scheme = $6082
!s_control_scheme_l = $700082

; Game modes
!gm_npresentsload = $01
!gm_npresentsfadein = $02
!gm_cutscenefadeout = $08
!gm_title = $0A
!gm_levelfadeout = $0B
!gm_levelloading = $0C
!gm_level = $0F
!gm_goalring = $10
!gm_death = $11
!gm_starlessdeath = $12
!gm_overworldloading = $20
!gm_overworldfadein = $21
!gm_overworld = $22
!gm_postboss = $31
!gm_midringrestart = $35
!gm_retry = $3D

; Screen exit data
!screen_exit_level = $7F7E00
!screen_exit_xpos = $7F7E01
!screen_exit_ypos = $7F7E02
!screen_exit_type = $7F7E03
!current_screen = $038E

; Controller data
!controller_B      = %1000000000000000 ; $8000
!controller_Y      = %0100000000000000 ; $4000
!controller_select = %0010000000000000 ; $2000
!controller_start  = %0001000000000000 ; $1000
!controller_up     = %0000100000000000 ; $0800
!controller_down   = %0000010000000000 ; $0400
!controller_left   = %0000001000000000 ; $0200
!controller_right  = %0000000100000000 ; $0100
!controller_A      = %0000000010000000 ; $0080
!controller_X      = %0000000001000000 ; $0040
!controller_L      = %0000000000100000 ; $0020
!controller_R      = %0000000000010000 ; $0010

!controller_data1_A = %10000000
!controller_data1_X = %01000000
!controller_data1_L = %00100000
!controller_data1_R = %00010000
!controller_data2_B      = %10000000
!controller_data2_Y      = %01000000
!controller_data2_select = %00100000
!controller_data2_start  = %00010000
!controller_data2_up     = %00001000
!controller_data2_down   = %00000100
!controller_data2_left   = %00000010
!controller_data2_right  = %00000001

!controller_data1 = $0035 ; AXLR----
!controller_data2 = $0036 ; byetUDLR
!controller_data1_press = $0037
!controller_data2_press = $0038

!controller_2_data1 = $0940
!controller_2_data2 = $0941
!controller_2_data1_press = $0942
!controller_2_data2_press = $0943

!controller_data2_press_mode0f = $6072
!controller_data2_press_mode0f = $6073


;Item Memory
!item_mem_current_page = $03BE
; 128 bytes per page
!item_mem_page_size = $80
!item_mem_page0 = $03C0
!item_mem_page1 = $0440
!item_mem_page2 = $04C0
!item_mem_page3 = $0540

; Level Select
!world_num = $0218 ; world index * 2 (0000 = world 1, 0002 = world 2, etc.)
!level_num = $021A ; seems to store level index with the formula world*12+level, so 1-1 would be 0, 2-2 would be 13, 4-5 would be 40 ($28)

;Egg Inventory
!egg_inv_size = $7E5D98
!egg_inv_items = $7E5D9A

!egg_inv_size_cur = $7DF6
!egg_inv_items_cur = $7DF8

; Star/Coin/Flower Counter
!red_coin_count = $03B4
!star_count = $03B6
!flower_count = $03B8

; MAP16
!r_map16_table = $7F8000

; Sprite Despawn table
; 256 bytes
!sprite_despawn_table = $7028CA

; Yoshi Mouth item (melons)
!mouth_sprite_id = $6162
!mouth_melon_type = $616A
!mouth_melon_count = $6170

; Camera Positions
!r_camera_layer1_x = $0039
!r_camera_layer2_x = $003D
!r_camera_layer3_x = $0041
!r_camera_layer4_x = $0045

!r_camera_layer1_y = $003B
!r_camera_layer2_y = $003F
!r_camera_layer3_y = $0043
!r_camera_layer4_y = $0047

!s_camera_layer1_x = $6094
!s_camera_layer2_x = $6096
!s_camera_layer3_x = $6098
!s_camera_layer4_x = $609A

!s_camera_layer1_y = $609C
!s_camera_layer2_y = $609E
!s_camera_layer3_y = $60A0
!s_camera_layer4_y = $60A2

!r_camera_direction_x = $73
!r_camera_direction_y = $75

; Save Data
!r_cur_save_file = $030E

;Yoshi States / speed
!s_player_form = $60AE
!s_player_form_l = $7000AE

!pfrm_yoshi = $00
!pfrm_car = $02
!pfrm_mole = $04
!pfrm_heli = $06
!pfrm_train = $08
!pfrm_sub = $0C
!pfrm_ski = $0E
!pfrm_super = $10

!yoshi_x_pos = $608C
!yoshi_x_subpixel = $608A
!yoshi_y_pos = $6090
!yoshi_y_subpixel = $608E

!yoshi_x_speed = $60B4
!yoshi_y_speed = $60AA

; Yoshi Colour Palette
!yoshi_colour = $0383

; GFX
!r_header_bg1_tileset = $0136
!r_header_bg1_tileset_l = $7E0136

!r_header_bg1_palette = $0138
!r_header_bg1_palette_l = $7E0138

; SFX (see https://github.com/brunovalads/yoshisisland-disassembly/wiki/Sound-IDs)
!sound_immediate = $0053
!r_level_music_playing = $0205

!sfx_collect_egg = $03
!sfx_shell_01 = #$000B
!sfx_shell_06 = $10
!sfx_shell_07 = $11
!sfx_midway_tape = $19
!sfx_poof = $1D
!sfx_key_chink = $1E
!sfx_yoshi = $43
!sfx_move_cursor = $5C
!sfx_correct = $8F
!sfx_incorrect = $90

; (H)DMA
!r_hdma_indirect_table6 = $7E5D18

!s_rom_graphics_dma_addr = $6114
!s_rom_graphics_dma_addr_l = $700114

; IRQ
!r_irq_count = $0125

; RAM Mirrors
!r_apu_io_0_mirror = $004D
!r_apu_io_0_mirror_prev = $004F
!r_reg_inidisp_mirror = $0200
!r_reg_coldata_mirror = $0948
!r_reg_hdmaen_mirror = $094A
!r_reg_obsel_mirror = $094B
!r_reg_wbglog_mirror = $094C
!r_reg_wobjlog_mirror = $094D
!r_reg_m7sel_mirror = $094E
!r_reg_m7a_mirror = $094F
!r_reg_m7b_mirror = $0951
!r_reg_m7c_mirror = $0953
!r_reg_m7d_mirror = $0955
!r_reg_m7x_mirror = $0957
!r_reg_m7y_mirror = $0959
!r_reg_mosaic_mirror = $095B
!r_reg_bgmode_mirror = $095E
!r_reg_bg1sc_mirror = $095F
!r_reg_bg2sc_mirror = $0960
!r_reg_bg3sc_mirror = $0961
!r_reg_bg12nba_mirror = $0962
!r_reg_bg34nba_mirror = $0963
!r_reg_w12sel_mirror = $0964
!r_reg_w34sel_mirror = $0965
!r_reg_wobjsel_mirror = $0966
!r_reg_tm_mirror = $0967
!r_reg_ts_mirror = $0968
!r_reg_tmw_mirror = $0969
!r_reg_tsw_mirror = $096A
!r_reg_cgwsel_mirror = $096B
!r_reg_cgadsub_mirror = $096C

!s_cgram_mirror = $702000
