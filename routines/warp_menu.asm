; page depth index will be either
;   0: main menu (submenu_warps_ctrl)
;   1: level select (world chosen from submenu W1-W6)
;   2: room warp select
;   3: warp trigger

; Initialises a menu page depending on the value of !warps_page_depth_index|!warps_current_world_index|!warps_current_level_index
warp_menu:
  REP #$30

  ; if index == 0, back was clicked - decrement the depth index
  CPX #$0000 : BEQ .go_back
  INC !warps_page_depth_index
  LDA.w #!sfx_yoshi

  LDY !warps_page_depth_index : CPY #$0003 : BEQ .next
  ; not warping, just loading a deeper page
  JSR push_cursor_stack
  LDA.w #!sfx_move_cursor
  BRA .next

.go_back
  DEC !warps_page_depth_index
  JSR pop_cursor_stack
  LDA.w #!sfx_move_cursor
.next
  STA !sound_immediate
  JSR blank_tilemap
  TXY ; option index now in Y
  DEY ; if back was selected, then underflow
  LDA !warps_page_depth_index
  ASL A ; index --> offset
  TAX
  JMP (.menu_load_funcs,x)
.menu_load_funcs
  dw load_main_menu
  dw load_level_select   ; depth=1: world chosen directly from submenu (wildcard 1-6 = Y+1 = world_index)
  dw load_room_select    ; depth=2
  dw load_room           ; depth=3 (trigger warp)

; loads a warp menu page using pre-existing control vars
warp_menu_direct_load:
  PHP
  %ai16()

  JSR blank_tilemap
  LDA !warps_page_depth_index : ASL : TAX
  JSR (.menu_load_funcs,x)
  PLP
  RTS
.menu_load_funcs
  dw load_main_menu ; should never hit
  dw load_level_select_next
  dw load_room_select_next

load_main_menu:
  ; current_menu_data_ptr is still the warps submenu; just re-init it
  JSR init_current_menu
  RTS

load_world_select:
  STZ !warps_current_world_index
  STZ !warps_current_level_index
  LDA.w #!warps_worlds_count : STA !dbc_row_count_current : STA !dbc_count_current
  JSR init_warp_option_worlds_tilemaps
  RTS

load_level_select:
  CPY #$FFFF : BEQ .next
  ; do this if coming from world select
  STY !warps_current_world_index

.next
  STZ !warps_current_level_index
  LDA.w #!warps_levels_count : STA !dbc_row_count_current : STA !dbc_count_current
  JSR init_warp_option_levels_tilemaps
  RTS

load_room_select:
  STY !warps_current_level_index

  ; offset into debug_menu_controls_warps_room_counts is found by !warps_current_world_index*9+!warps_current_level_index
  LDA !warps_current_world_index
  ASL #3
  ADC !warps_current_world_index
  ADC !warps_current_level_index
  STA !warps_current_world_level_index ; store for use when selecting a room

.next
  LDY !warps_current_world_level_index
  SEP #$20
  LDA debug_menu_controls_warps_room_counts,y
  INC A ; add 1 for the start option
  STA !dbc_row_count_current : STA !dbc_count_current
  JSR init_warp_option_rooms_tilemaps
  RTS

; The actual warp subroutine
load_room:
  REP #$30

  DEC !warps_page_depth_index ; correct the depth index to point to room select

  ; set the world and level number
  LDA !warps_current_world_index
  ASL A
  STA !world_num

  ASL A ; world*4
  PHA
  ASL A ; world*8
  CLC
  ADC $01,s ; world*8+world*4 = world*12
  ADC !warps_current_level_index ; world*12+level
  STA !level_num
  PLA
  
  ; if y == 0, load level start... i think the game automatically loads room data for us?
  DEY
  BPL .get_entrance
  LDA #$0000
  BRA .load
.get_entrance ; else, fetch entrance data for specific room
  LDA !warps_current_world_level_index ; we stored the correct pointer table index before
  ASL ; 2byte offset
  TAX
  LDA warp_data_level_pointers,x ; fetch start address of entrance data for a particular level
  PHA
  TYA ; transform y from selected room index to 4byte offset
  ASL A
  ASL A
  TAY
  LDA ($01,s),y
  STA !screen_exit_level ; screen exit data (xpos, dest)
  INY
  INY
  LDA ($01,s),y
  STA !screen_exit_level+2 ; screen exit data (type, ypos)
  PLA
  STZ !current_screen ; zero the current index into !screen_exit_level so that the data we just set will be read
  LDA #$0001
