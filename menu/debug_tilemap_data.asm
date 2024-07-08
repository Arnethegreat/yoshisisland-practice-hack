!title_tilemap_dest = $0006
title_tilemap:
incsrc "../resources/string_font_map.asm"
; CuteShrug
dw $0040, $0041, $0042
dw "PRACTICE HACK 0.4.3"
; CuteShrug
dw $0040, $0041, $0042

mainmenu_tilemap:
%store_text("GAME FLAGS/",
            "WARPS",
            "         EGG EDITOR",
            "         SLOWDOWN AMOUNT",
            "         FULL LOAD AS DEFAULT",
            "         LOAD DELAY",
            "         HUD",
            "         RAMWATCH",
            "INPUT CONFIG/")
dw !lf

submenu_gameflags_tilemap:
%store_text("BACK",
            "DISABLE AUTOSCROLL",
            "         DISABLE MUSIC",
            "         FREE MOVEMENT",
            "         SET TUTORIAL FLAGS",
            "         DISABLE KAMEK AT BOSS",
            "TOGGLE PATIENT/HASTY")
dw !lf

submenu_config_tilemap:
%store_text("BACK             RESET DEFAULT",
            "PAD 1 : PAD 2",
            "                 SAVE",
            "                 LOAD",
            "                 LOAD FULL",
            "                 LOAD ROOM",
            "                 TOGGLE MUSIC",
            "                 FREE MOVEMENT",
            "                 SLOWDOWN -",
            "                 SLOWDOWN +",
            "                 NO AUTOSCROLL")
dw !lf

;====================================
; Warp Options
;

!warps_title_tilemap_dest = $009A

option_back_tilemap: dw "BACK"
option_start_tilemap: dw "START"

option_worlds_tilemap: %store_text("WORLD 1", "WORLD 2", "WORLD 3", "WORLD 4", "WORLD 5", "WORLD 6") : dw !lf

option_world1_tilemap: %store_text("1-1", "1-2", "1-3", "1-4", "1-5", "1-6", "1-7", "1-8", "1-E") : dw !lf
option_world2_tilemap: %store_text("2-1", "2-2", "2-3", "2-4", "2-5", "2-6", "2-7", "2-8", "2-E") : dw !lf
option_world3_tilemap: %store_text("3-1", "3-2", "3-3", "3-4", "3-5", "3-6", "3-7", "3-8", "3-E") : dw !lf
option_world4_tilemap: %store_text("4-1", "4-2", "4-3", "4-4", "4-5", "4-6", "4-7", "4-8", "4-E") : dw !lf
option_world5_tilemap: %store_text("5-1", "5-2", "5-3", "5-4", "5-5", "5-6", "5-7", "5-8", "5-E") : dw !lf
option_world6_tilemap: %store_text("6-1", "6-2", "6-3", "6-4", "6-5", "6-6", "6-7", "6-8", "6-E") : dw !lf

option_world_tilemaps_addr_table:
    dw option_world1_tilemap, option_world2_tilemap, option_world3_tilemap, option_world4_tilemap, option_world5_tilemap, option_world6_tilemap

option_level11_tilemap: %store_text("CAVE - LEFT") : dw !lf
option_level12_tilemap: %store_text("2ND ROOM", "GOAL ROOM") : dw !lf
option_level13_tilemap: %store_text("2ND ROOM - CAVE", "*BONUS*", "2ND ROOM - FROM BONUS LEFT", "GOAL ROOM") : dw !lf
option_level14_tilemap: %store_text("2ND ROOM", "*BONUS*", "2ND ROOM - FROM BONUS", "PRE-BOSS ROOM", "BOSS") : dw !lf
option_level15_tilemap: dw !lf, !lf
option_level16_tilemap: %store_text("*BONUS* - CLOUD", "2ND ROOM - CAVE", "3RD ROOM", "MOLE TANK ROOM", "3RD ROOM - FROM MOLE TANK ROOM", "4TH ROOM - CAVE", "GOAL ROOM") : dw !lf
option_level17_tilemap: %store_text("2ND ROOM", "*BONUS* - BEANSTALK") : dw !lf
option_level18_tilemap: %store_text("2ND ROOM - BOTTOM LEFT WATER", "1ST ROOM - LEFT FROM WATER", "3RD ROOM", "PRE-BOSS ROOM", "BOSS") : dw !lf
option_level1E_tilemap: dw !lf, !lf

option_world1_tilemaps_addr_table:
    dw option_level11_tilemap, option_level12_tilemap, option_level13_tilemap, option_level14_tilemap
    dw option_level15_tilemap, option_level16_tilemap, option_level17_tilemap, option_level18_tilemap, option_level1E_tilemap

