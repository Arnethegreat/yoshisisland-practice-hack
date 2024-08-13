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
  %define_menu_entry(!ct_binding, !bind_freemovement_1, 1, 7, $00)
  %define_menu_entry(!ct_binding, !bind_freemovement_2, 9, 7, $01)
  %define_menu_entry(!ct_binding, !bind_slowdowndecrease_1, 1, 8, $00)
  %define_menu_entry(!ct_binding, !bind_slowdowndecrease_2, 9, 8, $01)
  %define_menu_entry(!ct_binding, !bind_slowdownincrease_1, 1, 9, $00)
  %define_menu_entry(!ct_binding, !bind_slowdownincrease_2, 9, 9, $01)
  %define_menu_entry(!ct_binding, !bind_frameadvance_1, 1, 10, $00)
  %define_menu_entry(!ct_binding, !bind_frameadvance_2, 9, 10, $01)
  %define_menu_entry(!ct_binding, !bind_disableautoscroll_1, 1, 11, $00)
  %define_menu_entry(!ct_binding, !bind_disableautoscroll_2, 9, 11, $01)
.column_counts
  dw $0001, $0201, $0401, $0601, $0801, $0A01, $0C01, $0E01, $1001, $1201

;======================================

; indexed by wilcard for control type !ct_func
control_function_calls:
  dw disable_autoscroll
  dw set_default_input_bindings_and_draw

; each control is the same, so just store a count for each page (max = $0B)
!debug_menu_controls_warps_worlds_count = #$0007
!debug_menu_controls_warps_levels_count = #$000A
debug_menu_controls_warps_room_counts:
  db $02, $03, $05, $05, $01, $08, $03, $06, $01 ; world 1
  db $05, $03, $03, $0A, $06, $06, $08, $0B, $02 ; world 2
  db $04, $03, $06, $0B, $04, $04, $06, $05, $02 ; world 3
  db $05, $06, $03, $0B, $03, $06, $03, $08, $09 ; world 4
  db $05, $04, $08, $08, $04, $03, $04, $07, $05 ; world 5
  db $04, $03, $03, $06, $03, $06, $05, $09, $07 ; world 6

;======================================
; Warp destinations
; can only currently fit 12 options on a page, so including back and start, each level can have 10 room warps max
; should be plenty, but if really needed we could have scrolling or multiple pages per level or something

; 1st column entries:
;   1 low byte  = room ID
;   2 high byte = entry x-pos
; 2nd column entries:
;   3 low byte  = entry y-pos
;   4 high byte = entrance type:
;       00: normal, 01: skiing, 02: right from pipe, 03: left from pipe, 04: down from pipe, 05: up from pipe
;       06: walk right, 07: walk left, 08: drop down, 09: jump up, 0A: moon

warp_data_level_11: ; 00
  db $3A, $03, $62, $04  ; Cave (Left)
warp_data_level_12: ; 01
  db $3B, $17, $5E, $09  ; 2nd Room
  db $01, $A4, $70, $00  ; Goal Room
warp_data_level_13: ; 02
  db $3C, $03, $5F, $04  ; 2nd Room (Cave)
  db $6D, $2F, $10, $00  ; Bonus
  db $3C, $D4, $5E, $09  ; 2nd Room (From Bonus Left)
  db $02, $30, $77, $06  ; Goal Room
warp_data_level_14: ; 03
  db $03, $17, $40, $00  ; 2nd Room
  db $99, $1D, $72, $00  ; Bonus
  db $6E, $C4, $6A, $00  ; Pre-Boss Room
  db $3D, $05, $63, $00  ; Boss
warp_data_level_15: ; 04
warp_data_level_16: ; 05
  db $05, $02, $4A, $00  ; Bonus (Cloud)
  db $9A, $06, $40, $04  ; 2nd Room (Cave)
  db $05, $44, $7B, $00  ; 3rd Room
  db $6F, $02, $55, $04  ; Mole Tank Room
  db $05, $88, $74, $00  ; 3rd Room (From Mole Tank Room)
  db $3E, $72, $63, $00  ; 4th Room (Cave)
  db $05, $C6, $6E, $09  ; Goal Room
warp_data_level_17: ; 06
  db $06, $00, $2A, $06  ; 2nd Room
  db $3F, $0E, $1E, $09  ; Bonus (Beanstalk)
