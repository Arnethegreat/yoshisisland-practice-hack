; =========================
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
  dw $033A, $0462  ; Cave (Left)
warp_data_level_12: ; 01
  dw $173B, $095E  ; 2nd Room
  dw $A401, $0070  ; Goal Room
warp_data_level_13: ; 02
  dw $033C, $045F  ; 2nd Room (Cave)
  dw $2F6D, $0010  ; Bonus
  dw $D43C, $095E  ; 2nd Room (From Bonus Left)
  dw $3002, $0677  ; Goal Room
warp_data_level_14: ; 03
  dw $1703, $0040  ; 2nd Room
  dw $1D99, $0072  ; Bonus
  dw $8A03, $0548  ; 2nd Room (From Bonus)
  dw $C46E, $006A  ; Pre-Boss Room
  dw $053D, $0063  ; Boss
warp_data_level_15: ; 04
warp_data_level_16: ; 05
  dw $0205, $004A  ; Bonus (Cloud)
  dw $069A, $0440  ; 2nd Room (Cave)
  dw $4405, $007B  ; 3rd Room
  dw $026F, $0455  ; Mole Tank Room
  dw $8805, $0074  ; 3rd Room (From Mole Tank Room)
  dw $723E, $0063  ; 4th Room (Cave)
  dw $C605, $096E  ; Goal Room
warp_data_level_17: ; 06
  dw $0006, $062A  ; 2nd Room
  dw $0E3F, $091E  ; Bonus (Beanstalk)
warp_data_level_18: ; 9B
  dw $1040, $0673  ; 2nd Room (Bottom Left Water)
  dw $BD9B, $0333  ; 1st Room (Left From Water)
  dw $0507, $024A  ; 3rd Room
  dw $D49B, $0058  ; Pre-Boss Room
  dw $0470, $0078  ; Boss
warp_data_level_1E: ; 08

warp_data_level_21: ; 09
  dw $069C, $0475  ; Mario Star Room
  dw $0471, $0461  ; 2nd Room (Poochey)
  dw $0841, $093E  ; 3rd Room (Falling Rocks)
  dw $05BA, $0470  ; Bonus
warp_data_level_22: ; 0A
  dw $0042, $063A  ; 2nd Room
  dw $4072, $063A  ; 3rd Room
warp_data_level_23: ; 0B
  dw $0243, $0423  ; 2nd Room (Cave)
  dw $3773, $0472  ; Bonus
warp_data_level_24: ; 0C
  dw $3444, $006A  ; 2nd Room
  dw $089D, $005A  ; Boo Room
  dw $4B9D, $005A  ; 3rd Room (Platforms)
  dw $3244, $0454  ; 2nd Room (From Platforms)
  dw $04C7, $0271  ; 4th Room (Lava)
  dw $729D, $027A  ; 5th Room (Eggs)
  dw $2ABB, $007A  ; Bonus (Dark)
  dw $02CE, $0076  ; Pre-Boss Room
  dw $BB74, $007A  ; Boss
warp_data_level_25: ; 0D
  dw $0275, $007A  ; Train Room
  dw $FC0D, $006E  ; 1st Room (From Train)
  dw $0245, $007A  ; 2nd Room
  dw $04BC, $0435  ; 1st Bonus (Spinny Logs)
  dw $0C9E, $0464  ; 2nd Bonus (Mario Star)
warp_data_level_26: ; 0E
  dw $0346, $0078  ; 2nd Room
  dw $6346, $0078  ; Small Room With Reds
  dw $03BD, $007A  ; Small Room With Midring
  dw $009F, $0676  ; 3rd Room
  dw $0576, $097E  ; 4th Room
warp_data_level_27: ; 0F
  dw $5C47, $0019  ; 2nd Room (Big Shyguys)
  dw $8A0F, $002C  ; 1st Room (From Big Shyguys)
  dw $3CA0, $0466  ; 3rd Room (Falling Stones)
  dw $7E0F, $052A  ; 4th Room
  dw $1A47, $0434  ; Bonus (Foam Pipe)
  dw $360F, $041E  ; 4th Room (From Bonus)
  dw $0077, $065A  ; 5th Room (Car)
