; 25 bytes
!title_tilemap_size = #$0032
!title_tilemap_dest = $0006
title_tilemap:
; CuteShrug
dw $0040, $0041, $0042
; PRACTICE HACK V
dw $0019, $001b, $000a, $000c
dw $001d, $0012, $000c, $000e
dw $003f, $0011, $000a, $000c
dw $0014, $003F 
; 0.3.1
dw $0000, $0024, $0003, $0024, $0001
; CuteShrug
dw $0040, $0041, $0042


!option_1_tilemap_size = #$0024
!option_1_tilemap_dest = $00C2
option_1_tilemap:
; DISABLE AUTOSCROLL
dw $000D, $0012, $001C, $000A
dw $000B, $0015, $000E, $003F
dw $000A, $001E, $001D, $0018
dw $001C, $000C, $001B, $0018
dw $0015, $0015


!option_2_tilemap_size = #$0018
!option_2_tilemap_dest = $0142
option_2_tilemap:
; WARP TO BOSS
dw $0020, $000A, $001B, $0019
dw $003F, $001D, $0018, $003F
dw $000B, $0018, $001C, $001C


!option_3_tilemap_size = #$0018
!option_3_tilemap_dest = $01C2
option_3_tilemap:
; MUSIC TOGGLE
dw $0016, $001E, $001C, $0012, $000C, $003F, $001D, $0018, $0010, $0010, $0015, $000E


!option_4_tilemap_size = #$001A
!option_4_tilemap_dest = $0254
option_4_tilemap:
; FREE MOVEMENT
dw $000F, $001B, $000E, $000E, $003F, $0016, $0018, $001F, $000E, $0016, $000E, $0017, $001D


!option_5_tilemap_size = #$0014
!option_5_tilemap_dest = $02D4
option_5_tilemap:
; EGG EDITOR
dw $000E, $0010, $0010, $003F, $000E, $000D, $0012, $001D, $0018, $001B

!option_6_tilemap_size = #$001E
!option_6_tilemap_dest = $0354
option_6_tilemap:
; SLOWDOWN AMOUNT
dw $001C, $0015, $0018, $0020, $000D, $0018, $0020
dw $0017, $003F, $000A, $0016, $0018, $001E, $0017, $001D


!option_7_tilemap_size = #$0028
!option_7_tilemap_dest = $03D4
option_7_tilemap:
; FULL LOAD AS DEFAULT
dw $000F, $001E, $0015, $0015, $003F, $0015, $0018, $000A, $000D
dw $003F, $000A, $001C, $003F, $000D, $000E, $000F, $000A, $001E, $0015, $001D


!option_8_tilemap_size = #$0024
!option_8_tilemap_dest = $0454
option_8_tilemap:
; SET TUTORIAL FLAGS
dw $001C, $000E, $001D, $003F, $001D, $001E, $001D, $0018
dw $001B, $0012, $000A, $0015, $003F, $000F, $0015, $000A, $0010, $001C


!option_9_tilemap_size = #$002A
!option_9_tilemap_dest = $04D4
option_9_tilemap:
; DISABLE KAMEK AT BOSS
dw $000D, $0012, $001C, $000A, $000B, $0015, $000E, $003F, $0014, $000A, $0016
dw $000E, $0014, $003F, $000A, $001D, $003F, $000B, $0018, $001C, $001C


!option_10_tilemap_size = #$0012
!option_10_tilemap_dest = $0542
option_10_tilemap:
;  W      A      R      P      _      M      E      N      U
dw $0020, $000A, $001B, $0019, $003F, $0016, $000E, $0017, $001E


!option_11_tilemap_size = #$0006
!option_11_tilemap_dest = $05D4
option_11_tilemap:
;  H      U      D
dw $0011, $001E, $000D


;====================================
; Warp Options
;

table "../misc/string_font_map.txt",ltr

!null = $0000

option_back_tilemap: dw "BACK"

option_worlds_tilemap: dw "WORLD 1", !null, "WORLD 2", !null, "WORLD 3", !null, "WORLD 4", !null, "WORLD 5", !null, "WORLD 6", !null, !null

