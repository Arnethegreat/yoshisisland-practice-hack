; data structure for each control as follows:

; [byte] type of control:
!dbc_type = $00
!ct_lonib = $00 ; low nibble memory changer (wildcard $xxyy xx = min, yy = max)
!ct_hinib = $02 ; high nibble memory changer (wildcard $xxyy xx = min, yy = max)
!ct_toggle = $04 ; toggle (wildcard as value for enable)
!ct_egg = $06 ; egg inventory editor (wildcard as egg number)
!ct_func = $08 ; call function (wildcard as what function)
!ct_warps = $0A ; warp navigation (wildcard as index)
!ct_submenu = $0C ; submenu
!ct_binding = $0E ; input binding changer (wildcard indicates which controller)

; [long] memory address to read / write from - currently only used for [lownib, highnib, toggle]
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
  %define_menu_entry(!ct_submenu, $7E0000, 1, 1, submenu_gameflags_ctrl) ; gameplay mods submenu
  %define_menu_entry(!ct_warps, $7E0000, 1, 2, $0001) ; warps submenu
  %define_menu_entry(!ct_lonib, !debug_egg_count_mirror_l, 1, 3, $0006) ; egg count
  %define_menu_entry(!ct_egg, $7E0000, 3, 3, $0000) ; egg 1
  %define_menu_entry(!ct_egg, $7E0000, 4, 3, $0001) ; egg 2
  %define_menu_entry(!ct_egg, $7E0000, 5, 3, $0002) ; egg 3
  %define_menu_entry(!ct_egg, $7E0000, 6, 3, $0003) ; egg 4
  %define_menu_entry(!ct_egg, $7E0000, 7, 3, $0004) ; egg 5
  %define_menu_entry(!ct_egg, $7E0000, 8, 3, $0005) ; egg 6
  %define_menu_entry(!ct_hinib, $7E012F, 1, 4, $00F0) ; slowdown amount high
  %define_menu_entry(!ct_lonib, $7E012F, 2, 4, $000F) ; slowdown amount low
  %define_menu_entry(!ct_toggle, !full_load_default, 1, 5, $0001) ; full load as default
  %define_menu_entry(!ct_hinib, !load_delay_timer_init, 1, 6, $00F0) ; load delay amount high
  %define_menu_entry(!ct_lonib, !load_delay_timer_init, 2, 6, $000F) ; load delay amount low
  %define_menu_entry(!ct_toggle, !hud_enabled_l, 1, 7, $0001) ; HUD
  %define_menu_entry(!ct_hinib, !ramwatch_addr_l+2, 1, 8, $00F0) ; ramwatch bank
  %define_menu_entry(!ct_lonib, !ramwatch_addr_l+2, 2, 8, $000F) ; ramwatch bank
  %define_menu_entry(!ct_hinib, !ramwatch_addr_l+1, 3, 8, $00F0) ; ramwatch high
  %define_menu_entry(!ct_lonib, !ramwatch_addr_l+1, 4, 8, $000F) ; ramwatch high
  %define_menu_entry(!ct_hinib, !ramwatch_addr_l+0, 5, 8, $00F0) ; ramwatch low
  %define_menu_entry(!ct_lonib, !ramwatch_addr_l+0, 6, 8, $000F) ; ramwatch low
  %define_menu_entry(!ct_submenu, $7E0000, 1, 9, submenu_config_ctrl) ; input config submenu
.column_counts ; low byte = number of columns per row index (zero-based), high byte = cumulative sum
  dw $0000, $0100, $0206, $0901, $0B00, $0C01, $0E00, $0F05, $1500

submenu_gameflags_ctrl:
.metadata
  %define_menu_metadata(submenu_gameflags_ctrl, submenu_gameflags_tilemap, $0000, mainmenu_ctrl)
.data
  %define_menu_entry(!ct_submenu, $7E0000, 1, 1, $0000) ; back
  %define_menu_entry(!ct_func, $7E0000, 1, 2, $0000) ; disable autoscroll
  %define_menu_entry(!ct_toggle, !disable_music, 1, 3, $0001) ; disable music
  %define_menu_entry(!ct_toggle, !free_movement_l, 1, 4, $0001) ; free movement
  %define_menu_entry(!ct_toggle, $7E0372, 1, 5, $00E0) ; set tutorial flags
  %define_menu_entry(!ct_toggle, !skip_kamek, 1, 6, $0001) ; disable kamek at boss
  %define_menu_entry(!ct_toggle, !debug_control_scheme, 1, 7, $0002) ; force hasty
.column_counts
  dw $0000, $0100, $0200, $0300, $0400, $0500, $0600

submenu_config_ctrl:
.metadata
  %define_menu_metadata(submenu_config_ctrl, submenu_config_tilemap, submenu_config_palette, mainmenu_ctrl)
.data
  %define_menu_entry(!ct_submenu, $7E0000, 1, 1, $0000) ; back
  %define_menu_entry(!ct_func, $7E0000, 18, 1, $0001) ; reset to default
  %define_menu_entry(!ct_binding, !bind_savestate_1, 1, 3, $0000)
  %define_menu_entry(!ct_binding, !bind_savestate_2, 9, 3, $0001)
  %define_menu_entry(!ct_binding, !bind_loadstate_1, 1, 4, $0000)
  %define_menu_entry(!ct_binding, !bind_loadstate_2, 9, 4, $0001)
  %define_menu_entry(!ct_binding, !bind_loadstatefull_1, 1, 5, $0000)
  %define_menu_entry(!ct_binding, !bind_loadstatefull_2, 9, 5, $0001)
  %define_menu_entry(!ct_binding, !bind_loadstateroom_1, 1, 6, $0000)
  %define_menu_entry(!ct_binding, !bind_loadstateroom_2, 9, 6, $0001)
  %define_menu_entry(!ct_binding, !bind_musictoggle_1, 1, 7, $0000)
  %define_menu_entry(!ct_binding, !bind_musictoggle_2, 9, 7, $0001)
  %define_menu_entry(!ct_binding, !bind_freemovement_1, 1, 8, $0000)
  %define_menu_entry(!ct_binding, !bind_freemovement_2, 9, 8, $0001)
  %define_menu_entry(!ct_binding, !bind_slowdowndecrease_1, 1, 9, $0000)
  %define_menu_entry(!ct_binding, !bind_slowdowndecrease_2, 9, 9, $0001)
  %define_menu_entry(!ct_binding, !bind_slowdownincrease_1, 1, 10, $0000)
  %define_menu_entry(!ct_binding, !bind_slowdownincrease_2, 9, 10, $0001)
  %define_menu_entry(!ct_binding, !bind_disableautoscroll_1, 1, 11, $0000)
  %define_menu_entry(!ct_binding, !bind_disableautoscroll_2, 9, 11, $0001)
.column_counts
  dw $0001, $0201, $0401, $0601, $0801, $0A01, $0C01, $0E01, $1001, $1201

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