warp_data_level_28: ; 10
  dw $0248, $0472  ; 2nd Room
  dw $4B10, $0524  ; 3rd Room (Arrow Lift)
  dw $03D4, $057B  ; Train Room
  ; dw $0078, $0658  ; 1st Tunnel
  dw $78A1, $030A  ; 4th Room (Key)
  dw $02A1, $0229  ; 5th Room (Spiked Log)
  ; dw $0078, $0607  ; 2nd Tunnel
  ; dw $0678, $0038  ; 3rd Tunnel
  dw $3378, $003A  ; Bonus (Burts)
  dw $04A1, $0278  ; 6th Room (Arrow Lift)
  dw $18BE, $004A  ; 7th Room (Bandits)
  dw $03C8, $0038  ; Pre-Boss Room
  dw $04CF, $004D  ; Boss
warp_data_level_2E: ; 11
  dw $1149, $0464  ; Bonus (Star Crates)

warp_data_level_31: ; 12
  dw $004A, $0659  ; 2nd Room
  dw $0AA2, $052A  ; Bonus
  dw $0079, $067A  ; 3rd Room
warp_data_level_32: ; 13
  dw $1513, $053A  ; Bonus (Reds)
  dw $054B, $0070  ; Bonus (Poochey)
warp_data_level_33: ; 14
  dw $004C, $066A  ; 2nd Room
  dw $A34C, $0038  ; Bonus (Flower)
  dw $027A, $006B  ; 3rd Room (Submarine)
  dw $864C, $0078  ; 4th Room
  dw $024C, $0039  ; 5th Room
warp_data_level_34: ; 15
  dw $2AD7, $006C  ; Submarine Room
  dw $1915, $093E  ; 1st Room (From Submarine)
  dw $054D, $0038  ; 2nd Room
  dw $53D5, $007A  ; Small Crab Room
  dw $3D4D, $0038  ; 2nd Room (From Small Crab)
  dw $577B, $0018  ; Room With 3 Reds
  dw $9AD5, $007A  ; Large Crab Room
  dw $597B, $000B  ; 3rd Room (Spikes)
  dw $04A3, $007A  ; Pre-Boss Room
  dw $12BF, $0461  ; Boss
warp_data_level_35: ; 16
  dw $004E, $066A  ; 2nd Room
  dw $3FA4, $0776  ; Bonus
  dw $007C, $0669  ; 3rd Room
warp_data_level_36: ; 17
  dw $004F, $0665  ; 2nd Room (Upper)
  dw $01A5, $0477  ; Bonus (Flower)
  dw $077D, $0079  ; 3rd Room
warp_data_level_37: ; 18
  dw $08C0, $0060  ; Submarine Room
  dw $3050, $0676  ; 2nd Room
  dw $06A6, $0976  ; Bonus (Canopy)
  dw $A950, $0066  ; 2nd Room (From Bonus)
  dw $007E, $066B  ; Room With Goal
warp_data_level_38: ; 19
  dw $0751, $0800  ; 2nd Room
  dw $02A7, $0275  ; 3rd Room (Pipes)
  dw $3051, $0657  ; 4th Room
  dw $0D7F, $0042  ; Boss
warp_data_level_3E: ; 1A
  dw $321A, $095E  ; Bonus (Stars)

warp_data_level_41: ; 1B
  dw $02A8, $0474  ; Bonus (Cave)
  dw $A01B, $0568  ; 1st Room (From Bonus)
  dw $0052, $0668  ; 2nd Room
  dw $0080, $066A  ; 3rd Room
warp_data_level_42: ; 1C
  dw $2253, $0473  ; 2nd Room
  dw $04A9, $0404  ; Bonus (Falling)
  dw $9153, $056A  ; 2nd Room (From Bonus)
  dw $0081, $064A  ; 3rd Room
  dw $3B81, $0476  ; Bonus (Red)