option_world1_tilemap: dw "1-1", !null, "1-2", !null, "1-3", !null, "1-4", !null, "1-5", !null, "1-6", !null, "1-7", !null, "1-8", !null, "1-E", !null, !null
option_world2_tilemap: dw "2-1", !null, "2-2", !null, "2-3", !null, "2-4", !null, "2-5", !null, "2-6", !null, "2-7", !null, "2-8", !null, "2-E", !null, !null
option_world3_tilemap: dw "3-1", !null, "3-2", !null, "3-3", !null, "3-4", !null, "3-5", !null, "3-6", !null, "3-7", !null, "3-8", !null, "3-E", !null, !null
option_world4_tilemap: dw "4-1", !null, "4-2", !null, "4-3", !null, "4-4", !null, "4-5", !null, "4-6", !null, "4-7", !null, "4-8", !null, "4-E", !null, !null
option_world5_tilemap: dw "5-1", !null, "5-2", !null, "5-3", !null, "5-4", !null, "5-5", !null, "5-6", !null, "5-7", !null, "5-8", !null, "5-E", !null, !null
option_world6_tilemap: dw "6-1", !null, "6-2", !null, "6-3", !null, "6-4", !null, "6-5", !null, "6-6", !null, "6-7", !null, "6-8", !null, "6-E", !null, !null

option_world_tilemaps_addr_table:
    dw option_world1_tilemap, option_world2_tilemap, option_world3_tilemap, option_world4_tilemap, option_world5_tilemap, option_world6_tilemap

option_start_tilemap: dw "START"

option_level11_tilemap: dw "CAVE - LEFT", !null, !null
option_level12_tilemap: dw "2ND ROOM", !null, "GOAL ROOM", !null, !null
option_level13_tilemap: dw "2ND ROOM - CAVE", !null, "*BONUS*", !null, "2ND ROOM - FROM BONUS LEFT", !null, "GOAL ROOM", !null, !null
option_level14_tilemap: dw "2ND ROOM", !null, "*BONUS*", !null, "2ND ROOM - FROM BONUS", !null, "PRE-BOSS ROOM", !null, "BOSS", !null, !null
option_level15_tilemap: dw !null, !null
option_level16_tilemap: dw "*BONUS* - CLOUD", !null, "2ND ROOM - CAVE", !null, "3RD ROOM", !null, "MOLE TANK ROOM", !null, "3RD ROOM - FROM MOLE TANK ROOM", !null, "4TH ROOM - CAVE", !null, "GOAL ROOM", !null, !null
option_level17_tilemap: dw "2ND ROOM", !null, "*BONUS* - BEANSTALK", !null, !null
option_level18_tilemap: dw "2ND ROOM - BOTTOM LEFT WATER", !null, "1ST ROOM - LEFT FROM WATER", !null, "3RD ROOM", !null, "PRE-BOSS ROOM", !null, "BOSS", !null, !null
option_level1E_tilemap: dw !null, !null

option_world1_tilemaps_addr_table:
    dw option_level11_tilemap, option_level12_tilemap, option_level13_tilemap, option_level14_tilemap
    dw option_level15_tilemap, option_level16_tilemap, option_level17_tilemap, option_level18_tilemap, option_level1E_tilemap

