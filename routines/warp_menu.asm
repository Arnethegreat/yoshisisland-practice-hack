; page depth index will be either
;   0: main menu
;   1: world select
;   2: level select
;   3: room warp select

; Initialises a menu page depending on the value of !warps_page_depth_index|!warps_current_world_index|!warps_current_level_index
warp_menu:
  REP #$30

  ; if index == 0, back was clicked - decrement the depth index
  CPX #$0000 : BEQ .go_back
  INC !warps_page_depth_index
  LDA.w #!sfx_yoshi

  LDY !warps_page_depth_index : CPY #$0004 : BEQ .next
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
  dw load_world_select
  dw load_level_select
  dw load_room_select
  dw load_room

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
  dw load_world_select
  dw load_level_select_next
  dw load_room_select_next

load_main_menu:
  LDA #mainmenu_ctrl : STA !current_menu_data_ptr
  JSR init_current_menu
  RTS

load_world_select:
  STZ !warps_current_world_index
  STZ !warps_current_level_index
  LDA !debug_menu_controls_warps_worlds_count : STA !dbc_row_count_current : STA !dbc_count_current
  JSR init_warp_option_worlds_tilemaps
  RTS

load_level_select:
  CPY #$FFFF : BEQ .next
  ; do this if coming from world select
  STY !warps_current_world_index

.next
  STZ !warps_current_level_index
  LDA !debug_menu_controls_warps_levels_count : STA !dbc_row_count_current : STA !dbc_count_current
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
  LDA !is_audio_fixed : BNE + ; this flag is set when loading the map or a level, so this can only trigger once
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

  ; 10 stars, 0 red coins, 0 flowers
  LDA #$0064 : STA !star_count
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
