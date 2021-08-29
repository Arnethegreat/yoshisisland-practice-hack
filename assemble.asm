print "YI Practice Hack 0.3.1"
;=================================
incsrc region_check.asm
incsrc config.asm
;=================================
incsrc variables/debug_vars.asm
incsrc variables/game_vars.asm
incsrc variables/sprite_table_vars.asm
incsrc variables/reg_vars.asm
incsrc variables/savestate_vars.asm

;=================================
incsrc hijacks/save_level_hijack.asm
;=================================
incsrc hijacks/level_load_hijack.asm
;=================================
incsrc hijacks/downtime_edits.asm
;=================================
incsrc hijacks/debug_hijacks.asm
;=================================
incsrc hijacks/game_loop_hijack.asm
;=================================

;=================================
incsrc savestates/save_state.asm
incsrc savestates/load_state.asm
incsrc savestates/upload_routines.asm
incsrc savestates/hard_fixes.asm
;=================================
incsrc music/toggle_music.asm
;=================================
incsrc menu/debug_menu.asm
incsrc menu/debug_control_data.asm
incsrc menu/debug_controls.asm
incsrc menu/debug_control_types.asm
incsrc menu/debug_control_draws.asm
incsrc menu/debug_tilemap_data.asm
;=================================
incsrc routines/frame_skip.asm
incsrc routines/boss_room_warp.asm
incsrc routines/warp_menu.asm
incsrc routines/disable_autoscroll.asm
incsrc routines/fix_camera.asm
;=================================
incsrc misc/save_file_init.asm

print bytes