option_level21_tilemap: dw "MARIO STAR ROOM", !null, "2ND ROOM - POOCHEY", !null, "3RD ROOM - FALLING ROCKS", !null, "*BONUS*", !null, !null
option_level22_tilemap: dw "2ND ROOM", !null, "3RD ROOM", !null, !null
option_level23_tilemap: dw "2ND ROOM - CAVE", !null, "*BONUS*", !null, !null
option_level24_tilemap: dw "2ND ROOM", !null, "BOO ROOM", !null, "3RD ROOM - PLATFORMS", !null, "2ND ROOM - FROM PLATFORMS", !null, "4TH ROOM - LAVA", !null, "5TH ROOM - EGGS", !null, "*BONUS* - DARK", !null, "PRE-BOSS ROOM", !null, "BOSS", !null, !null
option_level25_tilemap: dw "TRAIN ROOM", !null, "1ST ROOM - FROM TRAIN", !null, "2ND ROOM", !null, "1ST *BONUS* - SPINNY LOGS", !null, "2ND *BONUS* - MARIO STAR", !null, !null
option_level26_tilemap: dw "2ND ROOM", !null, "SMALL ROOM WITH REDS", !null, "SMALL ROOM WITH MIDRING", !null, "3RD ROOM", !null, "4TH ROOM", !null, !null
option_level27_tilemap: dw "2ND ROOM - BIG SHYGUYS", !null, "1ST ROOM - FROM BIG SHYGUYS", !null, "3RD ROOM - FALLING STONES", !null, "4TH ROOM", !null, "*BONUS* - FOAM PIPE", !null, "4TH ROOM - FROM BONUS", !null, "5TH ROOM - CAR", !null, !null
option_level28_tilemap: dw "2ND ROOM", !null, "3RD ROOM - ARROW LIFT", !null, "TRAIN ROOM", !null, "4TH ROOM - KEY", !null, "5TH ROOM - SPIKED LOG", !null, "*BONUS* - BURTS", !null, "6TH ROOM - ARROW LIFT", !null, "7TH ROOM - BANDITS", !null, "PRE-BOSS ROOM", !null, "BOSS", !null, !null
option_level2E_tilemap: dw "*BONUS* - STAR CRATES", !null, !null

option_world2_tilemaps_addr_table:
    dw option_level21_tilemap, option_level22_tilemap, option_level23_tilemap, option_level24_tilemap
    dw option_level25_tilemap, option_level26_tilemap, option_level27_tilemap, option_level28_tilemap, option_level2E_tilemap

option_level31_tilemap: dw "2ND ROOM", !null, "*BONUS*", !null, "3RD ROOM", !null, !null
option_level32_tilemap: dw "*BONUS* - REDS", !null, "*BONUS* - POOCHEY", !null, !null
option_level33_tilemap: dw "2ND ROOM", !null, "*BONUS* - FLOWER", !null, "3RD ROOM - SUBMARINE", !null, "4TH ROOM", !null, "5TH ROOM", !null, !null
option_level34_tilemap: dw "SUBMARINE ROOM", !null, "1ST ROOM - FROM SUBMARINE", !null, "2ND ROOM", !null, "SMALL CRAB ROOM", !null, "2ND ROOM - FROM SMALL CRAB", !null, "ROOM WITH 3 REDS", !null, "LARGE CRAB ROOM", !null, "3RD ROOM - SPIKES", !null, "PRE-BOSS ROOM", !null, "BOSS", !null, !null
option_level35_tilemap: dw "2ND ROOM", !null, "*BONUS*", !null, "3RD ROOM", !null, !null
option_level36_tilemap: dw "2ND ROOM - UPPER", !null, "*BONUS* - FLOWER", !null, "3RD ROOM", !null, !null
option_level37_tilemap: dw "SUBMARINE ROOM", !null, "2ND ROOM", !null, "*BONUS* - CANOPY", !null, "2ND ROOM - FROM BONUS", !null, "ROOM WITH GOAL", !null, !null
option_level38_tilemap: dw "2ND ROOM", !null, "3RD ROOM - PIPES", !null, "4TH ROOM", !null, "BOSS", !null, !null
option_level3E_tilemap: dw "*BONUS* - STARS", !null, !null

option_world3_tilemaps_addr_table:
    dw option_level31_tilemap, option_level32_tilemap, option_level33_tilemap, option_level34_tilemap
    dw option_level35_tilemap, option_level36_tilemap, option_level37_tilemap, option_level38_tilemap, option_level3E_tilemap