warp_data_level_18: ; 9B
  db $40, $10, $73, $06  ; 2nd Room (Bottom Left Water)
  db $40, $10, $69, $06  ; 2nd Room (Top Left Water)
  db $07, $05, $4A, $02  ; 3rd Room
  db $9B, $D4, $58, $00  ; Pre-Boss Room
  db $70, $04, $78, $00  ; Boss
warp_data_level_1E: ; 08

warp_data_level_21: ; 09
  db $9C, $06, $75, $04  ; Mario Star Room
  db $71, $04, $61, $04  ; 2nd Room (Poochey)
  db $41, $08, $3E, $09  ; 3rd Room (Falling Rocks)
  db $BA, $05, $70, $04  ; Bonus
warp_data_level_22: ; 0A
  db $42, $00, $3A, $06  ; 2nd Room
  db $72, $40, $3A, $06  ; 3rd Room
warp_data_level_23: ; 0B
  db $43, $02, $23, $04  ; 2nd Room (Cave)
  db $73, $37, $72, $04  ; Bonus
warp_data_level_24: ; 0C
  db $44, $34, $6A, $00  ; 2nd Room
  db $9D, $08, $5A, $00  ; Boo Room
  db $9D, $4B, $5A, $00  ; 3rd Room (Platforms)
  db $44, $32, $54, $04  ; 2nd Room (From Platforms)
  db $C7, $04, $71, $02  ; 4th Room (Lava)
  db $9D, $72, $7A, $02  ; 5th Room (Eggs)
  db $BB, $2A, $7A, $00  ; Bonus (Dark)
  db $CE, $02, $76, $00  ; Pre-Boss Room
  db $74, $BB, $7A, $00  ; Boss
warp_data_level_25: ; 0D
  db $75, $02, $7A, $00  ; Train Room
  db $0D, $FC, $6E, $00  ; 1st Room (From Train)
  db $45, $02, $7A, $00  ; 2nd Room
  db $BC, $04, $35, $04  ; 1st Bonus (Spinny Logs)
  db $9E, $0C, $64, $04  ; 2nd Bonus (Mario Star)
warp_data_level_26: ; 0E
  db $46, $03, $78, $00  ; 2nd Room
  db $46, $63, $78, $00  ; Small Room With Reds
  db $BD, $03, $7A, $00  ; Small Room With Midring
  db $9F, $00, $76, $06  ; 3rd Room
  db $76, $05, $7E, $09  ; 4th Room
warp_data_level_27: ; 0F
  db $47, $5C, $19, $00  ; 2nd Room (Big Shyguys)
  db $0F, $8A, $2C, $00  ; 1st Room (From Big Shyguys)
  db $A0, $3C, $66, $04  ; 3rd Room (Falling Stones)
  db $0F, $7E, $2A, $05  ; 4th Room
  db $47, $1A, $34, $04  ; Bonus (Foam Pipe)
  db $0F, $36, $1E, $04  ; 4th Room (From Bonus)
  db $77, $00, $5A, $06  ; 5th Room (Car)
warp_data_level_28: ; 10
  db $48, $02, $72, $04  ; 2nd Room
  db $10, $4B, $24, $05  ; 3rd Room (Arrow Lift)
  db $D4, $03, $7B, $05  ; Train Room
  ; db $78, $00, $58, $06  ; 1st Tunnel
  db $A1, $78, $0A, $03  ; 4th Room (Key)
  db $A1, $02, $29, $02  ; 5th Room (Spiked Log)
  ; db $78, $00, $07, $06  ; 2nd Tunnel
  ; db $78, $06, $38, $00  ; 3rd Tunnel
  db $78, $33, $3A, $00  ; Bonus (Burts)
  db $A1, $04, $78, $02  ; 6th Room (Arrow Lift)
  db $BE, $18, $4A, $00  ; 7th Room (Bandits)
  db $C8, $03, $38, $00  ; Pre-Boss Room
  db $CF, $04, $4D, $00  ; Boss
warp_data_level_2E: ; 11
  db $49, $11, $64, $04  ; Bonus (Star Crates)

warp_data_level_31: ; 12
  db $4A, $00, $59, $06  ; 2nd Room
  db $A2, $0A, $2A, $05  ; Bonus
  db $79, $00, $7A, $06  ; 3rd Room