warp_data_level_43: ; 1D
  dw $691D, $0529  ; Bonus
  dw $0054, $063A  ; 2nd Room
warp_data_level_44: ; 1E
  dw $7855, $0050  ; Hub
  dw $B3AA, $0015  ; Top Right
  dw $B6AA, $007A  ; Bottom Right
  dw $8755, $000A  ; Bottom Right (2nd Room)
  dw $0355, $007A  ; Top Left
  dw $4655, $0012  ; Bottom Left
  dw $74AA, $007A  ; 1st Key-Opened Room
  dw $03C1, $0078  ; 2nd Key-Opened Room
  dw $34C1, $0076  ; 3rd Key-Opened Room
  ; dw $64C1, $0078  ; 4th Key-Opened Room
  dw $0682, $0064  ; Boss
warp_data_level_45: ; 1F
  dw $0256, $0066  ; 2nd Room
  dw $0183, $0477  ; Bonus (Flower)
warp_data_level_46: ; 20
  dw $0F20, $0747  ; Small Room With Tulip
  dw $0557, $006D  ; 2nd Room
  dw $5457, $0077  ; 3rd Room
  dw $10AB, $0679  ; Bonus (Double Arrow Lift)
  dw $0484, $0064  ; 4th Room
warp_data_level_47: ; 21
  dw $0885, $093E  ; Balloon Pump Room
  dw $0358, $0034  ; 2nd Room
warp_data_level_48: ; 22
  dw $9559, $007A  ; 2nd Room (Left)
  dw $C659, $007A  ; 2nd Room (Middle)
  dw $DB59, $0070  ; 2nd Room (Right)
  dw $17AC, $055C  ; Bonus (Giant Mildes)
  dw $DB59, $0068  ; Lakitu Room
  dw $4759, $056C  ; Tetris Room
  dw $0D86, $0078  ; Boss
warp_data_level_4E: ; 5A
  dw $1A23, $0046  ; Bright Room (Main Middle Door)
  dw $915A, $0060  ; Dark Room (Egg Pool)
  dw $0A23, $0029  ; Bright Room (Top Left)
  dw $925A, $0055  ; Dark Room (Mole)
  dw $2D23, $002A  ; Bright Room (Red Egg Blocks)
  dw $895A, $005D  ; Dark Room (Helicopter)
  dw $3223, $001F  ; Bright Room (Flashing Eggs)
  dw $675A, $005A  ; Dark Room (End Waterfall)

warp_data_level_51: ; 24
  dw $06C2, $091E  ; Bonus (Helicopter)
  dw $045B, $0056  ; 2nd Room (Cave)
  dw $1187, $093E  ; 3rd Room
  dw $21AD, $0537  ; Bonus (Tulip)
warp_data_level_52: ; 25
  dw $055C, $093E  ; 2nd Room
  dw $0088, $064A  ; 3rd Room
  dw $08AE, $0010  ; Bonus (Ice Core)
warp_data_level_53: ; 26
  dw $005D, $0639  ; 2nd Room
  dw $025D, $0516  ; Bonus (Coins)
  dw $0389, $003A  ; 3rd Room (Door)
  dw $00AF, $060A  ; 1st Skiing
  dw $00C3, $010A  ; 2nd Skiing
  dw $00CA, $010A  ; 3rd Skiing
  dw $00D1, $067A  ; Goal Room
warp_data_level_54: ; 27
  dw $4227, $0436  ; 1st Bonus (Flower)
  dw $6F5E, $0434  ; 2nd Bonus (Muddy Buddy Room)
  dw $AC27, $054E  ; 1st Room (Mid-Ring)
  dw $035E, $004A  ; 2nd Room
  dw $045E, $0578  ; 3rd Room (5-4 Skip)
  dw $03B0, $007A  ; Pre-Boss Room
  dw $0A8A, $007A  ; Boss
warp_data_level_55: ; 28
  dw $04B1, $054C  ; Bonus (Penguins)
  dw $005F, $064A  ; 2nd Room (Helicopter)
  dw $008B, $0644  ; 3rd Room