option_level41_tilemap: dw "*BONUS* - CAVE", !null, "1ST ROOM - FROM BONUS", !null, "2ND ROOM - FUZZIES", !null, "3RD ROOM", !null, !null
option_level42_tilemap: dw "2ND ROOM", !null, "*BONUS* - FALLING", !null, "2ND ROOM - FROM BONUS", !null, "3RD ROOM", !null, "*BONUS* - RED", !null, !null
option_level43_tilemap: dw "*BONUS*", !null, "2ND ROOM", !null, !null
option_level44_tilemap: dw "HUB", !null, "TOP RIGHT", !null, "BOTTOM RIGHT", !null, "BOTTOM RIGHT - 2ND ROOM", !null, "TOP LEFT", !null, "BOTTOM LEFT", !null, "1ST KEY-OPENED ROOM", !null, "2ND KEY-OPENED ROOM", !null, "3RD KEY-OPENED ROOM", !null, "BOSS", !null, !null
option_level45_tilemap: dw "2ND ROOM", !null, "*BONUS* - FLOWER", !null, !null
option_level46_tilemap: dw "SMALL ROOM WITH TULIP", !null, "2ND ROOM", !null, "3RD ROOM", !null, "*BONUS* - DOUBLE ARROW LIFT", !null, "4TH ROOM", !null, !null
option_level47_tilemap: dw "BALLOON PUMP ROOM", !null, "2ND ROOM", !null, !null
option_level48_tilemap: dw "2ND ROOM - LEFT", !null, "2ND ROOM - MIDDLE", !null, "2ND ROOM - RIGHT", !null, "*BONUS* - GIANT MILDES", !null, "LAKITU ROOM", !null, "TETRIS ROOM", !null, "BOSS", !null, !null
option_level4E_tilemap: dw "BRIGHT - MAIN MIDDLE DOOR", !null, "DARK - EGG POOL", !null, "BRIGHT - TOP LEFT", !null, "DARK - MOLE", !null, "BRIGHT - RED EGG BLOCKS", !null, "DARK - HELICOPTER", !null, "BRIGHT - FLASHING EGGS", !null, "DARK - END WATERFALL", !null, !null

option_world4_tilemaps_addr_table:
    dw option_level41_tilemap, option_level42_tilemap, option_level43_tilemap, option_level44_tilemap
    dw option_level45_tilemap, option_level46_tilemap, option_level47_tilemap, option_level48_tilemap, option_level4E_tilemap

option_level51_tilemap: dw "*BONUS* - HELICOPTER", !null, "2ND ROOM - CAVE", !null, "3RD ROOM", !null, "*BONUS* - TULIP", !null, !null
option_level52_tilemap: dw "2ND ROOM", !null, "3RD ROOM", !null, "*BONUS* - ICE CORE", !null, !null
option_level53_tilemap: dw "2ND ROOM", !null, "*BONUS* - COINS", !null, "3RD ROOM - DOOR", !null, "1ST SKIING", !null, "2ND SKIING", !null, "3RD SKIING", !null, "GOAL ROOM", !null, !null
option_level54_tilemap: dw "1ST *BONUS* - FLOWER", !null, "2ND *BONUS* - MUDDY BUDDY ROOM", !null, "1ST ROOM - MID-RING", !null, "2ND ROOM", !null, "3RD ROOM - 5-4 SKIP", !null, "PRE-BOSS ROOM", !null, "BOSS", !null, !null
option_level55_tilemap: dw "*BONUS* - PENGUINS", !null, "2ND ROOM - HELICOPTER", !null, "3RD ROOM", !null, !null
option_level56_tilemap: dw "2ND ROOM", !null, "*BONUS* - PIPES", !null, !null
option_level57_tilemap: dw "*BONUS* - FLOWER", !null, "2ND ROOM", !null, "3RD ROOM", !null, !null
option_level58_tilemap: dw "2ND ROOM", !null, "3RD ROOM - ARROW LIFT", !null, "4TH ROOM", !null, "TRAIN ROOM", !null, "BOSS", !null, "BOSS - MOON", !null, !null
option_level5E_tilemap: dw "1ST SKIING", !null, "2ND SKIING", !null, "3RD SKIING", !null, "GOAL ROOM", !null, !null

option_world5_tilemaps_addr_table:
    dw option_level51_tilemap, option_level52_tilemap, option_level53_tilemap, option_level54_tilemap
    dw option_level55_tilemap, option_level56_tilemap, option_level57_tilemap, option_level58_tilemap, option_level5E_tilemap