warp_data_level_32: ; 13
  db $13, $15, $3A, $05  ; Bonus (Reds)
  db $4B, $05, $70, $00  ; Bonus (Poochey)
warp_data_level_33: ; 14
  db $4C, $00, $6A, $06  ; 2nd Room
  db $4C, $A3, $38, $00  ; Bonus (Flower)
  db $7A, $02, $6B, $00  ; 3rd Room (Submarine)
  db $4C, $86, $78, $00  ; 4th Room
  db $4C, $02, $39, $00  ; 5th Room
warp_data_level_34: ; 15
  db $D7, $2A, $6C, $00  ; Submarine Room
  db $15, $19, $3E, $09  ; 1st Room (From Submarine)
  db $4D, $05, $38, $00  ; 2nd Room
  db $D5, $53, $7A, $00  ; Small Crab Room
  db $4D, $3D, $38, $00  ; 2nd Room (From Small Crab)
  db $7B, $57, $18, $00  ; Room With 3 Reds
  db $D5, $9A, $7A, $00  ; Large Crab Room
  db $7B, $59, $0B, $00  ; 3rd Room (Spikes)
  db $A3, $04, $7A, $00  ; Pre-Boss Room
  db $BF, $12, $61, $04  ; Boss
warp_data_level_35: ; 16
  db $4E, $00, $6A, $06  ; 2nd Room
  db $A4, $3F, $76, $07  ; Bonus
  db $7C, $00, $69, $06  ; 3rd Room
warp_data_level_36: ; 17
  db $4F, $00, $65, $06  ; 2nd Room (Upper)
  db $A5, $01, $77, $04  ; Bonus (Flower)
  db $7D, $07, $79, $00  ; 3rd Room
warp_data_level_37: ; 18
  db $C0, $08, $60, $00  ; Submarine Room
  db $50, $30, $76, $06  ; 2nd Room
  db $A6, $06, $76, $09  ; Bonus (Canopy)
  db $50, $A9, $66, $00  ; 2nd Room (From Bonus)
  db $7E, $00, $6B, $06  ; Room With Goal
warp_data_level_38: ; 19
  db $51, $07, $00, $08  ; 2nd Room
  db $A7, $02, $75, $02  ; 3rd Room (Pipes)
  db $51, $30, $57, $06  ; 4th Room
  db $7F, $0D, $42, $00  ; Boss
warp_data_level_3E: ; 1A
  db $1A, $32, $5E, $09  ; Bonus (Stars)

warp_data_level_41: ; 1B
  db $A8, $02, $74, $04  ; Bonus (Cave)
  db $1B, $A0, $68, $05  ; 1st Room (From Bonus)
  db $52, $00, $68, $06  ; 2nd Room
  db $80, $00, $6A, $06  ; 3rd Room
warp_data_level_42: ; 1C
  db $53, $22, $73, $04  ; 2nd Room
  db $A9, $04, $04, $04  ; Bonus (Falling)
  db $53, $91, $6A, $05  ; 2nd Room (From Bonus)
  db $81, $00, $4A, $06  ; 3rd Room
  db $81, $3B, $76, $04  ; Bonus (Red)
warp_data_level_43: ; 1D
  db $1D, $69, $29, $05  ; Bonus
  db $54, $00, $3A, $06  ; 2nd Room
warp_data_level_44: ; 1E
  db $55, $78, $50, $00  ; Hub
  db $AA, $B3, $15, $00  ; Top Right
  db $AA, $B6, $7A, $00  ; Bottom Right
  db $55, $87, $0A, $00  ; Bottom Right (2nd Room)
  db $55, $03, $7A, $00  ; Top Left
  db $55, $46, $12, $00  ; Bottom Left
  db $AA, $74, $7A, $00  ; 1st Key-Opened Room
  db $C1, $03, $78, $00  ; 2nd Key-Opened Room
  db $C1, $34, $76, $00  ; 3rd Key-Opened Room
  ; db $C1, $64, $78, $00  ; 4th Key-Opened Room
  db $82, $06, $64, $00  ; Boss
warp_data_level_45: ; 1F
  db $56, $02, $66, $00  ; 2nd Room
  db $83, $01, $77, $04  ; Bonus (Flower)