.load
  STA !level_load_type ; Flag to enter 0: start of level, 1: different room within level
  ; if warping before a file has been loaded, load the debug file 3
  LDA !gamemode : CMP.w #!gm_title+1 : BCS +
  JSL load_file3_debug
  +
  LDA.w #!gm_levelfadeout : STA !gamemode
  STZ !r_level_music_playing ; levels check this is zero before loading new music
  LDA !r_pause_menu_flag : AND #$00FF : BEQ +
  LDA.w #!sfx_unpause : STA !r_apu_io_2_mirror ; if game was paused, we need to re-enable the music to avoid an APU hang
  +
  JSR check_big_bowser
  JSR reset_progress
  JSR set_yoshi_colour
  JSR reset_hud
  INC !warping
  RTS

;================================
; Shared offset table: preset index (0-4) -> byte offset into !warp_presets

warp_preset_offsets:
  db 0*!warp_preset_stride, 1*!warp_preset_stride, 2*!warp_preset_stride, 3*!warp_preset_stride, 4*!warp_preset_stride

;================================
; Warp to a saved preset (function index 7)
; !dbc_index_row 2-6 maps to presets 0-4

warp_preset_exec:
  PHP
  %ai16()
  ; compute byte offset into warp_presets: (row - 2) * stride
  LDA !dbc_index_row
  SEC : SBC #$0002
  AND #$00FF
  TAX
  %a8()
  LDA warp_preset_offsets,x
  %a16()
  AND #$00FF
  TAX ; X = byte offset into warp_presets
  ; apply world/level (byte fields, mask adjacent byte)
  LDA.l !warp_presets+!wp_world_num,x : AND #$00FF : STA !world_num
  LDA.l !warp_presets+!wp_level_num,x : AND #$00FF : STA !level_num
  ; apply screen exit (4 bytes as 2 words)
  LDA.l !warp_presets+!wp_screen_exit+0,x : STA !screen_exit_level
  LDA.l !warp_presets+!wp_screen_exit+2,x : STA !screen_exit_level+2
  STZ !current_screen
  ; restore eggs (egg_inv_size byte, mask; items are words)
  LDA.l !warp_presets+!wp_egg_inv_size,x     : AND #$00FF : STA.l !egg_inv_size
  LDA.l !warp_presets+!wp_egg_inv_items+0,x  : STA.l !egg_inv_items+0
  LDA.l !warp_presets+!wp_egg_inv_items+2,x  : STA.l !egg_inv_items+2
  LDA.l !warp_presets+!wp_egg_inv_items+4,x  : STA.l !egg_inv_items+4
  LDA.l !warp_presets+!wp_egg_inv_items+6,x  : STA.l !egg_inv_items+6
  LDA.l !warp_presets+!wp_egg_inv_items+8,x  : STA.l !egg_inv_items+8
  LDA.l !warp_presets+!wp_egg_inv_items+10,x : STA.l !egg_inv_items+10
  ; copy eggs to last_exit_eggs so rezone keeps preset eggs
  LDA.l !warp_presets+!wp_egg_inv_size,x     : AND #$00FF : STA !last_exit_eggs
  LDA.l !warp_presets+!wp_egg_inv_items+0,x  : STA !last_exit_eggs+2
  LDA.l !warp_presets+!wp_egg_inv_items+2,x  : STA !last_exit_eggs+4
  LDA.l !warp_presets+!wp_egg_inv_items+4,x  : STA !last_exit_eggs+6
  LDA.l !warp_presets+!wp_egg_inv_items+6,x  : STA !last_exit_eggs+8
  LDA.l !warp_presets+!wp_egg_inv_items+8,x  : STA !last_exit_eggs+10
  LDA.l !warp_presets+!wp_egg_inv_items+10,x : STA !last_exit_eggs+12
  ; trigger warp 
  LDA #$0001 : STA !level_load_type
  LDA !gamemode : CMP.w #!gm_title+1 : BCS +
  JSL load_file3_debug
  +
  LDA.w #!gm_levelfadeout : STA !gamemode
  STZ !r_level_music_playing
  LDA !r_pause_menu_flag : AND #$00FF : BEQ +
  LDA.w #!sfx_unpause : STA !r_apu_io_2_mirror
  +
  JSR check_big_bowser
  JSR reset_progress
  JSR set_yoshi_colour
  JSR reset_hud
  INC !warping
  PLP
  RTS

