!title_tilemap_dest = $0006
title_tilemap:
incsrc "../resources/string_font_map.asm"
; CuteShrug
dw $0040, $0041, $0042
dw "PRACTICE HACK 0.4.4"
; CuteShrug
dw $0040, $0041, $0042

mainmenu_tilemap:
%store_text("GAME MODS/",
            "WARPS/",
            "         EGG EDITOR",
            "         FULL LOAD AS DEFAULT",
            "         RE-ZONE LEVEL",
            "         LOAD DELAY",
            "         HUD",
            "         RAMWATCH",
            "INPUT CONFIG/")

submenu_gamemods_tilemap:
%store_text("BACK",
            "DISABLE AUTOSCROLL",
            "         DISABLE MUSIC",
            "         FREE MOVEMENT",
            "         SET TUTORIAL FLAGS",
            "         DISABLE KAMEK AT BOSS",
            "         FORCE HASTY",
            "         SLOWDOWN AMOUNT",
            "         FRAME ADVANCE MODE")

submenu_config_tilemap:
%store_text("BACK             RESET DEFAULT",
            "PAD 1 : PAD 2",
            "                 SAVE",
            "                 LOAD",
            "                 LOAD FULL",
            "                 RE-ZONE",
            "                 FREE MOVEMENT",
            "                 SLOWDOWN -",
            "                 SLOWDOWN +",
            "                 FRAME ADVANCE",
            "                 NO AUTOSCROLL")

;====================================
; Warp Options
;

!warps_title_tilemap_dest = $009A

option_back_tilemap: dw "BACK"
option_start_tilemap: dw "START"

option_worlds_tilemap: %store_text("WORLD 1", "WORLD 2", "WORLD 3", "WORLD 4", "WORLD 5", "WORLD 6")

option_world1_tilemap: %store_text("1-1", "1-2", "1-3", "1-4", "1-5", "1-6", "1-7", "1-8", "1-E")
option_world2_tilemap: %store_text("2-1", "2-2", "2-3", "2-4", "2-5", "2-6", "2-7", "2-8", "2-E")
option_world3_tilemap: %store_text("3-1", "3-2", "3-3", "3-4", "3-5", "3-6", "3-7", "3-8", "3-E")
option_world4_tilemap: %store_text("4-1", "4-2", "4-3", "4-4", "4-5", "4-6", "4-7", "4-8", "4-E")
option_world5_tilemap: %store_text("5-1", "5-2", "5-3", "5-4", "5-5", "5-6", "5-7", "5-8", "5-E")
option_world6_tilemap: %store_text("6-1", "6-2", "6-3", "6-4", "6-5", "6-6", "6-7", "6-8", "6-E")

option_world_tilemaps_addr_table:
    dw option_world1_tilemap, option_world2_tilemap, option_world3_tilemap, option_world4_tilemap, option_world5_tilemap, option_world6_tilemap

option_level11_tilemap: %store_text("*CAVE (LEFT SIDE)")
option_level12_tilemap: %store_text("MAIN 2", "END")
option_level13_tilemap: %store_text("CAVE", "*SEE-SAW", "CAVE (FROM SEE-SAW LEFT)", "END")
option_level14_tilemap: %store_text("MAIN 2", "*PIRO DANGLES", "PRE-BOSS", "BOSS")
option_level15_tilemap: %store_text("")
option_level16_tilemap: %store_text("*CLOUD", "CAVE 1", "OUTSIDE", "*MOLE", "OUTSIDE (FROM MOLE)", "CAVE 2", "END")
option_level17_tilemap: %store_text("END", "*BEANSTALK")
option_level18_tilemap: %store_text("WATER (BOTTOM LEFT)", "WATER (TOP LEFT)", "SPIKE PLATFORMS", "PRE-BOSS", "BOSS")
option_level1E_tilemap: %store_text("")

option_world1_tilemaps_addr_table:
    dw option_level11_tilemap, option_level12_tilemap, option_level13_tilemap, option_level14_tilemap
    dw option_level15_tilemap, option_level16_tilemap, option_level17_tilemap, option_level18_tilemap, option_level1E_tilemap