warp_data_level_46: ; 20
  db $20, $0F, $47, $07  ; Small Room With Tulip
  db $57, $05, $6D, $00  ; 2nd Room
  db $57, $54, $77, $00  ; 3rd Room
  db $AB, $10, $79, $06  ; Bonus (Double Arrow Lift)
  db $84, $04, $64, $00  ; 4th Room
warp_data_level_47: ; 21
  db $85, $08, $3E, $09  ; Balloon Pump Room
  db $58, $03, $34, $00  ; 2nd Room
warp_data_level_48: ; 22
  db $59, $95, $7A, $00  ; 2nd Room (Left)
  db $59, $C6, $7A, $00  ; 2nd Room (Middle)
  db $59, $DB, $70, $00  ; 2nd Room (Right)
  db $AC, $17, $5C, $05  ; Bonus (Giant Mildes)
  db $59, $DB, $68, $00  ; Lakitu Room
  db $59, $47, $6C, $05  ; Tetris Room
  db $86, $0D, $78, $00  ; Boss
warp_data_level_4E: ; 5A
  db $23, $1A, $46, $00  ; Bright Room (Main Middle Door)
  db $5A, $91, $60, $00  ; Dark Room (Egg Pool)
  db $23, $0A, $29, $00  ; Bright Room (Top Left)
  db $5A, $92, $55, $00  ; Dark Room (Mole)
  db $23, $2D, $2A, $00  ; Bright Room (Red Egg Blocks)
  db $5A, $89, $5D, $00  ; Dark Room (Helicopter)
  db $23, $32, $1F, $00  ; Bright Room (Flashing Eggs)
  db $5A, $67, $5A, $00  ; Dark Room (End Waterfall)

warp_data_level_51: ; 24
  db $C2, $06, $1E, $09  ; Bonus (Helicopter)
  db $5B, $04, $56, $00  ; 2nd Room (Cave)
  db $87, $11, $3E, $09  ; 3rd Room
  db $AD, $21, $37, $05  ; Bonus (Tulip)
warp_data_level_52: ; 25
  db $5C, $05, $3E, $09  ; 2nd Room
  db $88, $00, $4A, $06  ; 3rd Room
  db $AE, $08, $10, $00  ; Bonus (Ice Core)
warp_data_level_53: ; 26
  db $5D, $00, $39, $06  ; 2nd Room
  db $5D, $02, $16, $05  ; Bonus (Coins)
  db $89, $03, $3A, $00  ; 3rd Room (Door)
  db $AF, $00, $0A, $06  ; 1st Skiing
  db $C3, $00, $0A, $01  ; 2nd Skiing
  db $CA, $00, $0A, $01  ; 3rd Skiing
  db $D1, $00, $7A, $06  ; Goal Room
warp_data_level_54: ; 27
  db $27, $42, $36, $04  ; 1st Bonus (Flower)
  db $5E, $6F, $34, $04  ; 2nd Bonus (Muddy Buddy Room)
  db $27, $AC, $4E, $05  ; 1st Room (Mid-Ring)
  db $5E, $03, $4A, $00  ; 2nd Room
  db $5E, $04, $78, $05  ; 3rd Room (5-4 Skip)
  db $B0, $03, $7A, $00  ; Pre-Boss Room
  db $8A, $0A, $7A, $00  ; Boss
warp_data_level_55: ; 28
  db $B1, $04, $4C, $05  ; Bonus (Penguins)
  db $5F, $00, $4A, $06  ; 2nd Room (Helicopter)
  db $8B, $00, $44, $06  ; 3rd Room
warp_data_level_56: ; 29
  db $60, $00, $6A, $06  ; 2nd Room
  db $8C, $12, $66, $04  ; Bonus (Pipes)
warp_data_level_57: ; 2A
  db $B2, $02, $18, $05  ; Bonus (Flower)
  db $61, $16, $32, $04  ; 2nd Room
  db $8D, $02, $31, $04  ; 3rd Room
warp_data_level_58: ; 2B
  db $62, $04, $56, $00  ; 2nd Room
  db $8E, $07, $5E, $09  ; 3rd Room (Arrow Lift)
  db $B3, $03, $7A, $05  ; 4th Room
  db $D2, $CA, $1A, $00  ; Train Room
  db $C4, $03, $4B, $05  ; Boss
  db $CB, $14, $18, $0A  ; Boss (Moon)