option_level21_tilemap: %store_text("MARIO STAR ROOM", "2ND ROOM - POOCHEY", "3RD ROOM - FALLING ROCKS", "*BONUS*") : dw !lf
option_level22_tilemap: %store_text("2ND ROOM", "3RD ROOM") : dw !lf
option_level23_tilemap: %store_text("2ND ROOM - CAVE", "*BONUS*") : dw !lf
option_level24_tilemap: %store_text("2ND ROOM", "BOO ROOM", "3RD ROOM - PLATFORMS", "2ND ROOM - FROM PLATFORMS", "4TH ROOM - LAVA", "5TH ROOM - EGGS", "*BONUS* - DARK", "PRE-BOSS ROOM", "BOSS") : dw !lf
option_level25_tilemap: %store_text("TRAIN ROOM", "1ST ROOM - FROM TRAIN", "2ND ROOM", "1ST *BONUS* - SPINNY LOGS", "2ND *BONUS* - MARIO STAR") : dw !lf
option_level26_tilemap: %store_text("2ND ROOM", "SMALL ROOM WITH REDS", "SMALL ROOM WITH MIDRING", "3RD ROOM", "4TH ROOM") : dw !lf
option_level27_tilemap: %store_text("2ND ROOM - BIG SHYGUYS", "1ST ROOM - FROM BIG SHYGUYS", "3RD ROOM - FALLING STONES", "4TH ROOM", "*BONUS* - FOAM PIPE", "4TH ROOM - FROM BONUS", "5TH ROOM - CAR") : dw !lf
option_level28_tilemap: %store_text("2ND ROOM", "3RD ROOM - ARROW LIFT", "TRAIN ROOM", "4TH ROOM - KEY", "5TH ROOM - SPIKED LOG", "*BONUS* - BURTS", "6TH ROOM - ARROW LIFT", "7TH ROOM - BANDITS", "PRE-BOSS ROOM", "BOSS") : dw !lf
option_level2E_tilemap: %store_text("*BONUS* - STAR CRATES") : dw !lf

option_world2_tilemaps_addr_table:
    dw option_level21_tilemap, option_level22_tilemap, option_level23_tilemap, option_level24_tilemap
    dw option_level25_tilemap, option_level26_tilemap, option_level27_tilemap, option_level28_tilemap, option_level2E_tilemap

option_level31_tilemap: %store_text("2ND ROOM", "*BONUS*", "3RD ROOM") : dw !lf
option_level32_tilemap: %store_text("*BONUS* - REDS", "*BONUS* - POOCHEY") : dw !lf
option_level33_tilemap: %store_text("2ND ROOM", "*BONUS* - FLOWER", "3RD ROOM - SUBMARINE", "4TH ROOM", "5TH ROOM") : dw !lf
option_level34_tilemap: %store_text("SUBMARINE ROOM", "1ST ROOM - FROM SUBMARINE", "2ND ROOM", "SMALL CRAB ROOM", "2ND ROOM - FROM SMALL CRAB", "ROOM WITH 3 REDS", "LARGE CRAB ROOM", "3RD ROOM - SPIKES", "PRE-BOSS ROOM", "BOSS") : dw !lf
option_level35_tilemap: %store_text("2ND ROOM", "*BONUS*", "3RD ROOM") : dw !lf
option_level36_tilemap: %store_text("2ND ROOM - UPPER", "*BONUS* - FLOWER", "3RD ROOM") : dw !lf
option_level37_tilemap: %store_text("SUBMARINE ROOM", "2ND ROOM", "*BONUS* - CANOPY", "2ND ROOM - FROM BONUS", "ROOM WITH GOAL") : dw !lf
option_level38_tilemap: %store_text("2ND ROOM", "3RD ROOM - PIPES", "4TH ROOM", "BOSS") : dw !lf
option_level3E_tilemap: %store_text("*BONUS* - STARS") : dw !lf

option_world3_tilemaps_addr_table:
    dw option_level31_tilemap, option_level32_tilemap, option_level33_tilemap, option_level34_tilemap
    dw option_level35_tilemap, option_level36_tilemap, option_level37_tilemap, option_level38_tilemap, option_level3E_tilemap

option_level41_tilemap: %store_text("*BONUS* - CAVE", "1ST ROOM - FROM BONUS", "2ND ROOM - FUZZIES", "3RD ROOM") : dw !lf
option_level42_tilemap: %store_text("2ND ROOM", "*BONUS* - FALLING", "2ND ROOM - FROM BONUS", "3RD ROOM", "*BONUS* - RED") : dw !lf
option_level43_tilemap: %store_text("*BONUS*", "2ND ROOM") : dw !lf
option_level44_tilemap: %store_text("HUB", "TOP RIGHT", "BOTTOM RIGHT", "BOTTOM RIGHT - 2ND ROOM", "TOP LEFT", "BOTTOM LEFT", "1ST KEY-OPENED ROOM", "2ND KEY-OPENED ROOM", "3RD KEY-OPENED ROOM", "BOSS") : dw !lf
option_level45_tilemap: %store_text("2ND ROOM", "*BONUS* - FLOWER") : dw !lf
option_level46_tilemap: %store_text("SMALL ROOM WITH TULIP", "2ND ROOM", "3RD ROOM", "*BONUS* - DOUBLE ARROW LIFT", "4TH ROOM") : dw !lf
option_level47_tilemap: %store_text("BALLOON PUMP ROOM", "2ND ROOM") : dw !lf
option_level48_tilemap: %store_text("2ND ROOM - LEFT", "2ND ROOM - MIDDLE", "2ND ROOM - RIGHT", "*BONUS* - GIANT MILDES", "LAKITU ROOM", "TETRIS ROOM", "BOSS") : dw !lf
option_level4E_tilemap: %store_text("BRIGHT - MAIN MIDDLE DOOR", "DARK - EGG POOL", "BRIGHT - TOP LEFT", "DARK - MOLE", "BRIGHT - RED EGG BLOCKS", "DARK - HELICOPTER", "BRIGHT - FLASHING EGGS", "DARK - END WATERFALL") : dw !lf