warp_data_level_56: ; 29
  dw $0060, $066A  ; 2nd Room
  dw $128C, $0466  ; Bonus (Pipes)
warp_data_level_57: ; 2A
  dw $02B2, $0518  ; Bonus (Flower)
  dw $1661, $0432  ; 2nd Room
  dw $028D, $0431  ; 3rd Room
warp_data_level_58: ; 2B
  dw $0462, $0056  ; 2nd Room
  dw $078E, $095E  ; 3rd Room (Arrow Lift)
  dw $03B3, $057A  ; 4th Room
  dw $CAD2, $001A  ; Train Room
  dw $03C4, $054B  ; Boss
  dw $14CB, $0A18  ; Boss (Moon)
warp_data_level_5E: ; 2C
  dw $0063, $062A  ; 1st Skiing
  dw $008F, $0144  ; 2nd Skiing
  dw $00B4, $010A  ; 3rd Skiing
  dw $C0B4, $061A  ; Goal Room

warp_data_level_61: ; 2D
  dw $0DB5, $0050  ; Bonus (Conveyor Ride)
  dw $0064, $067A  ; 2nd Room
  dw $0090, $067A  ; 3rd Room
warp_data_level_62: ; 2E
  dw $0065, $067A  ; 2nd Room
  dw $0091, $0678  ; 3rd Room
warp_data_level_63: ; 2F
  dw $0066, $064A  ; 2nd Room
  dw $0A92, $094E  ; Bonus (5 Rooms)
warp_data_level_64: ; 30
  dw $47B6, $094E  ; Pre-Salvo Room
  dw $0367, $0467  ; Big Salvo Room
  dw $0493, $0247  ; Dark Room (From Salvo)
  dw $05C5, $0272  ; Lava Room
  dw $49CC, $0264  ; Boss
warp_data_level_65: ; 31
  dw $0394, $0072  ; Bonus
  dw $0568, $006B  ; 2nd Room
warp_data_level_66: ; 32
  dw $3569, $0028  ; Bright Room (Top Left)
  dw $2395, $0068  ; Dark Room (Bottom Left)
  dw $5A69, $004A  ; Bright Room (Top Right)
  dw $3869, $005A  ; Bright Room (Mid Left)
  dw $B432, $0078  ; Goal Room
warp_data_level_67: ; 33
  dw $006A, $060A  ; 2nd Room
  dw $1096, $061A  ; 3rd Room
  dw $0AB7, $0060  ; Bonus (Switches)
  dw $0696, $0464  ; Goal Room
warp_data_level_68: ; 34
  dw $0497, $006A  ; Pick a Door Room
  dw $05B8, $0077  ; Door 1
  dw $07C6, $007A  ; Door 2
  dw $05CD, $005B  ; Door 3
  dw $00D3, $0677  ; Door 4
  dw $236B, $000A  ; Kamek's Magic Autoscroller
  dw $04DD, $007A  ; Boss
  dw $05DD, $007A  ; hack to load Big Baby Bowser
warp_data_level_6E: ; 35
  dw $046C, $006A  ; 2nd Room
  dw $D435, $007A  ; 3rd Room
  dw $0798, $004E  ; 4th Room (Baseball)
  dw $3598, $0205  ; 5th Room
  dw $5798, $0402  ; 6th Room
  dw $03B9, $0273  ; 7th Room (Water)


