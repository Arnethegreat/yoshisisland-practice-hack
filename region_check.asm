lorom
;=================================
; check for version in internal header
; error if bad version
if read1($00FFDB) != $00
    print "1.1 ROM version are not supported yet (ask me about it)"
    error "Version Error"
endif
;=================================
; read destination code
; set labels for org during hijacks depending on version
if read1($00FFD9) == $00
    print "Japan 1.0 ROM"
;=================================
    savefile_check_hijack = $0080A8

    level_room_preinit_hijack = $01C1CE

    level_init_hijack = $01C420

    room_init_hijack = $01C447

    underwater_room_hijack = $01E811

    baby_bowser_hijack = $0DC8B0

    hookbill_mode7_hdma_hijack = $019E50

    raphael_hijack = $0FB9FF

    level_main_hijack = $01D2B9

    level_header_hijack = $01C2EA

    main_spinning_wooden_platform_hijack = $029372

    load_intro_hijack = $10DA95

    map_init_hijack = $17A83D

    score_screen_init_hijack = $01CC20

    current_room_exit_hijack = $01C2B6

    level_load_camera = $04DBC9

    start_select_check = $01D31D

    file_select_check = $179890
        !file_select_check_jump = $992B

    interrupt_freespace = $00CC8A ; targeting the credits text because freespace is limited in JP
        !interrupt_freespace_size = $0432 ; credits pointers follow at $00D0BC-$00D0FF
    
    irq_1_set_vcount = $00C452
    irq_2_start = $00C465
    irqmode_02 = $00C48D
    irqmode_02_regupd_general = $00C584
    irqmode_02_regupd_bg3 = $00C567
    irqmode_04 = $00C5FE
    irqmode_08 = $00C8A8
    irqmode_0A = $00C641
    nmi_hijack = $00C013

    change_map16_hijack = $10925C
    
    free_movement = $04F5E7

    play_music_track = $00C024

    level_intro_wait = $01C3FA

    scorescreen_state_pointers = $01C7C4
        !scorescreen_skip_state = $C803

    game_mode_22 = $17B393
    game_mode_26 = $17A9E0

    map_icon_rotation = $17E700

    world_map_prev_fold_away = $17CD3C

    world_map_new_fold_in = $17CEC5

    item_memory_page_pointers = $01F5E3

    save_eggs_to_wram = $01C4E9
    load_eggs_from_wram = $01C508

    spawn_sprite = $03A377

    acquire_egg = $03BEC4

    despawn_sprite_free_slot = $03A32E ; X: sprite slot

    gsu_update_camera_store = $09984E

    bank09_freespace = $09B140

    upload_data_to_spc = $0085A9
        !music_overworld = hirom_mirror($1EC122)

    vram_dma_01 = $00BC47

    r_gsu_init_1 = $7EDC3C

elseif read1($00FFD9) == $01
    print "North American 1.0 ROM"
;=================================
    savefile_check_hijack = $0080BB

    level_room_preinit_hijack = $01AF9C

    level_init_hijack = $01B1EE

    room_init_hijack = $01B215

    underwater_room_hijack = $01D707

    baby_bowser_hijack = $0DC55B

    hookbill_mode7_hdma_hijack = $019E4E

    raphael_hijack = $0FAD27

    level_main_hijack = $01C0D9

    level_header_hijack = $01B0B8

    main_spinning_wooden_platform_hijack = $029372

    load_intro_hijack = $10DB79

    map_init_hijack = $17A877

    score_screen_init_hijack = $01BA14

    current_room_exit_hijack = $01B084

    level_load_camera = $04DC2E

    start_select_check = $01C13D

    file_select_check = $179897
        !file_select_check_jump = $9932

    interrupt_freespace = $00F7A7
        !interrupt_freespace_size = $07F0
    
    irq_1_set_vcount = $00C452
    irq_2_start = $00C465
    irqmode_02 = $00C48D
    irqmode_02_regupd_general = $00C584
    irqmode_02_regupd_bg3 = $00C567
    irqmode_04 = $00C5FE
    irqmode_08 = $00C87A
    irqmode_0A = $00C641
    nmi_hijack = $00C013

    change_map16_hijack = $109303

    free_movement = $04F64C

    play_music_track = $00C024

    level_intro_wait = $01B1C8

    scorescreen_state_pointers = $01B592
        !scorescreen_skip_state = $B5D1

    game_mode_22 = $17B3CD
    game_mode_26 = $17AA1A

    map_icon_rotation = $17E73E

    world_map_prev_fold_away = $17CD76

    world_map_new_fold_in = $17CEFB

    item_memory_page_pointers = $01E4D9

    save_eggs_to_wram = $01B2B7
    load_eggs_from_wram = $01B2D6

    spawn_sprite = $03A377

    acquire_egg = $03BEB9

    despawn_sprite_free_slot = $03A32E ; X: sprite slot

    gsu_update_camera_store = $09984E

    bank09_freespace = $09AF70

    upload_data_to_spc = $0085A9
        !music_overworld = hirom_mirror($1EC122)

    vram_dma_01 = $00BEA6

    r_gsu_init_1 = $7EDE44

;=================================
else
    print "Unknown Region"
    error "Bad Region"
endif