warp_data_level_5E: ; 2C
  db $63, $00, $2A, $06  ; 1st Skiing
  db $8F, $00, $44, $01  ; 2nd Skiing
  db $B4, $00, $0A, $01  ; 3rd Skiing
  db $B4, $C0, $1A, $06  ; Goal Room

warp_data_level_61: ; 2D
  db $B5, $0D, $50, $00  ; Bonus (Conveyor Ride)
  db $64, $00, $7A, $06  ; 2nd Room
  db $90, $00, $7A, $06  ; 3rd Room
warp_data_level_62: ; 2E
  db $65, $00, $7A, $06  ; 2nd Room
  db $91, $00, $78, $06  ; 3rd Room
warp_data_level_63: ; 2F
  db $66, $00, $4A, $06  ; 2nd Room
  db $92, $0A, $4E, $09  ; Bonus (5 Rooms)
warp_data_level_64: ; 30
  db $B6, $47, $4E, $09  ; Pre-Salvo Room
  db $67, $03, $67, $04  ; Big Salvo Room
  db $93, $04, $47, $02  ; Dark Room (From Salvo)
  db $C5, $05, $72, $02  ; Lava Room
  db $CC, $49, $64, $02  ; Boss
warp_data_level_65: ; 31
  db $94, $03, $72, $00  ; Bonus
  db $68, $05, $6B, $00  ; 2nd Room
warp_data_level_66: ; 32
  db $69, $35, $28, $00  ; Bright Room (Top Left)
  db $95, $23, $68, $00  ; Dark Room (Bottom Left)
  db $69, $5A, $4A, $00  ; Bright Room (Top Right)
  db $69, $38, $5A, $00  ; Bright Room (Mid Left)
  db $32, $B4, $78, $00  ; Goal Room
warp_data_level_67: ; 33
  db $6A, $00, $0A, $06  ; 2nd Room
  db $96, $10, $1A, $06  ; 3rd Room
  db $B7, $0A, $60, $00  ; Bonus (Switches)
  db $96, $06, $64, $04  ; Goal Room
warp_data_level_68: ; 34
  db $97, $04, $6A, $00  ; Pick a Door Room
  db $B8, $05, $77, $00  ; Door 1
  db $C6, $07, $7A, $00  ; Door 2
  db $CD, $05, $5B, $00  ; Door 3
  db $D3, $00, $77, $06  ; Door 4
  db $6B, $23, $0A, $00  ; Kamek's Magic Autoscroller
  db $DD, $04, $7A, $00  ; Boss
  db $DD, $05, $7A, $00  ; hack to load Big Baby Bowser
warp_data_level_6E: ; 35
  db $6C, $04, $6A, $00  ; 2nd Room
  db $35, $D4, $7A, $00  ; 3rd Room
  db $98, $07, $4E, $00  ; 4th Room (Baseball)
  db $98, $35, $05, $02  ; 5th Room
  db $98, $57, $02, $04  ; 6th Room
  db $B9, $03, $73, $02  ; 7th Room (Water)

warp_data_level_pointers:
  dw warp_data_level_11, warp_data_level_12, warp_data_level_13, warp_data_level_14, warp_data_level_15, warp_data_level_16, warp_data_level_17, warp_data_level_18, warp_data_level_1E
  dw warp_data_level_21, warp_data_level_22, warp_data_level_23, warp_data_level_24, warp_data_level_25, warp_data_level_26, warp_data_level_27, warp_data_level_28, warp_data_level_2E
  dw warp_data_level_31, warp_data_level_32, warp_data_level_33, warp_data_level_34, warp_data_level_35, warp_data_level_36, warp_data_level_37, warp_data_level_38, warp_data_level_3E
  dw warp_data_level_41, warp_data_level_42, warp_data_level_43, warp_data_level_44, warp_data_level_45, warp_data_level_46, warp_data_level_47, warp_data_level_48, warp_data_level_4E
  dw warp_data_level_51, warp_data_level_52, warp_data_level_53, warp_data_level_54, warp_data_level_55, warp_data_level_56, warp_data_level_57, warp_data_level_58, warp_data_level_5E
  dw warp_data_level_61, warp_data_level_62, warp_data_level_63, warp_data_level_64, warp_data_level_65, warp_data_level_66, warp_data_level_67, warp_data_level_68, warp_data_level_6E