warp_data_level_pointers:
  dw warp_data_level_11, warp_data_level_12, warp_data_level_13, warp_data_level_14, warp_data_level_15, warp_data_level_16, warp_data_level_17, warp_data_level_18, warp_data_level_1E
  dw warp_data_level_21, warp_data_level_22, warp_data_level_23, warp_data_level_24, warp_data_level_25, warp_data_level_26, warp_data_level_27, warp_data_level_28, warp_data_level_2E
  dw warp_data_level_31, warp_data_level_32, warp_data_level_33, warp_data_level_34, warp_data_level_35, warp_data_level_36, warp_data_level_37, warp_data_level_38, warp_data_level_3E
  dw warp_data_level_41, warp_data_level_42, warp_data_level_43, warp_data_level_44, warp_data_level_45, warp_data_level_46, warp_data_level_47, warp_data_level_48, warp_data_level_4E
  dw warp_data_level_51, warp_data_level_52, warp_data_level_53, warp_data_level_54, warp_data_level_55, warp_data_level_56, warp_data_level_57, warp_data_level_58, warp_data_level_5E
  dw warp_data_level_61, warp_data_level_62, warp_data_level_63, warp_data_level_64, warp_data_level_65, warp_data_level_66, warp_data_level_67, warp_data_level_68, warp_data_level_6E


; multiplies the args and stores the 16-bit result in A
macro mul(operand_a, operand_b)
  PHP

  SEP #$30
  LDA <operand_a>
  STA !reg_wrmpya 
  LDA <operand_b>
  STA !reg_wrmpyb
  NOP #3
  REP #$30
  LDA !reg_rdmpyl

  PLP
endmacro

; page depth index will be either
;   0: main menu
;   1: world select
;   2: level select
;   3: room warp select

; Initialises a menu page depending on the value of !warps_page_depth_index|!warps_current_world_index|!warps_current_level_index
warp_menu:
  REP #$30

  STZ !dbc_index_row : INC !dbc_index_row ; bring the cursor back up to the top
  STZ !dbc_index_col

  ; if index == 0, back was clicked - decrement the depth index
  CPX #$0000 : BEQ .go_back
  INC !warps_page_depth_index
  LDA.w #!sfx_move_cursor

  LDY !warps_page_depth_index : CPY #$0004 : BNE .next
.play_warp_sound
  LDA.w #!sfx_yoshi
  BRA .next

.go_back
  DEC !warps_page_depth_index
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
  CPY #$FFFF
  BEQ .from_rooms
  ; do this if coming from world select
  STY !warps_current_world_index
  BRA .next

.from_rooms ; do this if coming from room select
  LDY !warps_current_world_index

.next
  STZ !warps_current_level_index
  LDA !debug_menu_controls_warps_levels_count : STA !dbc_row_count_current : STA !dbc_count_current
  JSR init_warp_option_levels_tilemaps
  RTS

load_room_select:
  STY !warps_current_level_index

  ; offset into debug_menu_controls_warps_room_counts is found by !warps_current_world_index*9+!warps_current_level_index
  %mul(!warps_current_world_index, #$09)
  CLC
  ADC !warps_current_level_index
  STA !warps_current_world_level_index ; store for use when selecting a room
  TAY
  SEP #$20
  LDA debug_menu_controls_warps_room_counts,y
  INC A ; add 1 for the start option
  STA !dbc_row_count_current : STA !dbc_count_current
  JSR init_warp_option_rooms_tilemaps
  RTS

; The actual warp subroutine
load_room:
  REP #$30

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
  JSR check_big_bowser
  JSR set_min_10_stars
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

;================================
; Set stars=10 if under

set_min_10_stars:
  LDA !star_count
  CMP #$0064
  BPL .ret
  LDA #$0064 : STA !star_count ; stores current star count * 10
.ret
  RTS

;================================
; Change palette based on the level index, but swap yellow and 
; light blue, and set 6-8 and extra levels to green

set_yoshi_colour:
  LDA !warps_current_level_index
  CMP #$0008 ; ?-E
  BEQ .set_green
  CMP #$0002 ; ?-3
  BEQ .set_lightblue
  CMP #$0003 ; ?-4
  BEQ .set_yellow
  CMP #$0007 ; ?-8
  BNE .finish
  LDX !warps_current_world_index
  CPX #$0005 ; 6-8
  BNE .finish

.set_green
  LDA #$0000
  BRA .finish
.set_lightblue
  LDA #$0003
  BRA .finish
.set_yellow
  LDA #$0002
  BRA .finish

.finish
  STA !yoshi_colour
  RTS
