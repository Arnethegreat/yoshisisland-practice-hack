includeonce

%var_0272(debug_egg_count_mirror, 2)
!debug_egg_count_mirror_l = $7E0000+!debug_egg_count_mirror
%var_0272(debug_egg_inv_mirror, 12)

%var_0272(debug_menu, 2)
%var_0272(dbc_index_row, 2)
%var_0272(dbc_index_col, 2)
%var_0272(debug_base, 8)

; backups
%var_0272(bg1_backup, 2)
%var_0272(bg2_backup, 2)
%var_0272(hdma_backup, 2)
%var_0272(irq_mode_1_backup, 1)
%var_0272(irq_mode_2_backup, 1)
%var_0272(bg_color_backup, 2)
%var_0272(bg1_tilemap_backup, 1)
%var_0272(bg1_char_backup, 1)
%var_0272(bgmode_backup, 1)

!debug_bg1_tilemap_dest = $64 ; VRAM word address $6400
!debug_bg1_tilemap_dest_full = !debug_bg1_tilemap_dest<<8
!debug_bg1_tile_dest = $06 ; VRAM word address $6000
!debug_bg1_tile_dest_full = !debug_bg1_tile_dest<<12

; 28 rows
; 1792 bytes
!menu_tilemap_mirror = $7EB8E2
!menu_tilemap_size = #$0700
!tilemap_line_width_single = $0040
!tilemap_line_width = !tilemap_line_width_single*2
!first_option_tilemap_dest = $00C2

%var_0272(warps_page_depth_index, 2) ; current page depth --  0: main menu,   1: world select,   2: level select,   3: room warp select
%var_0272(warps_current_world_index, 2)
%var_0272(warps_current_level_index, 2)
%var_0272(warps_current_world_level_index, 2)

%var_0272(parent_menu_data_ptr, 2)
%var_0272(current_menu_data_ptr, 2)
%var_0272(current_menu_tilemap_ptr, 2)
%var_0272(current_menu_palette_ptr, 2)
%var_0272(dbc_count_current, 2)
%var_0272(dbc_row_count_current, 2)
%var_0272(dbc_col_count_current, 2)

%var_0272(warping, 2) ; additional flag for signaling that the menu should quit out
%var_0272(skip_baby_bowser, 2)
%var_707E7E(skip_kamek, 2)
%var_707E7E(debug_control_scheme, 1)

%var_0272(ramwatch_addr, 3)
!ramwatch_addr_l = $7E0000+!ramwatch_addr

; palette
%var_1409(palette_anim_timer, 2)
!palette_backup_size = $0040
%var_1409(palette_backup, !palette_backup_size)


%var_1409(input_repeat_delay_timer, 2)
!input_repeat_delay_amount = #$0012

; input binds
%var_1409(prep_binds_flag, 1)
%var_1409(recording_bind_state, 1)
%var_1409(recording_held_value, 2)
%var_1409(recording_pressed_value, 2)
%var_1409(recording_btn_count, 1)

%var_1409(is_audio_fixed, 1)
%var_1409(current_music_track, 1)

!slowdown_mag = $012F
!frame_skip_timer = $0130
%var_1409(frame_skip_pause, 1)
!frame_skip_pause_l = $7E0000+!frame_skip_pause
