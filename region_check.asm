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
    level_init_hijack = $01C420

    room_init_hijack = $01C447

    room_init_music_hijack = $01C493

    baby_bowser_hijack = $0DC8B0

    hookbill_mode7_hdma_hijack = $019E50

    level_main_hijack = $01D2BB

    map_init_hijack = $17A83D
; save_level_hijack
    save_current_area = $01C2B6
; level_load_hijack
    level_load_camera = $04DBC9
; debug hijacks
    start_select_check = $01D31D

    file_select_check = $179890
        !file_select_check_jump = $992B

    interrupt_freespace = $00CC8A ; targeting the credits text because freespace is limited in JP
        !interrupt_freespace_size = $0432 ; credits pointers follow at $00D0BC-$00D0FF
    
    free_movement = $04F5E7

    level_intro_wait = $01C3FA
    
    map_icon_rotation = $17E700

    world_map_prev_fold_away = $17CD3C

    world_map_new_fold_in = $17CEC5

    save_eggs_to_wram = $01C4E9
    
    load_eggs_from_wram = $01C508

    despawn_sprite_free_slot = $03A32E ; X: sprite slot

    vram_dma_01 = $00BC47

elseif read1($00FFD9) == $01
    print "North American 1.0 ROM"
;=================================
    level_init_hijack = $01B1EE

    room_init_hijack = $01B215

    room_init_music_hijack = $01B261

    baby_bowser_hijack = $0DC55B

    hookbill_mode7_hdma_hijack = $019E4E

    level_main_hijack = $01C0DB

    map_init_hijack = $17A877

; save_level_hijack
    save_current_area = $01B084
; level_load_hijack
    level_load_camera = $04DC2E
; debug hijacks
    start_select_check = $01C13D

    file_select_check = $179897
        !file_select_check_jump = $9932

    interrupt_freespace = $00F7A7
        !interrupt_freespace_size = $07F0

    free_movement = $04F64C

    level_intro_wait = $01B1C8

    map_icon_rotation = $17E73E

    world_map_prev_fold_away = $17CD76

    world_map_new_fold_in = $17CEFB

    save_eggs_to_wram = $01B2B7

    load_eggs_from_wram = $01B2D6

    despawn_sprite_free_slot = $03A32E ; X: sprite slot

    vram_dma_01 = $00BEA6

;=================================
else
    print "Unknown Region"
    error "Bad Region"

endif