option_level21_tilemap: %store_text("*GATEHACK FLOWER", "POOCHEY", "MAIN 2 (FALLING BLOCKS)", "*STICKY CEILING")
option_level22_tilemap: %store_text("MAIN 2", "MAIN 3")
option_level23_tilemap: %store_text("CAVE", "*NEP-ENUT")
option_level24_tilemap: %store_text("MAIN", "*BIG BOOS FLOWER", "BOO PLATFORMS", "MAIN (FROM PLATFORMS)", "LAVA", "EGGS", "*DARK ROOM", "PRE-BOSS", "BOSS")
option_level25_tilemap: %store_text("TRAIN", "MAIN 1 (FROM TRAIN)", "MAIN 2", "*3D PLATFORMS", "*SUPER BABY MARIO")
option_level26_tilemap: %store_text("CAVE", "*LANTERN GHOSTS", "MIDRING", "MOVING BLOCKS", "OUTSIDE")
option_level27_tilemap: %store_text("*TUNNEL", "MAIN 1 (FROM TUNNEL)", "FALLING BLOCKS", "MAIN 2", "*FOAM PIPES", "MAIN 2 (FROM FOAM PIPES)", "CAR")
option_level28_tilemap: %store_text("LAVA", "ARROW LIFT 1", "*TRAIN", "KEY", "SPIKED LOG", "*BURTS FLOWER", "ARROW LIFT 2", "BANDITS", "PRE-BOSS", "BOSS")
option_level2E_tilemap: %store_text("*STARS")

option_world2_tilemaps_addr_table:
    dw option_level21_tilemap, option_level22_tilemap, option_level23_tilemap, option_level24_tilemap
    dw option_level25_tilemap, option_level26_tilemap, option_level27_tilemap, option_level28_tilemap, option_level2E_tilemap

option_level31_tilemap: %store_text("MAIN 2", "*BIG DONUTS", "MAIN 3")
option_level32_tilemap: %store_text("*PIPE REDS", "*POOCHEY")
option_level33_tilemap: %store_text("MAIN 2", "*SHYGUYS FLOWER", "MAIN 3 (SUBMARINE)", "MAIN 4 (FROG BOUNCE)", "MAIN 5")
option_level34_tilemap: %store_text("*SUBMARINE", "MAIN 1 (FROM SUBMARINE)", "MAIN 2", "*CRABS", "MAIN 2 (FROM CRABS)", "*BUCKET ROOM", "CRAB TUNNEL", "SPIKES", "PRE-BOSS", "BOSS")
option_level35_tilemap: %store_text("MAIN 2", "*EGG PLANT PLATFORM", "MAIN 3")
option_level36_tilemap: %store_text("CAVE", "*SWITCH JUMP", "OUTSIDE")
option_level37_tilemap: %store_text("*SUBMARINE", "MAIN 2", "*CANOPY", "MAIN 2 (FROM CANOPY)", "MAIN 3")
option_level38_tilemap: %store_text("MAIN 1", "PIPES", "MAIN 2", "BOSS")
option_level3E_tilemap: %store_text("*STARS")

option_world3_tilemaps_addr_table:
    dw option_level31_tilemap, option_level32_tilemap, option_level33_tilemap, option_level34_tilemap
    dw option_level35_tilemap, option_level36_tilemap, option_level37_tilemap, option_level38_tilemap, option_level3E_tilemap

option_level41_tilemap: %store_text("*CAVE", "MAIN 1 (FROM CAVE)", "FUZZIES", "MAIN 2")
option_level42_tilemap: %store_text("MAIN 1", "*LONG FALL", "MAIN 1 (FROM FALL)", "MAIN 2", "*RED COIN")
option_level43_tilemap: %store_text("*HELICOPTER", "END")
option_level44_tilemap: %store_text("HUB", "TOP RIGHT", "BOTTOM RIGHT 1", "BOTTOM RIGHT 2", "TOP LEFT", "BOTTOM LEFT", "1ST KEY", "2ND KEY", "3RD KEY", "BOSS")
option_level45_tilemap: %store_text("MAIN 2", "*BASEBALL FLOWER")
option_level46_tilemap: %store_text("*SMALL ROOM WITH TULIP", "CAVE 1", "CAVE 2", "*DOUBLE ARROW LIFTS", "OUTSIDE")
option_level47_tilemap: %store_text("*BALLOON PUMP ROOM", "MAIN 2 (PLATFORMS)")
option_level48_tilemap: %store_text("MAIN 2 (LEFT)", "MAIN 2 (MIDDLE)", "MAIN 2 (RIGHT)", "*GIANT MILDES", "FISHING LAKITU", "TETRIS", "BOSS")
option_level4E_tilemap: %store_text("BRIGHT (MAIN MIDDLE DOOR)", "DARK (EGG POOL)", "BRIGHT (TOP LEFT)", "DARK (MOLE)", "BRIGHT (RED EGG BLOCKS)", "DARK (HELICOPTER)", "BRIGHT (FLASHING EGGS)", "DARK (END WATERFALL)")

