asar 1.91
lorom
check bankcross half

arch 65816

print "YI Practice Hack 1.0.1"
;=================================
incsrc region_check.asm
incsrc misc/macros.asm
;=================================
incsrc variables/base.asm
;=================================
incsrc hijacks/boot_hijack.asm
incsrc hijacks/interrupt_hijack.asm
incsrc hijacks/change_map16_hijack.asm
incsrc hijacks/map_hijack.asm
incsrc hijacks/level_load_hijack.asm
incsrc hijacks/mode7_boss_hijack.asm
incsrc hijacks/bank02_hijack.asm
incsrc hijacks/downtime_edits.asm
incsrc hijacks/misc_edits.asm
incsrc hijacks/debug_hijacks.asm
arch superfx
incsrc superfx/camera_hijack.asm
arch 65816
incsrc hijacks/game_loop_hijack.asm
;=================================
incsrc cfg/config.asm
incsrc cfg/check_bindings.asm
;=================================
incsrc superfx/base.asm
;=================================
incsrc savestates/save_state.asm
incsrc savestates/load_state.asm
incsrc savestates/upload_routines.asm
incsrc savestates/hard_fixes.asm
;=================================
incsrc misc/sram_boot_check.asm
incsrc music/toggle_music.asm
incsrc misc/load_gfx.asm
incsrc misc/level_intro_skip.asm
incsrc misc/egg_inventory.asm
incsrc misc/yoshi_colour.asm
;=================================
incsrc menu/cursor_stack.asm
incsrc menu/debug_menu.asm
incsrc menu/debug_control_data.asm
incsrc menu/debug_controls.asm
incsrc menu/debug_control_types.asm
incsrc menu/debug_control_draws.asm
incsrc menu/debug_tilemap_data.asm
incsrc menu/debug_tilemaps.asm
incsrc menu/debug_palettes.asm
;=================================
incsrc map/map_init.asm
;=================================
incsrc level/trainers.asm
incsrc level/level_init.asm
incsrc level/level_tick.asm
incsrc level/mode7_boss.asm
incsrc level/rezone.asm
;=================================
incsrc routines/frame_skip.asm
incsrc routines/warp_menu.asm
incsrc routines/disable_autoscroll.asm
incsrc routines/fix_camera.asm
incsrc routines/interrupt_handler.asm

print "ROM freespace bytes written: ", freespaceuse
print "Total bytes written: ", bytes
