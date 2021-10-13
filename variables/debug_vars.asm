@includeonce

%var_026A(debug_egg_count_mirror, 2)
%var_026A(debug_egg_inv_mirror, 12)

%var_026A(debug_menu, 2)
%var_026A(debug_index, 2)
%var_026A(debug_base, 8)

; backups
%var_026A(bg1_backup, 2)
%var_026A(bg2_backup, 2)
%var_026A(hdma_backup, 2)
%var_026A(irq_mode_1_backup, 1)
%var_026A(irq_mode_2_backup, 1)
%var_026A(bg_color_backup, 2)
%var_026A(bg1_tilemap_backup, 1)
%var_026A(bg1_char_backup, 1)
%var_026A(bgmode_backup, 1)

; 28 rows
; 1792 bytes
!menu_tilemap_mirror = $7EB8E2
!menu_tilemap_size = #$0700

%var_026A(warps_page_depth_index, 2) ; current page depth --  0: main menu,   1: world select,   2: level select,   3: room warp select
%var_026A(warps_current_world_index, 2)
%var_026A(warps_current_level_index, 2)
%var_026A(warps_current_world_level_index, 2)

%var_026A(debug_controls_count_current, 2)
!debug_controls_count = #$0011

%var_026A(warping, 2) ; additional flag for signaling that the menu should quit out
%var_026A(skip_baby_bowser, 2)
%var_026A(skip_kamek, 2)

; palette
%var_1409(palette_anim_timer, 2)
!palette_backup_size = $0038
%var_1409(palette_backup, !palette_backup_size)