option_world4_tilemaps_addr_table:
    dw option_level41_tilemap, option_level42_tilemap, option_level43_tilemap, option_level44_tilemap
    dw option_level45_tilemap, option_level46_tilemap, option_level47_tilemap, option_level48_tilemap, option_level4E_tilemap

option_level51_tilemap: %store_text("*HELICOPTER", "CAVE", "OUTSIDE", "*TULIPS")
option_level52_tilemap: %store_text("SKI LIFTS 1", "SKI LIFTS 2", "*ICE CORE")
option_level53_tilemap: %store_text("MAIN 2 (SUPER BABY MARIO)", "*HELICOPTER", "MAIN 3 (SKI LIFTS)", "SKIING 1", "SKIING 2", "SKIING 3", "END")
option_level54_tilemap: %store_text("*FLOWER", "*MUDDY BUDDY", "MAIN 1 (MID-RING)", "MAIN 2", "5-4 SKIP", "PRE-BOSS", "BOSS")
option_level55_tilemap: %store_text("*PENGUINS FLOWER", "MAIN 2 (HELICOPTER)", "MAIN 3")
option_level56_tilemap: %store_text("MAIN 2 (POST-AUTOSCROLLER)", "*PIPES")
option_level57_tilemap: %store_text("*FLOWER", "MAIN 2", "MAIN 3")
option_level58_tilemap: %store_text("MAIN 2", "ARROW LIFT", "MAIN 3", "*TRAIN", "BOSS", "BOSS (MOON)")
option_level5E_tilemap: %store_text("SKIING 1", "SKIING 2", "SKIING 3", "END")

option_world5_tilemaps_addr_table:
    dw option_level51_tilemap, option_level52_tilemap, option_level53_tilemap, option_level54_tilemap
    dw option_level55_tilemap, option_level56_tilemap, option_level57_tilemap, option_level58_tilemap, option_level5E_tilemap

option_level61_tilemap: %store_text("*CONVEYOR RIDE", "MAIN 2 (CHOMPS)", "MAIN 3")
option_level62_tilemap: %store_text("MAIN 2", "MAIN 3 (SPIKES)")
option_level63_tilemap: %store_text("MAIN 2", "*5 ROOMS")
option_level64_tilemap: %store_text("PRE-SALVO", "SALVO", "DARK (FROM SALVO)", "LAVA SKIP", "BOSS")
option_level65_tilemap: %store_text("*FOAM ROOM", "MAIN 2 (AUTOSCROLLER SKIP)")
option_level66_tilemap: %store_text("BRIGHT (TOP LEFT)", "DARK (BOTTOM LEFT)", "BRIGHT (TOP RIGHT)", "BRIGHT (MID LEFT)", "END")
option_level67_tilemap: %store_text("MAIN 2", "MAIN 3 (SUPER BABY MARIO)", "*SWITCHES", "END")
option_level68_tilemap: %store_text("PICK A DOOR", "DOOR 1", "DOOR 2", "DOOR 3", "DOOR 4", "KAMEK'S MAGIC AUTOSCROLLER", "BOSS (BABY BOWSER)", "BOSS (BIG BOWSER)")
option_level6E_tilemap: %store_text("INSIDE", "YOSSY", "BASEBALL", "LONG FALL 1", "LONG FALL 2", "WATER")

option_world6_tilemaps_addr_table:
    dw option_level61_tilemap, option_level62_tilemap, option_level63_tilemap, option_level64_tilemap
    dw option_level65_tilemap, option_level66_tilemap, option_level67_tilemap, option_level68_tilemap, option_level6E_tilemap
