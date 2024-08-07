; data structure for each control as follows:

; [byte] type of control:
!dbc_type = $00
!ct_nib = $00 ; nibble memory changer (wildcard as hi ($F0) or lo ($0F))
!ct_eggcount = $02 ; egg count memory changer, max 6
!ct_toggle = $04 ; toggle (wildcard as value for enable)
!ct_egg = $06 ; egg inventory editor (wildcard as egg number)
!ct_func = $08 ; call function (wildcard as what function)
!ct_warps = $0A ; warp navigation (wildcard as index)
!ct_submenu = $0C ; submenu
!ct_binding = $0E ; input binding changer (wildcard indicates which controller)

; [long] memory address to read / write from - currently only used for [nib, toggle, binding]
!dbc_memory = $01

; [word] relative tilemap address (offset from start of tilemap mirror)
!dbc_tilemap = $04

; [word] wildcard
!dbc_wildcard = $06

macro define_menu_entry(type, addr, xpos, ypos, wildcard)
  db <type>
  dl <addr>
  dw <ypos>*!tilemap_line_width+<xpos>*2+$40
  dw <wildcard>
endmacro

!dbc_meta_size = datasize(mainmenu_ctrl_metadata)
!dbc_meta_colcounts_offset = $00
!dbc_meta_ctrlcount = $02
!dbc_meta_rowcount = $03
!dbc_meta_tilemap_ptr = $04
!dbc_meta_palette_ptr = $06
!dbc_meta_parent_ptr = $08
macro define_menu_metadata(label, tilemap_label, palette_label, parent_data)
  dw <label>_column_counts-<label> ; offset of column counts from the start of the menu block
  db datasize(<label>_data)>>3     ; total ctrl count
  db datasize(<label>_column_counts)>>1 ; total row count
  dw <tilemap_label> ; address of the tilemap data associated with this set of controls
  dw <palette_label> ; address of the palette data associated with this set of controls (if any)
  dw <parent_data> ; address of the data "above" this submenu
endmacro

store_current_menu_metadata:
  PHP
  %ai16()
  LDX !current_menu_data_ptr
  LDA.w !dbc_meta_ctrlcount,x : AND #$00FF : STA !dbc_count_current
  LDA.w !dbc_meta_rowcount,x : AND #$00FF : STA !dbc_row_count_current
  LDA.w !dbc_meta_tilemap_ptr,x : STA !current_menu_tilemap_ptr
  LDA.w !dbc_meta_palette_ptr,x : STA !current_menu_palette_ptr
  LDA.w !dbc_meta_parent_ptr,x : STA !parent_menu_data_ptr
.ret
  PLP
  RTS

mainmenu_ctrl:
.metadata
  %define_menu_metadata(mainmenu_ctrl, mainmenu_tilemap, $0000, $0000)
.data
  %define_menu_entry(!ct_submenu, $7E0000, 1, 1, submenu_gamemods_ctrl) ; gameplay mods submenu
  %define_menu_entry(!ct_warps, $7E0000, 1, 2, $01) ; warps submenu
  %define_menu_entry(!ct_eggcount, !debug_egg_count_mirror_l, 1, 3, $00) ; egg count
  %define_menu_entry(!ct_egg, $7E0000, 3, 3, $00) ; egg 1
  %define_menu_entry(!ct_egg, $7E0000, 4, 3, $01) ; egg 2
  %define_menu_entry(!ct_egg, $7E0000, 5, 3, $02) ; egg 3
  %define_menu_entry(!ct_egg, $7E0000, 6, 3, $03) ; egg 4
  %define_menu_entry(!ct_egg, $7E0000, 7, 3, $04) ; egg 5
  %define_menu_entry(!ct_egg, $7E0000, 8, 3, $05) ; egg 6
  %define_menu_entry(!ct_toggle, !full_load_default, 1, 4, $01) ; full load as default
  %define_menu_entry(!ct_toggle, !zone_reset_flag_l, 1, 5, $01) ; level or room reset
  %define_menu_entry(!ct_nib, !load_delay_timer_init, 1, 6, $F0) ; load delay amount high
  %define_menu_entry(!ct_nib, !load_delay_timer_init, 2, 6, $0F) ; load delay amount low
  %define_menu_entry(!ct_toggle, !hud_enabled_l, 1, 7, $01) ; HUD
  %define_menu_entry(!ct_nib, !ramwatch_addr_l+2, 1, 8, $F0) ; ramwatch bank
  %define_menu_entry(!ct_nib, !ramwatch_addr_l+2, 2, 8, $0F) ; ramwatch bank
  %define_menu_entry(!ct_nib, !ramwatch_addr_l+1, 3, 8, $F0) ; ramwatch high
  %define_menu_entry(!ct_nib, !ramwatch_addr_l+1, 4, 8, $0F) ; ramwatch high
  %define_menu_entry(!ct_nib, !ramwatch_addr_l+0, 5, 8, $F0) ; ramwatch low
  %define_menu_entry(!ct_nib, !ramwatch_addr_l+0, 6, 8, $0F) ; ramwatch low
  %define_menu_entry(!ct_submenu, $7E0000, 1, 9, submenu_config_ctrl) ; input config submenu
