includeonce

; Custom HUD vars
!hud_buffer_size = $00C0 ; 3 lines * 64 bytes per line = 192 ($C0) bytes
%var_1E00(hud_buffer, !hud_buffer_size) ; this should be the first 1E00 var since it's a buffer and can take advantage of DP at page 00

%var_1409(frames_passed, 2) ; this could be 1 byte, but 2 allows us to skip having to AND #$00FF in tick_timers
%var_1409(lag_counter, 2)
%var_1409(save_lag_counter, 2)
%var_1409(total_frames, 2)
%var_1409(level_frames, 1) ; frames/seconds/minutes must be defined consecutively in this order due to the implementation of add_frames_to_timer
%var_1409(level_seconds, 1)
%var_1409(level_minutes, 1)
%var_1409(save_level_frames, 1)
%var_1409(save_level_seconds, 1)
%var_1409(save_level_minutes, 1)
%var_1409(room_frames, 1)
%var_1409(room_seconds, 1)
%var_1409(room_minutes, 1)
%var_1409(save_room_frames, 1)
%var_1409(save_room_seconds, 1)
%var_1409(save_room_minutes, 1)
%var_1409(slow_frames, 2)
%var_1409(save_slow_frames, 2)
%var_1409(hud_enabled, 1)
!hud_enabled_l = $7E0000+!hud_enabled
%var_1409(hud_displayed, 1) ; the hud is not always shown even when it is enabled
%var_1409(active_sprites, 1)
; use freespace in page $00 for DP optimisation
%var_00CC(irq_bg3_cam_x_backup, 2)
%var_00CC(irq_bg3_cam_y_backup, 2)
%var_00CC(irq_bgmode_backup, 1)
%var_00CC(irq_bg3sc_backup, 1)
%var_00CC(irq_bg34nba_backup, 1)
%var_00CC(irq_tm_backup, 1)
%var_00CC(irq_ts_backup, 1)
%var_1409(hud_hdma_channel, 1)
%var_1409(hud_fixed_bg3hofs, 2)
%var_1409(hud_fixed_bg3hofs_flag, 1)
%var_1409(hud_fixed_bg3vofs, 2)
%var_1409(hud_fixed_bg3vofs_flag, 1)
%var_1409(hud_fixed_tm, 1)
%var_1409(null_egg_mode_enabled, 1)

%var_1409(trainer_state, 2)
%var_1409(trainer_timer, 2)
%var_1409(trainer_result, 2)

; Custom HUD consts
!irq_v = $20 ; scanline for custom irq 2 (bottom of the hud)
!nmi_v = $D8 ; scanline for NMI
!hud_hofs = $0000 ; 0
!hud_vofs = $FFF7 ; 1015 (effectively -9)