option_world4_tilemaps_addr_table:
    dw option_level41_tilemap, option_level42_tilemap, option_level43_tilemap, option_level44_tilemap
    dw option_level45_tilemap, option_level46_tilemap, option_level47_tilemap, option_level48_tilemap, option_level4E_tilemap

option_level51_tilemap: %store_text("*BONUS* - HELICOPTER", "2ND ROOM - CAVE", "3RD ROOM", "*BONUS* - TULIP") : dw !lf
option_level52_tilemap: %store_text("2ND ROOM", "3RD ROOM", "*BONUS* - ICE CORE") : dw !lf
option_level53_tilemap: %store_text("2ND ROOM", "*BONUS* - COINS", "3RD ROOM - DOOR", "1ST SKIING", "2ND SKIING", "3RD SKIING", "GOAL ROOM") : dw !lf
option_level54_tilemap: %store_text("1ST *BONUS* - FLOWER", "2ND *BONUS* - MUDDY BUDDY ROOM", "1ST ROOM - MID-RING", "2ND ROOM", "3RD ROOM - 5-4 SKIP", "PRE-BOSS ROOM", "BOSS") : dw !lf
option_level55_tilemap: %store_text("*BONUS* - PENGUINS", "2ND ROOM - HELICOPTER", "3RD ROOM") : dw !lf
option_level56_tilemap: %store_text("2ND ROOM", "*BONUS* - PIPES") : dw !lf
option_level57_tilemap: %store_text("*BONUS* - FLOWER", "2ND ROOM", "3RD ROOM") : dw !lf
option_level58_tilemap: %store_text("2ND ROOM", "3RD ROOM - ARROW LIFT", "4TH ROOM", "TRAIN ROOM", "BOSS", "BOSS - MOON") : dw !lf
option_level5E_tilemap: %store_text("1ST SKIING", "2ND SKIING", "3RD SKIING", "GOAL ROOM") : dw !lf

option_world5_tilemaps_addr_table:
    dw option_level51_tilemap, option_level52_tilemap, option_level53_tilemap, option_level54_tilemap
    dw option_level55_tilemap, option_level56_tilemap, option_level57_tilemap, option_level58_tilemap, option_level5E_tilemap

option_level61_tilemap: %store_text("*BONUS* - CONVEYOR RIDE", "2ND ROOM", "3RD ROOM") : dw !lf
option_level62_tilemap: %store_text("2ND ROOM", "3RD ROOM") : dw !lf
option_level63_tilemap: %store_text("2ND ROOM", "*BONUS* - 5 ROOMS") : dw !lf
option_level64_tilemap: %store_text("PRE-SALVO ROOM", "BIG SALVO ROOM", "DARK ROOM - FROM SALVO", "LAVA ROOM", "BOSS") : dw !lf
option_level65_tilemap: %store_text("*BONUS*", "2ND ROOM") : dw !lf
option_level66_tilemap: %store_text("BRIGHT - TOP LEFT", "DARK - BOTTOM LEFT", "BRIGHT - TOP RIGHT", "BRIGHT - MID LEFT", "GOAL ROOM") : dw !lf
option_level67_tilemap: %store_text("2ND ROOM", "3RD ROOM", "*BONUS* - SWITCHES", "GOAL ROOM") : dw !lf
option_level68_tilemap: %store_text("PICK A DOOR ROOM", "DOOR 1", "DOOR 2", "DOOR 3", "DOOR 4", "KAMEK'S MAGIC AUTOSCROLLER", "BOSS - BABY BOWSER", "BOSS - BIG BOWSER") : dw !lf
option_level6E_tilemap: %store_text("2ND ROOM", "3RD ROOM", "4TH ROOM - BASEBALL", "5TH ROOM", "6TH ROOM", "7TH ROOM - WATER") : dw !lf

option_world6_tilemaps_addr_table:
    dw option_level61_tilemap, option_level62_tilemap, option_level63_tilemap, option_level64_tilemap
    dw option_level65_tilemap, option_level66_tilemap, option_level67_tilemap, option_level68_tilemap, option_level6E_tilemap