.column_counts ; low byte = number of columns per row index (zero-based), high byte = cumulative sum
  dw $0000, $0100, $0206, $0900, $0A00, $0B01, $0D00, $0E05, $1400

submenu_gamemods_ctrl:
.metadata
  %define_menu_metadata(submenu_gamemods_ctrl, submenu_gamemods_tilemap, $0000, mainmenu_ctrl)
.data
  %define_menu_entry(!ct_submenu, $7E0000, 1, 1, $00) ; back
  %define_menu_entry(!ct_func, $7E0000, 1, 2, $00) ; disable autoscroll
  %define_menu_entry(!ct_toggle, !disable_music, 1, 3, $01) ; disable music
  %define_menu_entry(!ct_toggle, !free_movement_l, 1, 4, $01) ; free movement
  %define_menu_entry(!ct_toggle, $7E0372, 1, 5, $E0) ; set tutorial flags
  %define_menu_entry(!ct_toggle, !skip_kamek, 1, 6, $01) ; disable kamek at boss
  %define_menu_entry(!ct_toggle, !debug_control_scheme, 1, 7, $02) ; force hasty
  %define_menu_entry(!ct_nib, !slowdown_mag_l, 1, 8, $F0) ; slowdown amount high
  %define_menu_entry(!ct_nib, !slowdown_mag_l, 2, 8, $0F) ; slowdown amount low
  %define_menu_entry(!ct_toggle, !frame_skip_pause_l, 1, 9, $01) ; frame advance
.column_counts
  dw $0000, $0100, $0200, $0300, $0400, $0500, $0600, $0701, $0900

submenu_config_ctrl:
.metadata
  %define_menu_metadata(submenu_config_ctrl, submenu_config_tilemap, submenu_config_palette, mainmenu_ctrl)
.data
  %define_menu_entry(!ct_submenu, $7E0000, 1, 1, $00) ; back
  %define_menu_entry(!ct_func, $7E0000, 18, 1, $01) ; reset to default
  %define_menu_entry(!ct_binding, !bind_savestate_1, 1, 3, $00)
  %define_menu_entry(!ct_binding, !bind_savestate_2, 9, 3, $01)
  %define_menu_entry(!ct_binding, !bind_loadstate_1, 1, 4, $00)
  %define_menu_entry(!ct_binding, !bind_loadstate_2, 9, 4, $01)
  %define_menu_entry(!ct_binding, !bind_loadstatefull_1, 1, 5, $00)
  %define_menu_entry(!ct_binding, !bind_loadstatefull_2, 9, 5, $01)
  %define_menu_entry(!ct_binding, !bind_loadstateroom_1, 1, 6, $00)
  %define_menu_entry(!ct_binding, !bind_loadstateroom_2, 9, 6, $01)
  %define_menu_entry(!ct_binding, !bind_musictoggle_1, 1, 7, $00)
  %define_menu_entry(!ct_binding, !bind_musictoggle_2, 9, 7, $01)
  %define_menu_entry(!ct_binding, !bind_freemovement_1, 1, 8, $00)
  %define_menu_entry(!ct_binding, !bind_freemovement_2, 9, 8, $01)
  %define_menu_entry(!ct_binding, !bind_slowdowndecrease_1, 1, 9, $00)
  %define_menu_entry(!ct_binding, !bind_slowdowndecrease_2, 9, 9, $01)
  %define_menu_entry(!ct_binding, !bind_slowdownincrease_1, 1, 10, $00)
  %define_menu_entry(!ct_binding, !bind_slowdownincrease_2, 9, 10, $01)
  %define_menu_entry(!ct_binding, !bind_frameadvance_1, 1, 11, $00)
  %define_menu_entry(!ct_binding, !bind_frameadvance_2, 9, 11, $01)
  %define_menu_entry(!ct_binding, !bind_disableautoscroll_1, 1, 12, $00)
  %define_menu_entry(!ct_binding, !bind_disableautoscroll_2, 9, 12, $01)
.column_counts
  dw $0001, $0201, $0401, $0601, $0801, $0A01, $0C01, $0E01, $1001, $1201, $1401

; each control is the same, so just store a count for each page (max = $0B)
!debug_menu_controls_warps_worlds_count = #$0007
!debug_menu_controls_warps_levels_count = #$000A
debug_menu_controls_warps_room_counts:
  db $02, $03, $05, $06, $01, $08, $03, $06, $01 ; world 1
  db $05, $03, $03, $0A, $06, $06, $08, $0B, $02 ; world 2
  db $04, $03, $06, $0B, $04, $04, $06, $05, $02 ; world 3
  db $05, $06, $03, $0B, $03, $06, $03, $08, $09 ; world 4
  db $05, $04, $08, $08, $04, $03, $04, $07, $05 ; world 5
  db $04, $03, $03, $06, $03, $06, $05, $09, $07 ; world 6


;======================================

; indexed by wilcard for control type !ct_func
control_function_calls:
  dw disable_autoscroll
  dw set_default_input_bindings_and_draw

;======================================

set_default_input_bindings_and_draw:
  JSR default_input_bindings
  STZ !prep_binds_flag
  JSR init_controls ; re-draw
  RTS