;================================
; Save current level/room/eggs as a preset (function index 8)
; Saves !current_level (sublevel/room), Yoshi's pixel x/y, world/level nums, eggs
; Only saves when gamemode is !gm_level

set_preset_exec:
  PHP
  %ai16()
  ; only save if in-level
  LDA !gamemode : CMP.w #!gm_level : BEQ +
  JMP .ret
+
  ; compute byte offset: (row - 2) * stride
  LDA !dbc_index_row
  SEC : SBC #$0002
  AND #$00FF
  TAX
  %a8()
  LDA warp_preset_offsets,x
  %a16()
  AND #$00FF
  TAX ; X = byte offset into warp_presets
  ; save byte fields: world, level, egg inventory size
  %a8()
  LDA !world_num      : STA.l !warp_presets+!wp_world_num,x
  LDA !level_num      : STA.l !warp_presets+!wp_level_num,x
  LDA.l !egg_inv_size : STA.l !warp_presets+!wp_egg_inv_size,x
  ; screen exit: room_id + entrance bytes (yoshi_pos >> 4, game restores via << 4)
  LDA !current_level  : STA.l !warp_presets+!wp_screen_exit+0,x
  %a16()
  LDA !yoshi_x_pos : LSR #4
  %a8()
  STA.l !warp_presets+!wp_screen_exit+1,x
  %a16()
  LDA !yoshi_y_pos : LSR #4
  %a8()
  STA.l !warp_presets+!wp_screen_exit+2,x
  LDA #$00 : STA.l !warp_presets+!wp_screen_exit+3,x
  ; save egg inventory items (words)
  %a16()
  LDA.l !egg_inv_items+0  : STA.l !warp_presets+!wp_egg_inv_items+0,x
  LDA.l !egg_inv_items+2  : STA.l !warp_presets+!wp_egg_inv_items+2,x
  LDA.l !egg_inv_items+4  : STA.l !warp_presets+!wp_egg_inv_items+4,x
  LDA.l !egg_inv_items+6  : STA.l !warp_presets+!wp_egg_inv_items+6,x
  LDA.l !egg_inv_items+8  : STA.l !warp_presets+!wp_egg_inv_items+8,x
  LDA.l !egg_inv_items+10 : STA.l !warp_presets+!wp_egg_inv_items+10,x
.ret
  PLP
  RTS

;================================
; If warping to big bowser, need to set a flag

check_big_bowser:
  STZ !skip_baby_bowser
  LDA !screen_exit_level
  CMP #$05DD ; hacky but simple: just check that we're warping to this very slightly different x pos in bowser's room
  BNE .ret
  INC !skip_baby_bowser
.ret
  RTS

reset_progress:
  PHP
  %ai16()

  ; 10.9 stars, 0 red coins, 0 flowers
  LDA #$006D : STA !star_count
  STZ $03A5 ; some star display var
  LDA #$0001 : STA !star_count_digit_1
  STZ !star_count_digit_2
  STZ !red_coin_count
  STZ !flower_count

  ; reset collectibles
  LDX.w #!item_mem_page_size/2-2
-
  STZ !item_mem_page0,x
  STZ !item_mem_page0+!item_mem_page_size/2,x
  STZ !item_mem_page1,x
  STZ !item_mem_page1+!item_mem_page_size/2,x
  STZ !item_mem_page2,x
  STZ !item_mem_page2+!item_mem_page_size/2,x
  STZ !item_mem_page3,x
  STZ !item_mem_page3+!item_mem_page_size/2,x
  DEX #2
  BPL -
.ret
  PLP
  RTS