option_level61_tilemap: dw "*BONUS* - CONVEYOR RIDE", !null, "2ND ROOM", !null, "3RD ROOM", !null, !null
option_level62_tilemap: dw "2ND ROOM", !null, "3RD ROOM", !null, !null
option_level63_tilemap: dw "2ND ROOM", !null, "*BONUS* - 5 ROOMS", !null, !null
option_level64_tilemap: dw "PRE-SALVO ROOM", !null, "BIG SALVO ROOM", !null, "DARK ROOM - FROM SALVO", !null, "LAVA ROOM", !null, "BOSS", !null, !null
option_level65_tilemap: dw "*BONUS*", !null, "2ND ROOM", !null, !null
option_level66_tilemap: dw "BRIGHT - TOP LEFT", !null, "DARK - BOTTOM LEFT", !null, "BRIGHT - TOP RIGHT", !null, "BRIGHT - MID LEFT", !null, "GOAL ROOM", !null, !null
option_level67_tilemap: dw "2ND ROOM", !null, "3RD ROOM", !null, "*BONUS* - SWITCHES", !null, "GOAL ROOM", !null, !null
option_level68_tilemap: dw "PICK A DOOR ROOM", !null, "DOOR 1", !null, "DOOR 2", !null, "DOOR 3", !null, "DOOR 4", !null, "KAMEK'S MAGIC AUTOSCROLLER", !null, "BOSS - BABY BOWSER", !null, "BOSS - BIG BOWSER", !null, !null
option_level6E_tilemap: dw "2ND ROOM", !null, "3RD ROOM", !null, "4TH ROOM - BASEBALL", !null, "5TH ROOM", !null, "6TH ROOM", !null, "7TH ROOM - WATER", !null, !null

option_world6_tilemaps_addr_table:
    dw option_level61_tilemap, option_level62_tilemap, option_level63_tilemap, option_level64_tilemap
    dw option_level65_tilemap, option_level66_tilemap, option_level67_tilemap, option_level68_tilemap, option_level6E_tilemap


;====================================
; Absolute garbage, replacing with a single loop later
;

init_option_tilemaps:
    REP #$30
    LDX #$0000
    .loop
        LDA title_tilemap,x
        STA !menu_tilemap_mirror+!title_tilemap_dest,x
        INX
        INX
        CPX !title_tilemap_size
        BNE .loop

    LDX #$0000
    -
        LDA option_1_tilemap,x
        STA !menu_tilemap_mirror+!option_1_tilemap_dest,x
        INX
        INX
        CPX !option_1_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_2_tilemap,x
        STA !menu_tilemap_mirror+!option_2_tilemap_dest,x
        INX
        INX
        CPX !option_2_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_3_tilemap,x
        STA !menu_tilemap_mirror+!option_3_tilemap_dest,x
        INX
        INX
        CPX !option_3_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_4_tilemap,x
        STA !menu_tilemap_mirror+!option_4_tilemap_dest,x
        INX
        INX
        CPX !option_4_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_5_tilemap,x
        STA !menu_tilemap_mirror+!option_5_tilemap_dest,x
        INX
        INX
        CPX !option_5_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_6_tilemap,x
        STA !menu_tilemap_mirror+!option_6_tilemap_dest,x
        INX
        INX
        CPX !option_6_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_7_tilemap,x
        STA !menu_tilemap_mirror+!option_7_tilemap_dest,x
        INX
        INX
        CPX !option_7_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_8_tilemap,x
        STA !menu_tilemap_mirror+!option_8_tilemap_dest,x
        INX
        INX
        CPX !option_8_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_9_tilemap,x
        STA !menu_tilemap_mirror+!option_9_tilemap_dest,x
        INX
        INX
        CPX !option_9_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_10_tilemap,x
        STA !menu_tilemap_mirror+!option_10_tilemap_dest,x
        INX
        INX
        CPX !option_10_tilemap_size
        BNE -

    LDX #$0000
    -
        LDA option_11_tilemap,x
        STA !menu_tilemap_mirror+!option_11_tilemap_dest,x
        INX
        INX
        CPX !option_11_tilemap_size
        BNE -

.ret
    RTS


math pri on


