; Custom HUD vars
!vars_ram = $1800

!frames_passed = !vars_ram
!lag_counter = !vars_ram+1

!total_frames = !vars_ram+3

!level_frames = !vars_ram+5
!level_seconds = !vars_ram+6
!level_minutes = !vars_ram+7
!room_frames = !vars_ram+8
!room_seconds = !vars_ram+9
!room_minutes = !vars_ram+10
!timer_enabled = !vars_ram+11
!hud_enabled = !vars_ram+12
!hud_displayed = !vars_ram+13 ; the hud is not always shown even when it is enabled
!hud_displayed_backup = !vars_ram+14
!active_sprites = !vars_ram+15
!bg3_cam_x_backup = !vars_ram+16
!bg3_cam_y_backup = !vars_ram+18
!hud_hdma_table_h_channel = !vars_ram+20
!hud_hdma_table_h_channel_dp = 20
!hud_hdma_table_v_channel = !vars_ram+22
!hud_hdma_table_v_channel_dp = $00+22
!hud_hdma_channels = !vars_ram+24
!null_egg_mode_enabled = !vars_ram+25

!hud_buffer = $1E00

; Custom HUD consts
!irq_v = $20 ; scanline for custom irq 2 (bottom of the hud)
!nmi_v = $D8 ; scanline for NMI
!hud_hofs = #$0000 ; 0
!hud_vofs = #$FFF7 ; 1015 (effectively -9)