; subroutine to load each char sequentially from tilemap into the mirror offset by tilemap_dest
load_text_page:
    LDA #$0000
    STA !tilemap_char_offset
    LDY #$0000
    -
        LDA (!tilemap),y
        CMP #!null ; if null, we reached the end of the line
        BEQ .eol

        ; we need to combine two indices (line start offset, char offset) into the base tilemap mirror address
        ; which is a long situated in bank 7E, plus the char offset (currently in y)
        ; absolute long indexed (x) is the only addressing mode that works here
        ; so we can use the mirror as the STA operand, with the relative dest + offset in x
        
        PHA ; save current tilemap on stack
        LDA !tilemap_dest ; fetch the relative dest
        PHA ; save the relative dest cos we can't just add registers directly (i think?)
        LDA !tilemap_char_offset
        CLC
        ADC $01,s ; add the stored relative dest to the offset
        TAX ; move the combined relative dest/offset into X
        PLA ; pop the saved relative dest (not needed)
        PLA ; pop the saved current tilemap
        STA !menu_tilemap_mirror,x
        BRA .next
    .eol
        INY
        INY
        LDA (!tilemap),y
        CMP #$0000 ; 2 nulls in a row, we reached the end of the page
        BEQ .ret
        ; add 1 line width to tilemap_dest - basically a line feed
        LDA !tilemap_dest
        CLC
        ADC #!tilemap_line_width
        STA !tilemap_dest
        LDA #$0000
        STA !tilemap_char_offset ; reset the char offset
        BRA -
    .next
        INY
        INY
        INC !tilemap_char_offset
        INC !tilemap_char_offset
        BRA -
.ret
    RTS

; Loads each char sequentially from tilemap into the mirror offset by tilemap_dest
macro load_text(tilemap, tilemap_dest)
    LDX #$0000
    -
        LDA <tilemap>,x
        STA !menu_tilemap_mirror+<tilemap_dest>,x
        INX
        INX
        CPX #datasize(<tilemap>)
        BNE -
endmacro

; pushes current DP onto the stack and sets it to 0
macro zero_dp()
    PHD
    LDA #$0000
    PHA
    PLD
endmacro

init_warp_option_worlds_tilemaps:
    REP #$30
    %load_text(title_tilemap, !title_tilemap_dest)
    %load_text(option_back_tilemap, !first_option_tilemap_dest)
    
    %zero_dp()

    LDA #option_worlds_tilemap
    STA !tilemap
    LDA #!first_option_tilemap_dest+!tilemap_line_width
    STA !tilemap_dest
    JSR load_text_page

    PLD ; reset DP
    RTS

init_warp_option_levels_tilemaps:
    REP #$30
    %load_text(title_tilemap, !title_tilemap_dest)
    %load_text(option_back_tilemap, !first_option_tilemap_dest)

    %zero_dp()

    LDA !warps_current_world_index
    ASL A ; offset is 2 bytes per index
    TAX
    LDA option_world_tilemaps_addr_table,x
    STA !tilemap
    LDA #!first_option_tilemap_dest+!tilemap_line_width
    STA !tilemap_dest
    JSR load_text_page

    PLD ; reset DP
    RTS

init_warp_option_rooms_tilemaps:
    REP #$30
    %load_text(title_tilemap, !title_tilemap_dest)
    %load_text(option_back_tilemap, !first_option_tilemap_dest)
    %load_text(option_start_tilemap, !first_option_tilemap_dest+!tilemap_line_width)

    %zero_dp()
    
    LDA #!first_option_tilemap_dest+!tilemap_line_width*2
    STA !tilemap_dest
    LDA !warps_current_level_index
    ASL A ; index --> offset
    TAX
    LDA !warps_current_world_index
    CMP #$0000
    BEQ .world1
    CMP #$0001
    BEQ .world2
    CMP #$0002
    BEQ .world3
    CMP #$0003
    BEQ .world4
    CMP #$0004
    BEQ .world5
    CMP #$0005
    BEQ .world6
    BRA .ret

.world1
    LDA option_world1_tilemaps_addr_table,x
    BRA .load
.world2
    LDA option_world2_tilemaps_addr_table,x
    BRA .load
.world3
    LDA option_world3_tilemaps_addr_table,x
    BRA .load
.world4
    LDA option_world4_tilemaps_addr_table,x
    BRA .load
.world5
    LDA option_world5_tilemaps_addr_table,x
    BRA .load
.world6
    LDA option_world6_tilemaps_addr_table,x
    BRA .load

.load
    STA !tilemap
    JSR load_text_page
.ret
    PLD ; reset DP
    RTS
